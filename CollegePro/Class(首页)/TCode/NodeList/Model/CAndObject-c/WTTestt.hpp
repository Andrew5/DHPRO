//
//  WTTestt.hpp
//  TestProgress
//
//  Created by admin on 2020/7/7.
//  Copyright © 2020 happyness. All rights reserved.
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
