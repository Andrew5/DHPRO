//
//  CardViewController.h
//  Test
//
//  Created by Rillakkuma on 16/7/12.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{    NSMutableArray *array ;    NSMutableArray * titleArray;
}
@property (strong ,nonatomic) NSMutableArray *array;
@property (strong,nonatomic) NSString * month;
@property (strong,nonatomic) NSString * imageName;
@property (strong,nonatomic) NSString *title;

@end
