/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_BASE_HPP__
#define __EASYAR_BASE_HPP__

namespace EasyAR {

class RefData;

class RefBase
{
public:
    RefBase();
    virtual ~RefBase();

    RefBase(const RefBase& b);
    RefBase& operator=(const RefBase& b);

    operator bool() const;
    bool operator ==(const RefBase& other) const;
    bool operator !=(const RefBase& other) const;
    template<class T> T cast_dynamic() const { return cast_dynamic(static_cast<T*>(0)); }
    template<class T> T cast_static() const { return cast_static(static_cast<T*>(0)); }
    void clear();
protected:
    template<class T> T cast_dynamic(T* t) const;
    template<class T> T cast_static(T* t) const;
    RefData* data_;
};

}

#endif
