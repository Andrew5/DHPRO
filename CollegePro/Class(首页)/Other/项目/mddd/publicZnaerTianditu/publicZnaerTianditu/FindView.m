//
//  FindView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "FindView.h"

#define MENU_HEIGHT 240 //菜单高度

#define DEFINE_SEX @"define_sex"

#define DEFINE_DISTANCE @"define_distance"

@implementation FindView
{
    NSArray *_arraySexBtn;
    NSArray *_arrayDistanceBtn;
    NSUserDefaults *_userDefaluts;
}

-(void)layoutView:(CGRect)frame{

    self.backgroundColor = [self retRGBColorWithRed:232 andGreen:232 andBlue:232];
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavigateBarHeight, frame.size.width, 45)];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    self.screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.screenBtn.frame = CGRectMake(0, 0, frame.size.width/3, 45);
    [self.screenBtn setTitleColor:[self retRGBColorWithRed:181 andGreen:181 andBlue:181] forState:UIControlStateNormal];
    [self.screenBtn setTitle:@"筛选" forState:UIControlStateNormal];
    self.screenBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.screenBtn setImage:[UIImage imageNamed:@"shaixuan_1.png"] forState:UIControlStateNormal];
    [self.screenBtn setImage:[UIImage imageNamed:@"shaixuan_2.png"] forState:UIControlStateSelected];
    self.screenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
    self.screenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    
    [self.screenBtn addTarget:self action:@selector(doScreen) forControlEvents:UIControlEventTouchUpInside];
    
    [self.topView addSubview:self.screenBtn];
    
    self.distanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.distanceBtn.frame = CGRectMake(frame.size.width/3, 0, frame.size.width/3, 45);
    [self.distanceBtn setTitleColor:[self retRGBColorWithRed:181 andGreen:181 andBlue:181] forState:UIControlStateNormal];
    self.distanceBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.distanceBtn.enabled = NO;
    [self.topView addSubview:self.distanceBtn];
    
    self.sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sexBtn.frame = CGRectMake(frame.size.width * 2/3, 0, frame.size.width/3, 45);
    [self.sexBtn setTitleColor:[self retRGBColorWithRed:181 andGreen:181 andBlue:181] forState:UIControlStateNormal];
    self.sexBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
   
    self.sexBtn.enabled = NO;
    [self.topView addSubview:self.sexBtn];
    
    [self addSubview:self.topView];
    
    [self getParams];
    
    [self initBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, [self relativeY:self.topView.frame withOffY:1], frame.size.width, frame.size.height - 45 - 49 - self.NavigateBarHeight) style:UITableViewStylePlain];
    [self setExtraCellLineHidden:self.tableView];
    
    [self addSubview:self.tableView];
    
}

//获取保存的参数
-(void)getParams{
    _userDefaluts = [NSUserDefaults standardUserDefaults];
    NSNumber *sexValue = [_userDefaluts objectForKey:DEFINE_SEX];
    NSNumber *distanceValue = [_userDefaluts objectForKey:DEFINE_DISTANCE];
    
    self.sexParam = sexValue ? [sexValue intValue] : all;
    self.distanceParam = distanceValue ? [distanceValue intValue] : distance500;
}

