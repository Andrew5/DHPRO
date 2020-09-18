//
//  DHSegmentCommenMannager.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHSegmentCommenMannager.h"
#import "ZCAssetsPickerViewController.h"
#define countSegment self.infoarray.count
#define typeViewHight 50
#define lineViewHight 1.5
@implementation DHSegmentCommenMannager
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray *)controllers titleArray:(NSArray *)titleArray ParentController:(UIViewController *)parentVC
{
    if ( self=[super initWithFrame:frame])
    {
        self.superVC = parentVC;//父指针
        self.infoarray = [NSArray arrayWithArray:titleArray];
        //创建scrollView
        [self CreatSCAndDownView:titleArray];
        
        UIViewController *VCFirst = controllers[0];
        VCFirst.view.frame = CGRectMake(0, 0, DH_DeviceWidth, CGRectGetHeight(self.scrollBig.frame));
        [parentVC addChildViewController:VCFirst];
        [VCFirst didMoveToParentViewController:parentVC];
        [self.scrollBig addSubview:VCFirst.view];
        //添加分类VC
        for (int i = 1; i<controllers.count; i++) {
            UIViewController *VC = controllers[i];
            [self subControllerAddVC:VC parentVC:parentVC];
        }
    }
    return self;
}
//添加子VC
- (void)subControllerAddVC:(UIViewController *)VC parentVC:(UIViewController *)parentVC
{
    [parentVC addChildViewController:VC];
    [VC didMoveToParentViewController:parentVC];
}

- (void)CreatSCAndDownView:(NSArray *)titleArray
{
    //顶部View
    self.typeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, typeViewHight)];
    self.typeView.backgroundColor = [UIColor whiteColor];
    CGFloat width = DH_DeviceWidth / titleArray.count;
    //    [CommonMethod addShadowLineView:self.typeView shadowColor:[UIColor lightGrayColor] shadowOffset:CGSizeMake(0, 0)];
    [self addSubview:_typeView];
    
    //顶部线
    UIView *TLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, 0.5)];
    TLineView.backgroundColor = [UIColor darkGrayColor];
    [self.typeView addSubview:TLineView];
    
    //滑动View
    _scrollBig = [[UIScrollView alloc]initWithFrame:CGRectMake(0, typeViewHight, DH_DeviceWidth,self.frame.size.height-typeViewHight)];
//    _scrollBig.backgroundColor = [UIColor brownColor];
    _scrollBig.pagingEnabled = YES;
    _scrollBig.tag = 1008;
    _scrollBig.showsVerticalScrollIndicator =NO;
    _scrollBig.showsHorizontalScrollIndicator = NO;
    _scrollBig.contentSize = CGSizeMake(DH_DeviceWidth*titleArray.count,0);
    self.scrollBig.bounces=NO;//边界回弹
    self.scrollBig.bouncesZoom=NO;
    //设置代理
    _scrollBig.delegate = self;
    [self addSubview:_scrollBig];
    
    for (int i = 0; i < titleArray.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * width, 0.5, width, typeViewHight-1);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(didClickTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        //button标题的偏移量，这个偏移量是相对于图片的
        // btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_typeView addSubview:btn];
//        if (i!= 0 || i != titleArray.count-1) {
//            //中间线
//            UIView *lineKWide = [[UIView alloc] initWithFrame:CGRectMake(i * width, 15, ONEPIEXLHEIGHT, 20)];
//            lineKWide.backgroundColor = [UIColor systemCellLine];
//            [self.typeView addSubview:lineKWide];
//        }
        if (i == 0) {
            btn.selected = YES;
            self.tmpBtn = btn;
        }
    }
    //底部线
    UIView *kLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.typeView.frame.size.height - 0.5, DH_DeviceWidth, 0.5)];
    kLineView.backgroundColor = [UIColor darkGrayColor];
    [self.typeView addSubview:kLineView];
    //底部滑动线
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.typeView.frame.size.height - lineViewHight, width-0, lineViewHight)];
    self.lineView.backgroundColor = [UIColor blueColor];
    [self.typeView addSubview:self.lineView];
}

#pragma mark - 按钮事件
- (void)didClickTypeBtnAction:(UIButton *)sender
{
    self.tmpBtn.selected = NO;
    sender.selected = YES;
    self.tmpBtn = sender;
    //   _tmpBtn.selected = !_tmpBtn.selected;
    [UIView animateWithDuration:0.1 animations:^{
        self.lineView.frame = CGRectMake(_tmpBtn.frame.origin.x+0, _tmpBtn.frame.size.height-lineViewHight, _tmpBtn.frame.size.width-0, lineViewHight);
    }];
    //点击按钮让scrollView偏移
    CGPoint offset  = self.scrollBig.contentOffset;
    offset.x = ((sender.tag - 200)* DH_DeviceWidth);
    [self.scrollBig setContentOffset:offset animated:YES];
}

#pragma <UIScrollViewDelegate>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    [UIView animateWithDuration:0.01 animations:^{
        self.lineView.frame = CGRectMake(0+(scrollView.contentOffset.x/DH_DeviceWidth)*(DH_DeviceWidth/countSegment), typeViewHight-lineViewHight, DH_DeviceWidth/countSegment-0, lineViewHight);
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView ];//调用滑动结束方法
    NSInteger index =self.scrollBig.contentOffset.x/self.scrollBig.width;
    UIButton *sender  = [self.typeView viewWithTag:200+index];
    self.tmpBtn.selected = NO;
    sender.selected = YES;
    self.tmpBtn = sender;
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index =self.scrollBig.contentOffset.x/self.scrollBig.width;
    //取出自控制器 滑动添加子VC的view
    UIViewController * VC = self.superVC.childViewControllers[index];
    [scrollView addSubview:VC.view];
    if ([VC isKindOfClass:[ZCAssetsPickerViewController class]]) {
        ZCAssetsPickerViewController * VC = (ZCAssetsPickerViewController *)self.superVC.childViewControllers[index];
        VC.maximumNumbernMedia = 9;
    }
    VC.view.x = scrollView.contentOffset.x;
    VC.view.y = 0;
    VC.view.width = DH_DeviceWidth;
    VC.view.height = CGRectGetHeight(_scrollBig.frame);
    
//    CGPoint offset  = self.scrollBig.contentOffset;
//    offset.x = (index* KWidth);
//    [self.scrollBig setContentOffset:offset animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
