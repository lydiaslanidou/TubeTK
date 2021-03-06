/*=========================================================================

Library:   TubeTK

Copyright 2010 Kitware Inc. 28 Corporate Drive,
Clifton Park, NY, 12065, USA.

All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=========================================================================*/

#include "itkOtsuThresholdImageFilter.h"
#include "tubeCLIFilterWatcher.h"
#include "tubeCLIProgressReporter.h"
#include "tubeMessage.h"

#include <itkImageFileReader.h>
#include <itkImageFileWriter.h>
#include <itkTimeProbesCollectorBase.h>

#include "SegmentUsingOtsuThresholdCLP.h"

template< class TPixel, unsigned int VDimension >
int DoIt( int argc, char * argv[] );

// Must follow include of "...CLP.h" and forward declaration of int DoIt( ... ).
#include "tubeCLIHelperFunctions.h"

template< class TPixel, unsigned int VDimension >
int DoIt( int argc, char * argv[] )
{
  PARSE_ARGS;

  // The timeCollector is used to perform basic profiling of the components
  //   of your algorithm.
  itk::TimeProbesCollectorBase timeCollector;

  // CLIProgressReporter is used to communicate progress with the Slicer GUI
  tube::CLIProgressReporter progressReporter(
    "OtsuThreshold",
    CLPProcessInformation );
  progressReporter.Start();

  typedef float                                           PixelType;
  typedef unsigned char                                   OutPixType;
  typedef itk::Image< PixelType, VDimension >             ImageType;
  typedef itk::Image< OutPixType, VDimension >            OutputType;
  typedef itk::ImageFileReader< ImageType >               ReaderType;
  typedef itk::ImageFileWriter< OutputType  >             WriterType;
  typedef itk::OtsuThresholdImageFilter< ImageType, OutputType, ImageType >
                                                          FilterType;

  timeCollector.Start("Load data");
  typename ReaderType::Pointer reader = ReaderType::New();
  reader->SetFileName( inputVolume.c_str() );
  try
    {
    reader->Update();
    }
  catch( itk::ExceptionObject & err )
    {
    tube::ErrorMessage( "Reading volume: Exception caught: "
                        + std::string(err.GetDescription()) );
    timeCollector.Report();
    return EXIT_FAILURE;
    }
  typename ImageType::Pointer inputImage = reader->GetOutput();

  typename ImageType::Pointer maskImage = NULL;
  if( maskVolume.size() > 0 )
    {
    typename ReaderType::Pointer maskReader = ReaderType::New();
    maskReader->SetFileName( maskVolume.c_str() );
    try
      {
      maskReader->Update();
      }
    catch( itk::ExceptionObject & err )
      {
      tube::ErrorMessage( "Reading volume: Exception caught: "
                          + std::string(err.GetDescription()) );
      timeCollector.Report();
      return EXIT_FAILURE;
      }
    maskImage = maskReader->GetOutput();
    }

  timeCollector.Stop("Load data");
  double progress = 0.1;
  progressReporter.Report( progress );

  timeCollector.Start("Gaussian Blur");

  typename OutputType::Pointer outImage;
  typename FilterType::Pointer filter;

  // Progress per iteration
  double progressFraction = 0.8/VDimension;

  filter = FilterType::New();
  filter->SetInput( inputImage );
  if( maskImage.IsNotNull() )
    {
    filter->SetMaskImage( maskImage );

    // Note: Output masking only keeps values at positions p, where mask(p) is
    // NOT equal to zero. We do not want that here.
    filter->SetMaskOutput( false );

    // Note: only pixels at positions p where mask(p) == 0 are taken into
    // account for thresholding. So, a mask is interpreted in an inclusion
    // sense, rather than an exclusion sense. Hence, for a binary, i.e., 0/1
    // mask to be used in the intuitive (i.e., we do not care about the mask
    // region), we need to set the mask value to zero.
    filter->SetMaskValue( 0 );
    }

  tube::CLIFilterWatcher watcher( filter,
                                  "OtsuThreshold",
                                  CLPProcessInformation,
                                  progressFraction,
                                  progress,
                                  true );
  filter->SetOutsideValue( 0 );
  filter->SetInsideValue( 1 );
  filter->Update();
  std::cout << filter->GetThreshold() << std::endl;
  outImage = filter->GetOutput();

  std::cout << "Chosen threshold = " << filter->GetThreshold()
    << std::endl;

  timeCollector.Stop("Gaussian Blur");

  timeCollector.Start("Save data");
  typename WriterType::Pointer writer = WriterType::New();
  writer->SetFileName( outputVolume.c_str() );
  writer->SetInput( outImage );
  writer->SetUseCompression( true );
  try
    {
    writer->Update();
    }
  catch( itk::ExceptionObject & err )
    {
    tube::ErrorMessage( "Writing volume: Exception caught: "
                        + std::string(err.GetDescription()) );
    timeCollector.Report();
    return EXIT_FAILURE;
    }
  timeCollector.Stop("Save data");
  progress = 1.0;
  progressReporter.Report( progress );
  progressReporter.End();

  timeCollector.Report();
  return EXIT_SUCCESS;
}

// Main
int main( int argc, char * argv[] )
{
  PARSE_ARGS;

  // You may need to update this line if, in the project's .xml CLI file,
  //   you change the variable name for the inputVolume.
  return tube::ParseArgsAndCallDoIt( inputVolume, argc, argv );
}
