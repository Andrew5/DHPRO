//
//  ImageFilterProcessViewController.m
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "ImageFilterProcessViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
@interface ImageFilterProcessViewController ()

@end

@implementation ImageFilterProcessViewController
@synthesize currentImage = currentImage;//, delegate = delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (IBAction)fitlerDone:(id)sender
{
    __block typeof(self) bself = self;
    
    [self dismissViewControllerAnimated:NO completion:^{
        [bself.delegate imageFitlerProcessDone:self->rootImageView.image];
    }];
}
#pragma clang diagnostic pop
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    leftBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    leftBtn.layer.borderWidth = 0.3;
    leftBtn.layer.cornerRadius = 9;
    [leftBtn setFrame:CGRectMake(10, DH_DeviceHeight-40, (DH_DeviceWidth-30)/2, 34)];
    [leftBtn addTarget:self action:@selector(backView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"camera_btn_ok.png"] forState:UIControlStateNormal];
    rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    rightBtn.layer.borderWidth = 0.3;
    rightBtn.layer.cornerRadius = 9;
    [rightBtn setFrame:CGRectMake(leftBtn.frame.size.width+20, DH_DeviceHeight-40, (DH_DeviceWidth-30)/2, 34)];
    [rightBtn addTarget:self action:@selector(fitlerDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    //添加分割线
    line = [[UIView alloc]initWithFrame:CGRectMake(0, DH_DeviceHeight-47, DH_DeviceWidth, 1)];
//    NSLog(@"--->%f",DeviceWidth);
    line.backgroundColor = [UIColor grayColor];
    line.alpha =0.7;
    [self.view addSubview:line];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.388 alpha:1.000]];
    rootImageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight-150)];
    rootImageView.image = currentImage;
    [self.view addSubview:rootImageView];
    
    NSArray *arr = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"自定义",@"蓝调",@"梦幻",@"夜色", nil];
    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, DH_DeviceHeight - 155, DH_DeviceWidth, 90+23)];
    scrollerView.backgroundColor = [UIColor clearColor];
//    scrollerView.layer.borderColor = [UIColor redColor].CGColor;
//    scrollerView.layer.borderWidth = 0.3;
    scrollerView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;//关闭纵向滚动条
    scrollerView.bounces = NO;
  
    float x = 0.0f ;
    for(int i=0;i<15;i++)
    {
        x = 10 + 80*i;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageStyle:)];
        recognizer.numberOfTouchesRequired = 1;
        recognizer.numberOfTapsRequired = 1;
        recognizer.delegate = self;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 85, 65, 23)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[arr objectAtIndex:i]];
        label.layer.cornerRadius = 9;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setTextColor:[UIColor whiteColor]];
        [label setUserInteractionEnabled:YES];
        [label setTag:i];
        [label addGestureRecognizer:recognizer];
        
        [scrollerView addSubview:label];
//        [label release];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 20, 65, 65)];
        [bgImageView setTag:i];
        [bgImageView addGestureRecognizer:recognizer];
        [bgImageView setUserInteractionEnabled:YES];
        UIImage *bgImage = [self changeImage:i imageView:nil];
        bgImageView.image = bgImage;
        [scrollerView addSubview:bgImageView];
//        [bgImageView release];
        
//        [recognizer release];

    }
    scrollerView.contentSize = CGSizeMake(x + 70, 80);
    [self.view addSubview:scrollerView];
    
	// Do any additional setup after loading the view.
}

- (IBAction)setImageStyle:(UITapGestureRecognizer *)sender
{
    UIImage *image =   [self changeImage:sender.view.tag imageView:nil];
    [rootImageView setImage:image];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIImage *)changeImage:(int)index imageView:(UIImageView *)imageView
{
    UIImage *image = nil;
    switch (index) {
        case 0:
        {
            return currentImage;
        }
            break;
        case 1:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
           image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_guangyun];
        }
            break;
            //自定义
        case 11:{
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_customColor];
        }
            break;
        case 12:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_landiao];
            
        }
            break;
        case 13:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_menghuan];
        
        }
            break;
        case 14:
        {
            image = [ImageUtil imageWithImage:currentImage withColorMatrix:colormatrix_yese];
            
        }
    }
    return image;
}

- (void)dealloc
{
//    [super dealloc];
    scrollerView = nil;
    rootImageView = nil;
//    [currentImage release];
    currentImage  =nil;
    
}
@end
