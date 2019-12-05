/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_FRAME_HPP__
#define __EASYAR_FRAME_HPP__

#include "easyar/base.hpp"

namespace EasyAR {

class AugmentedTargetList;

class Frame : public RefBase
{
public:
    Frame();
    virtual ~Frame();

    double timeStamp() const;
    int index() const;
    ImageList images();
    AugmentedTargetList targets();
    const char* text();
};

}

#endif
