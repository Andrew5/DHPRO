//
//  GoodsDetailMoreRTLabelCollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/RTLabel.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface GoodsDetailMoreRTLabelCollectionViewCell : UICollectionViewCell
{
    RTLabel *rtLabel;
}
@property (nonatomic, retain) IBOutlet RTLabel *rtLabel;
+ (RTLabel*)textLabel;
@end
