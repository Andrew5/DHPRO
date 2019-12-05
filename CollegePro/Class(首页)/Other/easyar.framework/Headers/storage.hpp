/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_STORAGE_HPP__
#define __EASYAR_STORAGE_HPP__

namespace EasyAR {

enum StorageType
{
    kStorageApp,
    kStorageAssets,
    kStorageAbsolute,
    kStorageJson = 1 << 8,
};

}
#endif
