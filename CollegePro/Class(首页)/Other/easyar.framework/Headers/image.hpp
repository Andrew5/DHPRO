/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_IMAGE_HPP__
#define __EASYAR_IMAGE_HPP__

#include "easyar/base.hpp"

namespace EasyAR {

enum PixelFormat
{
    kPixelFormatUnknown,
    kPixelFormatGray,
    kPixelFormatYUV_NV21,
    kPixelFormatYUV_NV12,
    kPixelFormatRGB888,
    kPixelFormatBGR888,
    kPixelFormatRGBA8888,
};

class Image : public RefBase
{
public:
    Image();
    virtual ~Image();

    int width() const;
    int height() const;
    int stride() const;
    PixelFormat format() const;
    const void* data() const;
};

class ImageList : public RefBase
{
public:
    ImageList();
    virtual ~ImageList();

    int size() const;
    Image operator [](int idx);
    Image at(int idx);
};

}

#endif
