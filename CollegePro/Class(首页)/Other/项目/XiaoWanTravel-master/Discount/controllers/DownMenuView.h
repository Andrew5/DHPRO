//
//  DownMenuView.h
//  XiaoWanTravel
//
//  Created by xiao on 16/8/1.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownMenuView;

@protocol DropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(DownMenuView *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString *)menu:(DownMenuView *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - delegate
@protocol DropDownMenuDelegate <NSObject>
@optional
- (void)menu:(DownMenuView *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface DownMenuView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) UIView *transformView;

@property (nonatomic, weak) id <DropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <DropDownMenuDelegate> delegate;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

-(void)menuTapped;


@end
