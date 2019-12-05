//
//  MainAnnotationView.m
//  shiku
//
//  Created by yanglele on 15/9/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "MainAnnotationView.h"

@implementation MainAnnotationView

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

@end
