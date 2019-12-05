/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#ifndef __EASYAR_MATRIX_HPP__
#define __EASYAR_MATRIX_HPP__

namespace EasyAR {

template<typename _Tp, int m, int n> class Matrix
{
public:
    Matrix();
    explicit Matrix(const _Tp* vals);
public:
    _Tp data[m*n];
};

template<typename _Tp, int cn> class Vec : public Matrix<_Tp, cn, 1>
{
public:
    Vec();
    explicit Vec(const _Tp* values);
    Vec(_Tp v0);
    Vec(_Tp v0, _Tp v1);
    Vec(_Tp v0, _Tp v1, _Tp v2);
    Vec(_Tp v0, _Tp v1, _Tp v2, _Tp v3);

    const _Tp& operator [](int i) const;
    _Tp& operator[](int i);
};

template<typename _Tp, int m, int n> inline
Matrix<_Tp, m, n>::Matrix()
{
    for (int i = 0; i < m*n; i++) data[i] = _Tp(0);
}

template<typename _Tp, int m, int n> inline
Matrix<_Tp, m, n>::Matrix(const _Tp* _data)
{
    for (int i = 0; i < m*n; i++) data[i] = _data[i];
}

template<typename _Tp, int cn> inline
Vec<_Tp, cn>::Vec() {}

template<typename _Tp, int cn> inline
Vec<_Tp, cn>::Vec(const _Tp* _data)
    : Matrix<_Tp, cn, 1>(_data) {}

template<typename _Tp, int cn> inline
Vec<_Tp, cn>::Vec(_Tp v0)
{
    this->data[0] = v0;
    for (int i = 1; i < cn; i++) this->data[i] = _Tp(0);
}

template<typename _Tp, int cn> inline
Vec<_Tp, cn>::Vec(_Tp v0, _Tp v1)
{
    this->data[0] = v0; this->data[1] = v1;
    for (int i = 2; i < cn; i++) this->data[i] = _Tp(0);
}

template<typename _Tp, int cn> inline
Vec<_Tp, cn>::Vec(_Tp v0, _Tp v1, _Tp v2)
{
    this->data[0] = v0; this->data[1] = v1; this->data[2] = v2;
    for (int i = 3; i < cn; i++) this->data[i] = _Tp(0);
}

template<typename _Tp, int cn> inline
Vec<_Tp, cn>::Vec(_Tp v0, _Tp v1, _Tp v2, _Tp v3)
{
    this->data[0] = v0; this->data[1] = v1; this->data[2] = v2; this->data[3] = v3;
    for (int i = 4; i < cn; i++) this->data[i] = _Tp(0);
}

template<typename _Tp, int cn> inline
const _Tp& Vec<_Tp, cn>::operator [](int i) const
{
    return this->data[i];
}

template<typename _Tp, int cn> inline
_Tp& Vec<_Tp, cn>::operator [](int i)
{
    return this->data[i];
}

template<typename _Tp, int m, int n>
bool operator == (const Matrix<_Tp, m, n>& m1, const Matrix<_Tp, m, n>& m2)
{
    for (int i = 0; i < m*n; ++i) {
        if (m1.data[i] != m2.data[i])
            return false;
    }
    return true;
}

template<typename _Tp, int m, int n>
bool operator != (const Matrix<_Tp, m, n>& m1, const Matrix<_Tp, m, n>& m2)
{
    return !(m1 == m2);
}

typedef Matrix<float, 3, 4> Matrix34F;
typedef Matrix<float, 4, 4> Matrix44F;
typedef Vec<float, 2> Vec2F;
typedef Vec<float, 3> Vec3F;
typedef Vec<float, 4> Vec4F;
typedef Vec<int, 2> Vec2I;
typedef Vec<int, 3> Vec3I;
typedef Vec<int, 4> Vec4I;
}

#endif
