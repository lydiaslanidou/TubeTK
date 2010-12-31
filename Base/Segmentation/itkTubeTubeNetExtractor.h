/*=========================================================================

Library:   TubeTK/VTree

Authors: Stephen Aylward, Julien Jomier, and Elizabeth Bullitt

Original implementation:
Copyright University of North Carolina, Chapel Hill, NC, USA.

Revised implementation:
Copyright Kitware Inc., Carrboro, NC, USA.

All rights reserved.

Licensed under the Apache License, Version 2.0 ( the "License" );
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=========================================================================*/
#ifndef __itkTubeTubeNetExtractor_h
#define __itkTubeTubeNetExtractor_h

#include "itkTubeTubeExtractor.h"
//#include <TubeIO/itkTubeNet.h>

namespace itk
{

namespace tube
{

/**
 * This class extract the a tube given an image
 *
 * /sa itkTubeTubeNetExtractor
 */

template <class TInputImage, class TInputMask>
class ITK_EXPORT TubeNetExtractor : public TubeExtractor<TInputImage>
{
public:

  /**
   * Standard self typedef */
  typedef TubeNetExtractor          Self;
  typedef Object                    Superclass;
  typedef SmartPointer<Self>        Pointer;
  typedef SmartPointer<const Self>  ConstPointer;

  itkTypeMacro( Self, Object );

  itkNewMacro( Self );

  /**
   * Type definition for the input image. */
  typedef TInputImage                      ImageType;

  /**
   * Type definition for the input mask. */
  typedef TInputMask                       MaskType;

  /**
   * Input image pixel type. */
  typedef typename TInputImage::PixelType  PixelType;

  /**
   * Input image index type. */
  typedef typename TInputImage::IndexType  IndexType;

  /**
   * Standard for the number of dimension
   */
  itkStaticConstMacro( ImageDimension, unsigned int,
    ::itk::GetImageDimension< TInputImage>::ImageDimension );

  /** Typedef for TubeSpatialObject */
  typedef VesselTubeSpatialObject< ImageDimension >    TubeType;

  /**
   * Defines the type of vectors used
   */
  typedef Vector<double, ImageDimension>               VectorType;

  /**
   * Set the input image */
  void SetInputImage( typename ImageType::Pointer inputImage );

  /**
   * Get the input image */
  itkGetConstObjectMacro( Image, ImageType );

  /**
   * Extract a 3D tube */
  bool ExtractTube( float x, float y, float z );

  /**
   * Delete a tube */
  bool DeleteTube( TubeType * newTube );

  /**
   * Get the tube Net */
  typename TubeType::Pointer GetTubeNet( void );

  /**
   * Set use mask */
  itkSetMacro( AEUseMask,bool );

  /**
   * Get use mask */
  itkGetMacro( AEUseMask,bool );

  /**
   * Set the mask  */
  void SetAutoExtractMask( typename MaskType::Pointer autoExtractMask );

  /**
   * Get the mask  */
  itkGetConstObjectMacro( AEMask, MaskType );

  /**
   * Auto extract tubes using a mask */
  double  AutoExtractThresh( void );

  /**
   * Auto extract tubes using a mask */
  void   AutoExtractThresh( double newAEThresh );

  /**
   * Auto extract tubes using a mask */
  void   AutoExtractAutoThresh( double alpha=0.002 );

  /**
   * AutoExtract tubes */
  bool   AutoExtract( int zMin, int zMax );

  /**
   * Generate output mask */
  void   DrawVesselMask( MaskType * maskImage );

  /**
   * Save a tube net */
  //bool   Save( char *fname );

  /**
   * Load a tube net*/
  //bool   Load( char *fname );

  /**
   * Set the tube callback */
  void   NewTubeCallBack( void ( *newTubeCallBack )( TubeType * ) );

protected:

  TubeNetExtractor();
  virtual ~TubeNetExtractor();
  TubeNetExtractor( const Self& ) {}
  void operator=( const Self& ) {}

  void PrintSelf( std::ostream & os, Indent indent ) const;

private:

  typename ImageType::Pointer      m_Image;
  typename TubeType::Pointer       m_TubeNet;
  int                              m_TubeNum;

  bool                             m_AEUseMask;
  typename MaskType::Pointer       m_AEMask;
  float                            m_AEThresh;

};

} // end namespace tube

} // end namespace itk


#ifndef ITK_MANUAL_INSTANTIATION
#include "itkTubeTubeNetExtractor.txx"
#endif

#endif /* __itkTubeTubeNetExtractor_h */