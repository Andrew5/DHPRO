//
//  RecFifTableViewCell.m
//  CollegePro
//
//  Created by jabraknight on 2021/7/11.
//  Copyright © 2021 jabrknight. All rights reserved.
//  以下代码由 磊哥 提供

#import "RecFifTableViewCell.h"
#define yis 0.2
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface RecFifTableViewCell() {
    int number;
}
@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UIView *oenView;
@property(nonatomic,strong)UIView *towView;
@property(nonatomic,strong)UIView *oensView;
@property(nonatomic,strong)UIView *towsView;
@property (nonatomic,strong)CADisplayLink *displayLink;
@property(nonatomic,strong)NSArray *imgArr;
@property(nonatomic,strong)NSArray *titleArr;

@end

@implementation RecFifTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
      
        self.bgview = [[UIView alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 280)];
        self.bgview.layer.masksToBounds=YES;
        self.bgview.layer.cornerRadius=10;
        self.bgview.backgroundColor = [UIColor grayColor];
        [self addSubview:self.bgview];
        self.imgArr = @[@"jiangzhe1",@"jiangzhe2",@"jiangzhe3",@"jiangzhe4"];
        self.titleArr = @[@"虞姬",@"猴子",@"凯",@"貂蝉"];
        number = (int)self.imgArr.count;
        [self addview];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotate)];
        _displayLink.frameInterval = 3.0;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}
- (void)addview {
    
    self.oenView = [[UIView alloc]init];
//    self.oenView.backgroundColor = [UIColor redColor];
    [self.bgview addSubview:self.oenView];
    
    self.towView = [[UIView alloc]init];
//    self.towView.backgroundColor = [UIColor greenColor];
    [self.bgview addSubview:self.towView];
    
    self.oensView = [[UIView alloc]init];
//    self.oensView.backgroundColor = [UIColor redColor];
    [self.bgview addSubview:self.oensView];
    
    self.towsView = [[UIView alloc]init];
//    self.towsView.backgroundColor = [UIColor greenColor];
    [self.bgview addSubview:self.towsView];
    
    for (int a=0; a<number; a++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(100*a, 15, 70, 70)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[a]]];
        imgView.layer.cornerRadius=35;
        imgView.clipsToBounds=YES;
        [self.oenView addSubview:imgView];
        UILabel *nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93, 70, 14)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text=[NSString stringWithFormat:@"%@",self.titleArr[a]];
        [self.oenView addSubview:nameLabel];
        
        UILabel *OccupationLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93+20, 70, 11)];
        OccupationLabel.textAlignment = NSTextAlignmentCenter;
        OccupationLabel.font=[UIFont systemFontOfSize:11];
        OccupationLabel.textColor = [UIColor whiteColor];
        OccupationLabel.text=@"这几个很无敌的";
        [self.oenView addSubview:OccupationLabel];
        
    }
    for (int a=0; a<number; a++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(100*a, 15, 70, 70)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[a]]];
        imgView.layer.cornerRadius=35;
        imgView.clipsToBounds=YES;
        [self.towView addSubview:imgView];
        UILabel *nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93, 70, 14)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text=[NSString stringWithFormat:@"%@",self.titleArr[a]];
        [self.towView addSubview:nameLabel];
        
        UILabel *OccupationLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93+20, 70, 11)];
        OccupationLabel.textAlignment = NSTextAlignmentCenter;
        OccupationLabel.font=[UIFont systemFontOfSize:11];
        OccupationLabel.textColor = [UIColor whiteColor];
        OccupationLabel.text=@"这几个很无敌的";
        [self.towView addSubview:OccupationLabel];
        
    }
    
    self.oenView.frame = CGRectMake(0, 0, 100*number, 140);
    self.towView.frame = CGRectMake(100*number, 0, 100*number, 140);
    
    for (int a=0; a<number; a++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(100*a, 15, 70, 70)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[a]]];
        imgView.layer.cornerRadius=35;
        imgView.clipsToBounds=YES;
        [self.oensView addSubview:imgView];
        UILabel *nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93, 70, 14)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text=[NSString stringWithFormat:@"%@",self.titleArr[a]];
        [self.oensView addSubview:nameLabel];
        
        UILabel *OccupationLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93+20, 70, 11)];
        OccupationLabel.textAlignment = NSTextAlignmentCenter;
        OccupationLabel.font=[UIFont systemFontOfSize:11];
        OccupationLabel.textColor = [UIColor whiteColor];
        OccupationLabel.text=@"这几个很无敌的";
        [self.oensView addSubview:OccupationLabel];
        
    }
    for (int a=0; a<number; a++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(100*a, 15, 70, 70)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[a]]];
        imgView.layer.cornerRadius=35;
        imgView.clipsToBounds=YES;
        [self.towsView addSubview:imgView];
        UILabel *nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93, 70, 14)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font=[UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text=[NSString stringWithFormat:@"%@",self.titleArr[a]];
        [self.towsView addSubview:nameLabel];
        
        UILabel *OccupationLabel= [[UILabel alloc]initWithFrame:CGRectMake(100*a, 93+20, 70, 11)];
        OccupationLabel.textAlignment = NSTextAlignmentCenter;
        OccupationLabel.font=[UIFont systemFontOfSize:11];
        OccupationLabel.textColor = [UIColor whiteColor];
        OccupationLabel.text=@"这几个很无敌的";
        [self.towsView addSubview:OccupationLabel];
        
    }
    self.oensView.frame = CGRectMake(0, 140, 100*number, 140);
    self.towsView.frame = CGRectMake(0-100*number,140, 100*number, 140);
    
}


- (void)rotate {

    self.oenView.frame=CGRectMake(self.oenView.frame.origin.x-yis,0, self.oenView.frame.size.width, 140);
    self.towView.frame = CGRectMake(self.towView.frame.origin.x-yis, 0, self.towView.frame.size.width, 140);
    
    self.oensView.frame = CGRectMake(self.oensView.frame.origin.x+yis, 140, self.oensView.frame.size.width, 140);
    self.towsView.frame = CGRectMake(self.towsView.frame.origin.x+yis,140, self.towsView.frame.size.width, 140);
    
    if (self.oenView.frame.origin.x < -self.oenView.frame.size.width) {
        self.oenView.frame = CGRectMake(self.towView.frame.origin.x+self.towView.frame.size.width, 0, self.oenView.frame.size.width, 140);
    }
    
    if (self.towView.frame.origin.x < -self.towView.frame.size.width) {
        self.towView.frame = CGRectMake(self.oenView.frame.origin.x+self.oenView.frame.size.width, 0, self.towView.frame.size.width, 140);
    }
    
    if (self.oensView.frame.origin.x > ScreenWidth+10.000000) {
        self.oensView.frame = CGRectMake(self.towsView.frame.origin.x-self.oensView.frame.size.width, 140, self.oensView.frame.size.width, 140);
    }
    
    if (self.towsView.frame.origin.x > ScreenWidth+10.000000) {
        self.towsView.frame = CGRectMake(self.oensView.frame.origin.x-self.towsView.frame.size.width, 140, self.towsView.frame.size.width, 140);
    }
    
}

#pragma mark --- 定时器销毁
- (void)invalidate {
    if (!_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)dealloc{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
