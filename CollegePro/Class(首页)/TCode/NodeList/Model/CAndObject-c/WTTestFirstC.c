//
//  WTTestFirstC.c
//  CollegePro
//
//  Created by jabraknight on 2021/6/19.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#include "WTTestFirstC.h"
int count ;

void write_extern01(int aa) {
    count = aa;
    
    int a = 21;
    int b = 10;
    int c ;
 
    c = a + b;
    printf("f 1 - c 的值是 %d\n", c );
    c = a - b;
    printf("Line 2 - c 的值是 %d\n", c );
    c = a * b;
    printf("Line 3 - c 的值是 %d\n", c );
    c = a / b;
    printf("Line 4 - c 的值是 %d\n", c );
    c = a % b;//取模运算符，整除后的余数
    printf("Line 5 - c 的值是 %d\n", c );
    c = a++;  // 赋值后再加 1 ，c 为 21，a 为 22
    printf("Line 6 - c 的值是 %d\n", c );
    c = a--;  // 赋值后再减 1 ，c 为 22 ，a 为 21
    printf("Line 7 - c 的值是 %d\n", c );
     
    printf("count is %d\n", count);
    
    int e;
       int f = 10;
       e = f++;
       printf("先赋值后运算：\n");
       printf("Line 1 - c 的值是 %d\n", e );
       printf("Line 2 - a 的值是 %d\n", f );
       f = 10;
       e = f--;
       printf("Line 3 - c 的值是 %d\n", e );
       printf("Line 4 - a 的值是 %d\n", f );
     
       printf("先运算后赋值：\n");
       f = 10;
       e = ++f;
       printf("Line 5 - c 的值是 %d\n", e );
       printf("Line 6 - a 的值是 %d\n", f );
       f = 10;
       e = --f;
       printf("Line 7 - c 的值是 %d\n", e );
       printf("Line 8 - a 的值是 %d\n", f );
     /*
      %@ 对象,%d,%i整数,%u无符整形,%f 浮点/双字, %x, %X  二进制整数,%o 八进制整数,%zu  size_t,%p        指针,%e 浮点/双字 （科学计算）,%g        浮点/双字, %s C 字符串, %.*s     Pascal字符串,%c字符,%C unichar, %lld      64位长整数（long long）,%llu      无符64位长整数,%Lf  64位双字
            */
}

