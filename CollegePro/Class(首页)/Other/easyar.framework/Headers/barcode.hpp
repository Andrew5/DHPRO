/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_BARCODE_HPP__
#define __EASYAR_BARCODE_HPP__

#include "easyar/base.hpp"

namespace EasyAR {

class CameraDevice;

class BarCodeScanner : public RefBase
{
public:
    BarCodeScanner();
    virtual ~BarCodeScanner();

    virtual bool attachCamera(const CameraDevice& obj);
    virtual bool detachCamera(const CameraDevice& obj);

    virtual bool start();
    virtual bool stop();
};

}

#endif
