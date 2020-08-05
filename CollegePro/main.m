//
//  main.m
//  CollegePro
//
//  Created by jabraknight on 2019/4/30.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DHSendRunObject.h"
CFAbsoluteTime StartTime;
int main(int argc, char * argv[]) {
    @autoreleasepool {
        StartTime = CFAbsoluteTimeGetCurrent();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
//    char *p1 = "China";
//        char *p2,*p3;
//        p2 = (char *)malloc(20);
//        memset(p2, 3, 1);
//         *p2 = *p1 ;
//        printf("%s\n",p2);
//
//        char S[100],T[20];
//        char ch1,ch2;
//        //President Obama has announced his support for India's bid for a permanent place on the United Nations Security Council.Obama was addressing the Indian parIiament
//        //Obama
//        int hj = strABC("President Obama has announced his support for India's bid for a permanent place on the United Nations Security Council.Obama was addressing the Indian parIiament","Obama");
//        printf("返回值:%d",hj);
//
//    //    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
//    //    [bezierPath moveToPoint: CGPointMake(9.5, 98.62)];
//    //    [bezierPath addCurveToPoint: CGPointMake(9.5, 108.75) controlPoint1: CGPointMake(9.5, 111) controlPoint2: CGPointMake(9.5, 108.75)];
//    //    [bezierPath addLineToPoint: CGPointMake(16.22, 108.75)];
//    //    [bezierPath addLineToPoint: CGPointMake(21.5, 112.5)];
//    //    [bezierPath addLineToPoint: CGPointMake(21.5, 94.5)];
//    //    [bezierPath addLineToPoint: CGPointMake(16.22, 98.62)];
//    //    [bezierPath addLineToPoint: CGPointMake(9.5, 98.62)];
//    //    [bezierPath addLineToPoint: CGPointMake(9.5, 98.62)];
//    //    [bezierPath addLineToPoint: CGPointMake(9.5, 98.62)];
//    //    [UIColor.blackColor setStroke];
//    //    bezierPath.lineWidth = 1;
//    //    [bezierPath stroke];
//
//        printf("请输入主字bai符串:\n");
//        ch1=getchar();
//        int i = 0;
//        while(ch1!='\n')
//        {
//            S[i]=ch1;
//            i++;
//            ch1=getchar();
//        }
//        printf("请输入要筛选的字符串:\n");
//        ch2=getchar();
//        int j = 0;
//        while(ch2!='\n')
//        {
//            T[j]=ch2;
//            j++;
//            ch2=getchar();
//        }
//        int m,n;//m为duS的下标，n为T的下标
//        m=0;
//        n=0;
//        int num = 0;//num用于记录选zhi定单词出现的次数
//        while(m<=i&&n<=j)
//        {
//            if(S[m]==T[n])
//            {
//                m++;
//                n++;
//            }
//            else
//            {
//                m=m-n+1;
//                n=0;
//            }
//            if(n==j)
//            {
//                num++;
//            }
//        }
//        if(m==i+1){
//            printf("出现的次数是%d--",num);
//        }
//        @autoreleasepool {
//            // insert code here...
//            NSLog(@"Hello, World!");
//        }
//        return 0;
}
//int strABC (const char *string, const char *substring){
//    int i,j,k,count = 0;
//    for (i = 0; string[i]; i++) {
//        for (j = i, k = 0; string[j] == substring[k];j++,k++) {
//            if (!substring[k+1]) {
//                count++;
//            }
//        }
//        
//    }
//    return count;
//}

