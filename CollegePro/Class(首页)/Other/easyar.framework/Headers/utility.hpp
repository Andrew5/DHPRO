/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_UTILITY_HPP__
#define __EASYAR_UTILITY_HPP__

#include "easyar/base.hpp"
#include "easyar/matrix.hpp"

namespace EasyAR {

class CameraCalibration;

Matrix44F getProjectionGL(const CameraCalibration& calib, float nearPlane, float farPlane);
Matrix44F getPoseGL(const Matrix34F& pose);

bool initialize(const char* key);
void onResume();
void onPause();
void setRotation(int rotation);
void setRotationIOS(int rotation);
const char* versionString();
}
#endif
