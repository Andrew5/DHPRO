//
//  GLActionSheet.h
//  ChooseImageDemo
//
//  Created by 陈光临 on 15/12/17.
//  Copyright © 2015年 cn.chenguanglin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(x,y,z) [UIColor colorWithRed:x/255. green:y/255. blue:z/255. alpha:1.]

#define kNormalColor RGB(0x54,0x54,0x54)   //正常颜色
#define kSelectedColor RGB(0x0,0x0,0x0)    //选中颜色

#define kHeadFont 13    //标题的大小
#define kItemFont 15    //内容显示的大小

#define kCellHeight 39          //cell的高度
#define kHeadViewHeight 33      //头部的高度
#define kAnimationTime 0.3      //动画的执行时间


@interface GLActionSheet : UIView
/**
 *  显示sheetView
 *
 *  @param dataSource    数据源
 *  @param title         标题，如果不显示标题，请传nil
 *  @param index         选中的item
 *  @param completeBlock 完成的回调,返回选中item的index，取消的index为-1
 */
+ (void)showWithDataSource:(NSArray *)dataSource
                     title:(NSString *)title
               selectIndex:(NSInteger)index
             completeBlock:(void(^)(NSInteger index))completeBlock;

@end
