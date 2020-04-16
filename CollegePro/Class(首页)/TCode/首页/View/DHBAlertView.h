//
//  DHBAlertView.h
//  CollegePro
//
//  Created by jabraknight on 2020/4/9.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AlertViewType) {
    OkCancelType = 0,       // 带确定和取消按钮
    OnlyOkType              // 仅带确定按钮
};

typedef void(^ClickBlock)(NSMutableDictionary * dic);
@interface DHBAlertView : UIView
@property (nonatomic, strong) UIView * alertBgView;          // 背景视图
@property (nonatomic, strong) UIView * operateView;         // 操作视图
@property (nonatomic, strong) UILabel * titleLabel;            // 标题
@property (nonatomic, strong) UILabel * detailLabel;         // 副标题
@property (nonatomic, strong) UIButton * okButton;          // 确定按钮
@property (nonatomic, strong) UIButton * cancelButton;        // 取消按钮
@property (nonatomic, strong) UIButton * neverShowBtn;      // 不再显示按钮
@property (nonatomic, copy) ClickBlock okBlock;
/*
 * 单例
 */
+ (DHBAlertView *)sharedAlertView;

/*
 * 弹框方式一
 * mode 模式
 * param 入参
 * okBlock 确定按钮回调
 */
- (void)showAlertWithMode:(AlertViewType)mode param:(NSMutableDictionary*)param action:(ClickBlock)okBlock;

/*
 * 弹框方式二
 * mode 模式
 * storeFlag 存储标记（当storeFlag != nil时，会显示“不再显示”按钮）
 * param 入参
 * okBlock 确定按钮回调
 */
- (void)showAlertWithMode:(AlertViewType)mode storeFlag:(NSString *)storeFlag param:(NSMutableDictionary*)param action:(ClickBlock)okBlock;

/*
 * 确定按钮事件
 */
- (void)okButtonClicked:(UIButton *)sender;

/*
 * 取消按钮事件
 */
- (void)cancelButtonClicked:(UIButton *)sender;

/*
 * 移除弹框视图
 */
- (void)removeAlertView;
@end

NS_ASSUME_NONNULL_END
