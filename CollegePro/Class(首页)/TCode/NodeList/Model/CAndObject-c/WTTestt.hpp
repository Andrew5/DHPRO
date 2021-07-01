//
//  WTTestt.hpp
//  CollegePro
//
//  Created by jabraknight on 2021/6/19.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#ifndef WTTestt_hpp
#define WTTestt_hpp

#include <stdio.h>
// ===================== WTTestt.h =====================
// ===================== C++ 头文件 =====================
#ifndef Person_h
#define Person_h

#include <stdio.h>
#include <string.h>
#include <iostream>

#endif /* Person_h */

namespace cppdemo {
    
    class WTTestt {
    public:
        ~WTTestt();
        int age;
        void sayHello();
        // 默认构造函数
        WTTestt();
        // 带参数的构造函数
        WTTestt(int _age, std::string _name);
    private:
        std::string name;
    };

}
#endif /* WTTestt_hpp */
