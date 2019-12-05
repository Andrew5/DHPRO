/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_IMAGETRACKER_HPP__
#define __EASYAR_IMAGETRACKER_HPP__

#include "easyar/base.hpp"

namespace EasyAR {

class Target;
class TargetList;
class CameraDevice;

class TargetLoadCallBack
{
public:
    virtual void operator() (const Target dataset, const bool status) = 0;
};


class ImageTracker : public RefBase
{
public:
    ImageTracker();
    virtual ~ImageTracker();

    virtual bool attachCamera(const CameraDevice& obj);
    virtual bool detachCamera(const CameraDevice& obj);

    virtual void loadTarget(const Target& obj, TargetLoadCallBack* callback = 0);
    virtual bool loadTargetBlocked(const Target& obj);
    virtual void unloadTarget(const Target& obj, TargetLoadCallBack* callback = 0);
    virtual bool unloadTargetBlocked(const Target& obj);

    virtual TargetList targets();

    virtual bool start();
    virtual bool stop();

    virtual bool setSimultaneousNum(int num);
    virtual int simultaneousNum();
};

}

#endif
