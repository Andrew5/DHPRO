/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_PLAYER_HPP__
#define __EASYAR_PLAYER_HPP__

#include "easyar/base.hpp"
#include "easyar/storage.hpp"
#include "easyar/matrix.hpp"

namespace EasyAR {

class VideoPlayerCallBack;

class VideoPlayer : public RefBase
{
public:
    enum Status
    {
        kVideoError = -1,
        kVideoReady,
        kVideoCompleted,
    };
    enum VideoType
    {
        kVideoTypeNormal,
        kVideoTypeTransparentSideBySide,
        kVideoTypeTransparentTopAndBottom,
    };

    VideoPlayer();
    virtual ~VideoPlayer();

    //! should be called before open
    void setRenderTexture(int texture);
    //! only have effect when called before open
    void setVideoType(VideoType videoType);

    void open(const char* path, StorageType storageType, VideoPlayerCallBack* callback = 0);
    void close();

    bool play();
    bool stop();
    bool pause();
    void updateFrame();

    int duration();
    int currentPosition();
    bool seek(int position);
    Vec2I size();
    float volume();
    bool setVolume(float volume);
};

class VideoPlayerCallBack
{
public:
    virtual void operator() (VideoPlayer::Status status) = 0;
};

}

#endif
