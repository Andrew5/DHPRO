/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_IMAGETARGET_HPP__
#define __EASYAR_IMAGETARGET_HPP__

#include "easyar/target.hpp"

namespace EasyAR {

class ImageTarget : public Target
{
public:
    ImageTarget();
    virtual ~ImageTarget();

    virtual bool load(const char* path, int storageType, const char* name = 0);
    static TargetList loadAll(const char* path, int storageType);
    Vec2F size() const;
    bool setSize(const Vec2F& size);
};

}
#endif
