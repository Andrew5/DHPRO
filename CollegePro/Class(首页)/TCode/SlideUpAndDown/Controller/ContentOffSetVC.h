//
//  ContentOffSetVC.h
//  Test
//
//  Created by Rillakkuma on 2016/10/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaView.h"
#import "UserCell.h"
@interface ContentOffSetVC : BaseViewController<NaViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_headerImg;
    UILabel *_nameLabel;
    NSMutableArray *_dataArray;
    
}
@property(nonatomic,strong)UIImageView *backgroundImgV;
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,strong)NaView *NavView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UITableView *tableView;

@end
