//
//  GLActionSheet.m
//  Demo
//
//  Created by 陈光临 on 15/12/17.
//  Copyright © 2015年 cn.chenguanglin. All rights reserved.
//
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#import "GLActionSheet.h"
#import <objc/runtime.h>

@interface GLActionSheetCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *marginLine;
@end


@interface GLActionSheet ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _index;
}

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dateSource;

@property (nonatomic, assign) CGFloat contentHeight;


@end


@implementation GLActionSheet

+ (instancetype) instanceWithContentHeight:(CGFloat)contentHeigth{
    GLActionSheet *actionSheet = [[GLActionSheet alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    actionSheet.contentHeight = contentHeigth;
    
    actionSheet.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, actionSheet.contentHeight);
    actionSheet.tableView.frame = actionSheet.contentView.bounds;
    return actionSheet;
}

+ (void)showWithDataSource:(NSArray *)dataSource
                     title:(NSString *)title
               selectIndex:(NSInteger)index
             completeBlock:(void(^)(NSInteger index))completeBlock{
    
    if(!dataSource||[dataSource count] == 0){
        return;
    }
    
    CGFloat contentHeight = 0;
    CGFloat headHeight = 0;
    headHeight = (title == nil) ? 0 : kHeadViewHeight;
    if (dataSource) {
        contentHeight = dataSource.count * kCellHeight + headHeight;
    }
    GLActionSheet *actionSheet = [GLActionSheet instanceWithContentHeight:contentHeight];
    
    if (title) {
        [actionSheet addHeadViewWithTitle:title];
    }
    
    objc_setAssociatedObject(actionSheet, @"block", completeBlock, OBJC_ASSOCIATION_RETAIN);
    [[[UIApplication sharedApplication] keyWindow] addSubview:actionSheet];
    
    [actionSheet reloadWithDataSource:dataSource selectedIndex:index];
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        actionSheet.contentView.frame = CGRectMake(0, kScreenHeight - contentHeight, kScreenWidth, contentHeight);
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgView.frame = CGRectMake(frame.origin.x, frame.origin.y, kScreenWidth, kScreenHeight);
        [self addSubview:self.bgView];
        
        CGFloat contentHeight = frame.size.height;
        self.contentHeight = contentHeight;
        [self addSubview:self.contentView];
        
    }
    return self;
}

- (void)addHeadViewWithTitle:(NSString *)title{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = RGB(0xe6, 0xe9, 0xeb);
    headView.frame = CGRectMake(0, 0, kScreenWidth, kHeadViewHeight);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = RGB(0x5c, 0x60, 0x66);
    titleLabel.font = [UIFont systemFontOfSize:kHeadFont];
    titleLabel.frame = CGRectMake(0, 0, kScreenWidth, kHeadViewHeight);
    [headView addSubview:titleLabel];
    
    _tableView.tableHeaderView = headView;
}

- (void)reloadWithDataSource:(NSArray *)dataSource selectedIndex:(NSInteger)index{
    _dateSource = dataSource;
    
    _index = index;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [_dateSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cid = @"index";
    GLActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[GLActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    cell.titleLabel.text = self.dateSource[indexPath.row];
    
    if (indexPath.row == _index) {
        cell.titleLabel.textColor = kSelectedColor;
    }else{
        cell.titleLabel.textColor = kNormalColor;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self hideSheetView];
    [self callBackWithIndex:indexPath.row];
}


#pragma mark - private

- (void)callBackWithIndex:(NSInteger)index{
    void(^block)(NSInteger index) = objc_getAssociatedObject(self, @"block");
    if (block) {
        block(index);
    }
}

- (void)tapAction{
    [self hideSheetView];
    [self callBackWithIndex:-1];
}

- (void)hideSheetView{
    [UIView animateWithDuration:kAnimationTime animations:^{
        _bgView.alpha = 0;
        self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.contentHeight);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}



#pragma mark - getter

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.64f;
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        _tap.numberOfTapsRequired = 1;
        [_bgView addGestureRecognizer:_tap];
    }
    return _bgView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        [_contentView addSubview:self.tableView];
    }
    return _contentView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



@end

#pragma mark - 下面是自定义cell,如果你需要修改显示的样式，请在此修改！

#pragma mark - cell


@implementation GLActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.marginLine];
        
        
    }
    return self;
}

- (void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    
    self.marginLine.frame = CGRectMake(15, self.contentView.bounds.size.height - 0.5,
                                       self.contentView.bounds.size.width - 30, 0.5);
}


#pragma mark - getter

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kItemFont];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)marginLine{
    if (_marginLine == nil) {
        _marginLine = [[UIView alloc] init];
        _marginLine.backgroundColor = RGB(0xc8, 0xc7, 0xcc);
    }
    return _marginLine;
}


@end
