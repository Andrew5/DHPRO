//
//  WTTestt.cpp
//  CollegePro
//
//  Created by jabraknight on 2021/6/19.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#include "WTTestt.hpp"
//#include "WTTestt.hpp"
// ===================== WTTestt.cpp =====================
// ===================== C++ 实现文件 =====================
namespace cppdemo {
    // '::' 表示是 class Person 中的方法
    // class Person 中的默认构造函数
    WTTestt::WTTestt() {
        this->age = 10;
        this->name = "Tommy";
    }
    WTTestt::WTTestt(int _age, std::string _name) {
        this->age = _age;
        this->name = _name;
    }
    // 以上方法等同与下面这种实现
//    Person::Person(int _age, std::string _name): age(_age), name(_name) {
//
//    }
    void WTTestt::sayHello() {
        std::cout << name << " hello age: " << age << "\n";
    }
}
