//
//  MyAnimatedAnnotationView.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "MyAnimatedAnnotationView.h"

@implementation MyAnimatedAnnotationView

@synthesize annotationImageView = _annotationImageView;
@synthesize annotationImages = _annotationImages;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 65.5f)];

        [self setBackgroundColor:[UIColor clearColor]];

        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _annotationImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_annotationImageView];
    }
    return self;
}

- (void)setAnnotationImages:(NSMutableArray *)images {
//    _annotationImages = images;

    [self create:images];
//    [self updateImageView];
}

-(void)setAnnotationImage:(UIImage *)annotationImage
{
    [self ImageView:annotationImage];

}

-(void)ImageView:(UIImage *)Imag
{
    //主题框 大头针创建
    UIImageView * Img = [[UIImageView alloc]initWithFrame:CGRectMake(3.45,0,47/2,68/2)];
    Img.backgroundColor = [UIColor clearColor];
    Img.image = Imag;
    [self addSubview:Img];


}

//- (void)updateImageView {
//    if ([_annotationImageView isAnimating]) {
//        [_annotationImageView stopAnimating];
//    }
//    
//    _annotationImageView.animationImages = _annotationImages;
//    _annotationImageView.animationDuration = 0.5 * [_annotationImages count];
//    _annotationImageView.animationRepeatCount = 0;
//    [_annotationImageView startAnimating];
//}

-(void)create:(NSMutableArray*)Arr
{
    //弹出框小图 整体图案
    UIButton * Buttview = [UIButton buttonWithType:UIButtonTypeCustom];
    Buttview.tag = self.tag;
//    Buttview.layer.borderColor = [UIColor redColor].CGColor;
//    Buttview.layer.borderWidth =2;
    Buttview.frame =CGRectMake(0, 0, 30, 65.5);
    [Buttview addTarget:self action:@selector(ButtViewClick:) forControlEvents:UIControlEventTouchUpInside];
    for (int i = 0; i<[Arr count]; i++) {
        if (i==0) {
            //主题框 大头针创建
            UIImageView * Img = [[UIImageView alloc]initWithFrame:CGRectMake(3.45,30,47/2,68/2)];
            Img.backgroundColor = [UIColor clearColor];
            Img.image = [Arr objectAtIndex:i];
            [Buttview addSubview:Img];
            [self addSubview:Buttview];
        }
        else
        {
            //小气泡
            UIImageView * Img = [[UIImageView alloc]initWithFrame:CGRectMake((i-1)*(30/[Arr count]), 0,30 ,35)];//30/([Arr count])
            Img.backgroundColor = [UIColor clearColor];
            Img.image = [UIImage imageNamed:@"SKbacky.png"];

            
            //小气泡中的水果图案
            UIImageView * Imgg = [[UIImageView alloc]initWithFrame:CGRectMake(8.2, 6,12.5,15)];//30/([Arr count])
            Imgg.backgroundColor = [UIColor clearColor];
 
            
            Imgg.image = [Arr objectAtIndex:i];
            [Img addSubview:Imgg];
            [Buttview addSubview:Img];
            
        }
        
    }
   
}

-(void)ButtViewClick:(UIButton *)sender
{
    [self.delegete AnimatedAnnotationClick:sender];
}

@end
