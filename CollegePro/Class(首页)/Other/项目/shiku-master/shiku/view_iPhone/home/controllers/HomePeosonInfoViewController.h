//
//  HomePeosonInfoViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomePersonBlock) (NSString* attentionNum,BOOL isAtten);

@interface HomePeosonInfoViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger rowNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 * 评星
 */
@property (copy,nonatomic)NSString *stratStr;
/**
 * 农户姓名
 */
@property (copy,nonatomic)NSString *mname;
/**
 * 标题
 */
@property (copy, nonatomic) NSString *titleStr;
/**
 * 电话号码
 */
@property (copy, nonatomic) NSString *teleStr;
/**
 * 地址
 */
@property (copy, nonatomic) NSString *addressStr;
/**
 * 关注数量
 */
@property (copy, nonatomic) NSString *attentionStr;
/**
 * 销售数量
 */
@property (copy, nonatomic) NSString *saleStr;
/**
 * 评语标题
 */
@property (copy, nonatomic) NSString *commentStr;
@property (copy, nonatomic)NSString *voiceStr;
/**
 * 商品图片
 */
@property (copy, nonatomic) NSString *imagU;
/**
 * 地图
 */
@property (copy, nonatomic) NSString *mapImage;
/**
 * 头像
 */
@property (copy, nonatomic) NSString *iconImage;
/**
 * 关注与否
 */
@property (nonatomic,assign)BOOL isAttention;
/**
 * 商户id
 */
@property (nonatomic,assign)NSString *midStr;
@property (nonatomic,strong)NSDictionary *imageDic;
@property (nonatomic,copy)HomePersonBlock block;
- (void)getChange:(HomePersonBlock)block;
@end