-(void)initBtn{
    
    [self.distanceBtn setTitle:[NSString stringWithFormat:@"%d米",self.distanceParam] forState:UIControlStateNormal];
    
    if (self.sexParam == all) {
        [self.sexBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    }
    else if (self.sexParam == man){
        [self.sexBtn setTitle:@"只看男生" forState:UIControlStateNormal];
    }
    else{
        [self.sexBtn setTitle:@"查看女生" forState:UIControlStateNormal];
    }
}

-(void)doScreen{
    if (!self.screenBtn.selected) {
        [self getParams];
        [self showExtendedMenuView];
    }else{
        [self hideExtendedMenuView];
    }
    
    self.screenBtn.selected = !self.screenBtn.selected;
    
}

//初始化菜单内容
-(void)setUpMenu{
    UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 80, 30)];
    sexLabel.font = [UIFont systemFontOfSize:15.0f];
    sexLabel.textColor = [self retRGBColorWithRed:181 andGreen:181 andBlue:181];
    sexLabel.text = @"性别";
    [self.contentView addSubview:sexLabel];
    
    UIButton *sexAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sexAllBtn.frame = CGRectMake(10, [self relativeY:sexLabel.frame withOffY:8], 80, 30);
    sexAllBtn.tag = 100;
    [self setButtonStyle:sexAllBtn];
    [sexAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [self.contentView addSubview:sexAllBtn];
    
    int space = (self.contentView.frame.size.width - (80 * 3 + 20))/2;
    
    UIButton *manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    manBtn.frame = CGRectMake([self relativeX:sexAllBtn.frame withOffX:space], [self relativeY:sexLabel.frame withOffY:8], 80, 30);
    manBtn.tag = 110;
    [manBtn setTitle:@"只看男生" forState:UIControlStateNormal];
    [self setButtonStyle:manBtn];
    [self.contentView addSubview:manBtn];
    
    UIButton *grilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    grilBtn.frame = CGRectMake([self relativeX:manBtn.frame withOffX:space], [self relativeY:sexLabel.frame withOffY:8], 80, 30);
    grilBtn.tag = 120;
    [grilBtn setTitle:@"只看女生" forState:UIControlStateNormal];
    [self setButtonStyle:grilBtn];
    [self.contentView addSubview:grilBtn];
    
    UIView *spaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, [self relativeY:grilBtn.frame withOffY:10], self.contentView.frame.size.width, 1)];
    spaceLine.backgroundColor = [self retRGBColorWithRed:181 andGreen:181 andBlue:181];
    [self.contentView addSubview:spaceLine];
    
  
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, [self relativeY:spaceLine.frame withOffY:8], 80, 30)];
    distanceLabel.font = [UIFont systemFontOfSize:15.0f];
    distanceLabel.textColor = [self retRGBColorWithRed:181 andGreen:181 andBlue:181];
    distanceLabel.text = @"距离";
    [self.contentView addSubview:distanceLabel];
    
    UIButton *distanceBtn500 = [UIButton buttonWithType:UIButtonTypeCustom];
    distanceBtn500.frame = CGRectMake(10, [self relativeY:distanceLabel.frame withOffY:8], 80, 30);
    distanceBtn500.tag = 200;
    [self setButtonStyle:distanceBtn500];
    [distanceBtn500 setTitle:@"500米" forState:UIControlStateNormal];
    [self.contentView addSubview:distanceBtn500];

    UIButton *distanceBtn1000 = [UIButton buttonWithType:UIButtonTypeCustom];
    distanceBtn1000.frame = CGRectMake([self relativeX:distanceBtn500.frame withOffX:space], [self relativeY:distanceLabel.frame withOffY:8], 80, 30);
    distanceBtn1000.tag = 210;
    [distanceBtn1000 setTitle:@"1000米" forState:UIControlStateNormal];
    [self setButtonStyle:distanceBtn1000];
    [self.contentView addSubview:distanceBtn1000];

    UIButton *distanceBtn1500 = [UIButton buttonWithType:UIButtonTypeCustom];
    distanceBtn1500.frame = CGRectMake([self relativeX:distanceBtn1000.frame withOffX:space], [self relativeY:distanceLabel.frame withOffY:8], 80, 30);
    distanceBtn1500.tag = 220;
    [distanceBtn1500 setTitle:@"1500米" forState:UIControlStateNormal];
    [self setButtonStyle:distanceBtn1500];
    [self.contentView addSubview:distanceBtn1500];
 
    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yesBtn.frame = CGRectMake(10, [self relativeY:distanceBtn1500.frame withOffY:20], self.contentView.frame.size.width - 20, 45);
    yesBtn.tag = 1000;
    [self setButtonStyle:yesBtn];
    yesBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [yesBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [yesBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [self.contentView addSubview:yesBtn];
    
    
    if (self.sexParam == man) {
        manBtn.selected = YES;
    }else if (self.sexParam == girl){
        grilBtn.selected = YES;
    }else{
        sexAllBtn.selected = YES;
    }
    
    if (self.distanceParam == distance500) {
        distanceBtn500.selected = YES;
    }
    else if (self.distanceParam == distance1000){
        distanceBtn1000.selected = YES;
    }
    else{
        distanceBtn1500.selected = YES;
    }
    _arraySexBtn = @[sexAllBtn,manBtn,grilBtn];
    _arrayDistanceBtn = @[distanceBtn500,distanceBtn1000,distanceBtn1500];

}

-(void)setButtonStyle:(UIButton *)btn{
    [btn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:[self retRGBColorWithRed:30 andGreen:126 andBlue:237]] forState:UIControlStateSelected];
    btn.layer.borderColor = [[self retRGBColorWithRed:181 andGreen:181 andBlue:181]CGColor];
    btn.layer.borderWidth = 1.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3.0f;
    [btn setTitleColor:[self retRGBColorWithRed:181 andGreen:181 andBlue:181] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn addTarget:self action:@selector(doBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)doBtnAction:(UIButton *)btn{
    NSInteger tag = btn.tag;
    btn.selected = YES;
    if (tag < 200) {
        //性别
        for (UIButton *itemBtn  in _arraySexBtn) {
            if (itemBtn != btn) {
                itemBtn.selected = NO;
            }
        }
    }
    else if(tag < 300){
        //距离
        for (UIButton *itemBtn  in _arrayDistanceBtn) {
            if (itemBtn != btn) {
                itemBtn.selected = NO;
            }
        }
    }
    switch (tag) {
        case 100:
            self.sexParam = all;
            break;
        case 110:
            self.sexParam = man;
            break;
        case 120:
            self.sexParam = girl;
            break;
        case 200:
            self.distanceParam = distance500;
            break;
        case 210:
            self.distanceParam = distance1000;
            break;
        case 220:
            self.distanceParam = distance1500;
            break;
        case 1000:{
            
            btn.selected = NO;
            self.screenBtn.selected = NO;
            [self hideExtendedMenuView];
            [self.baseViewDelegate btnClick:nil];
            
            [_userDefaluts setObject:[NSNumber numberWithInt:self.distanceParam] forKey:DEFINE_DISTANCE];
            [_userDefaluts setObject:[NSNumber numberWithInt:self.sexParam] forKey:DEFINE_SEX];
            
            [self initBtn];
            break;

        }
            
        default:
            break;
    }
}

//展开菜单
- (void)showExtendedMenuView{
   
    self.mBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, [self relativeY:self.topView.frame withOffY:1], self.bounds.size.width, self.bounds.size.height)];
    
    self.mBaseView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, MENU_HEIGHT)];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self setUpMenu];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.mBaseView addGestureRecognizer:bgTap];
    
    [self.mBaseView addSubview:self.contentView];
    
    [self addSubview:self.mBaseView];

    //动画设置位置
    CGRect rect = self.contentView.frame;
    rect.size.height = MENU_HEIGHT;
    [UIView animateWithDuration:0.3 animations:^{
        self.mBaseView.alpha = 0.2;
        self.contentView.alpha = 0.2;
        
        self.mBaseView.alpha = 1.0;
        self.contentView.alpha = 1.0;
        self.contentView.frame =  rect;
    }];

}

//隐藏菜单
- (void)hideExtendedMenuView
{
    
    CGRect rect = self.contentView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.mBaseView.alpha = 1.0f;
        self.contentView.alpha = 1.0f;
        
        self.mBaseView.alpha = 0.2f;
        self.contentView.alpha = 0.2f;
        
        self.contentView.frame = rect;
    }completion:^(BOOL finished) {
        [self.self.mBaseView removeFromSuperview];
        [self.contentView removeFromSuperview];
    }];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap{
    [self hideExtendedMenuView];
    self.screenBtn.selected = NO;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
