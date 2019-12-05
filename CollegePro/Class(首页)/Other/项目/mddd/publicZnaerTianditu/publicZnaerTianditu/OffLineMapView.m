//
//  OffLineMapView.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/29.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "OffLineMapView.h"

@implementation OffLineMapView

-(void)layoutView:(CGRect)frame{
    
    self.backgroundColor = [self retRGBColorWithRed:232 andGreen:232 andBlue:232];
    
    self.downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downLoadBtn.frame = CGRectMake(0, self.NavigateBarHeight, frame.size.width/2, 40);
    self.downLoadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.downLoadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.downLoadBtn setTitleColor:[self retRGBColorWithRed:62 andGreen:154 andBlue:236] forState:UIControlStateSelected];
    [self.downLoadBtn setTitle:@"下载管理" forState:UIControlStateNormal];
    self.downLoadBtn.tag = 101;
    [self.downLoadBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
 //   self.downLoadBtn.selected = YES;

    
    self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cityBtn.frame = CGRectMake(frame.size.width/2, self.NavigateBarHeight, frame.size.width/2, 40);
    self.cityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:[self retRGBColorWithRed:62 andGreen:154 andBlue:236] forState:UIControlStateSelected];
    [self.cityBtn setTitle:@"城市列表" forState:UIControlStateNormal];
    self.cityBtn.tag = 102;
    [self.cityBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.cityBtn.selected=YES;
    
    [self addSubview:self.downLoadBtn];
    [self addSubview:self.cityBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, [self relativeY:self.cityBtn.frame withOffY:2], frame.size.width, 1)];
    
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
    
    self.offView = [[UIView alloc]initWithFrame:CGRectMake(0, [self relativeY:self.cityBtn.frame withOffY:1], frame.size.width/2, 3)];
    self.offView.backgroundColor = [self retRGBColorWithRed:62 andGreen:154 andBlue:236];
    [self addSubview:self.offView];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, [self relativeY:self.offView.frame withOffY:1], frame.size.width, frame.size.height - self.offView.frame.origin.y)];
    self.scrollView.contentSize = CGSizeMake(frame.size.width * 2, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
    
    self.downLoadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.scrollView.frame.size.height) style:UITableViewStylePlain];
    
    [self setExtraCellLineHidden:self.downLoadTableView];
    
    [self.scrollView addSubview:self.downLoadTableView];
    
    
    self.cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, self.scrollView.frame.size.height) style:UITableViewStylePlain];
   
    [self setExtraCellLineHidden:self.cityTableView];
    
    [self.scrollView addSubview:self.cityTableView];
    
    
    
}

-(void)btnAction:(UIButton *)btn{
    
    if (btn.tag == 101) {
        btn.selected = YES;
        self.cityBtn.selected = NO;
        self.currentPage = 0;
    
    }
    else{
        btn.selected = YES;
        self.downLoadBtn.selected = NO;
        self.currentPage = 1;
    }
    
    [UIView beginAnimations:nil context:nil];//动画开始
    
    [UIView setAnimationDuration:0.3];
    _offView.frame = CGRectMake(self.frame.size.width/2 * self.currentPage , _offView.frame.origin.y, self.frame.size.width/2, 3);;
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*self.currentPage, 0)];
    
    [UIView commitAnimations];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPage =page;
  

    if (page == 0) {
        [self btnAction:self.downLoadBtn];
    }
    else{
       [self btnAction:self.cityBtn];
    }
    
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

@end
