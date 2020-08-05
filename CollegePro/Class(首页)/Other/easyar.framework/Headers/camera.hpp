/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_CAMERA_HPP__
#define __EASYAR_CAMERA_HPP__

#include "easyar/base.hpp"
#include "easyar/matrix.hpp"

namespace EasyAR {

class CameraCalibration : public RefBase
{
public:
    CameraCalibration();
    ~CameraCalibration();

    Vec2I size() const;
    Vec2F focalLength() const;
    Vec2F principalPoint() const;
    Vec4F distortionParameters() const;
};

class CameraDevice : public RefBase
{
public:
    CameraDevice();
    virtual ~CameraDevice();

    enum FocusMode
    {
        kFocusModeNormal,
        kFocusModeTriggerauto,
        kFocusModeContinousauto,
        kFocusModeInfinity,
        kFocusModeMacro,
    };

    enum Device
    {
        kDeviceDefault,
        kDeviceBack,
        kDeviceFront,
    };

    virtual bool start();
    virtual bool stop();

    bool open(int camera = kDeviceDefault);
    //! auto detach from everything
    bool close();
    bool isOpened();
    void setHorizontalFlip(bool flip);

    float frameRate() const;
    int supportedFrameRateCount() const;
    float supportedFrameRate(int idx) const;
    //! the proximal value avalible will be selected, use frameRate to get the actural size
    bool setFrameRate(float fps);

    Vec2I size() const;
    int supportedSizeCount() const;
    Vec2I supportedSize(int idx) const;
    //! the proximal value avalible will be selected, use size to get the actural size
    bool setSize(Vec2I size);

    CameraCalibration cameraCalibration() const;
    bool setFlashTorchMode(bool on);
    bool setFocusMode(FocusMode focusMode);
};

}
#endif
