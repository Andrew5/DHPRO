//
//  CustomSliderView.m
//  LeAi
//
//  Created by MACBOOK on 16/3/10.
//  Copyright © 2016年 yajun.li. All rights reserved.
//

#import "CustomSliderView.h"
#import "UIView+Extension.h"

//颜色
#define blueColor [UIColor colorWithRed:(143)/255.0 green:(204)/255.0 blue:(181)/255.0 alpha:1.0]
#define labelTag 1000

#define sliderMargin 5                  //拖动条间距
#define lineToBottom 30                 //竖线距左距离
#define sliderMoreBottomline    5       //拖动条超出底线距离
#define lineToLeft 20                   //横线距底距离
#define minSliderHeight 15              //拖动条最小长度：强度为0

#define maxStrong 8                     //纵坐标最大强度值

#define currentHeight (self.height-lineToBottom+sliderMoreBottomline)

@implementation CustomSliderView{
    float maxSliderHeight;  //拖动条最大高度
}


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        maxSliderHeight=currentHeight;

        
        [self setupView];
        
     

    }
    return self;
}


-(void)setupSlider:(NSMutableArray *)sliderArry sliderCount:(NSInteger)maxCount{
    //10秒
    UILabel *lblTime=[[UILabel alloc] init];
    lblTime.text=[NSString stringWithFormat:@"%ld秒",(long)maxCount];
    lblTime.font=[UIFont systemFontOfSize:13];
    lblTime.textColor=[UIColor grayColor];
    lblTime.frame=CGRectMake(self.width-lineToBottom, currentHeight, lineToBottom, lineToBottom-sliderMoreBottomline);
    [self addSubview:lblTime];
    
    CGFloat sliderW=(self.width-lineToLeft-maxCount*sliderMargin)/maxCount;
    //10个拖动条
    for (int i=0; i<maxCount; i++) {
        UIView *slider=[[UIView alloc] init];
        slider.tag=labelTag;
        slider.layer.cornerRadius=5;
        slider.backgroundColor=blueColor;
        slider.width=sliderW;
        slider.height=[sliderArry[i] integerValue]==0?minSliderHeight:[sliderArry[i] integerValue] *(maxSliderHeight/maxStrong);
        slider.x=lineToLeft+(i+1)*sliderMargin+i*sliderW;
        slider.y=currentHeight-slider.height;
        [self addSubview:slider];
        
        //强度标签
        UILabel *lblStrong=[[UILabel alloc] init];
        lblStrong.text=[NSString stringWithFormat:@"%ld",(long)[sliderArry[i] integerValue]];
        lblStrong.textAlignment=NSTextAlignmentCenter;
        lblStrong.font=[UIFont systemFontOfSize:13];
        lblStrong.textColor=[UIColor whiteColor];
        lblStrong.frame=CGRectMake((slider.width-18)/2, 0, 18, 18);
        [slider addSubview:lblStrong];
        
        
        //手势
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(SliderView:)];
        [slider addGestureRecognizer:pan];
        
    }

    
    //进入页面给予一个动画
   [self setupAnimation];
}

-(void)setupView{
    //竖线
    UIView *lineVertical=[[UIView alloc] init];
    lineVertical.backgroundColor=blueColor;
    lineVertical.frame=CGRectMake(lineToLeft, 0, 2, self.height-lineToBottom);
    [self addSubview:lineVertical];
    
    //横线
    UIView *lineHorizal=[[UIView alloc] init];
    lineHorizal.backgroundColor=blueColor;
    lineHorizal.frame=CGRectMake(lineToLeft, self.height-lineToBottom, self.width-lineToLeft, 2);
    [self addSubview:lineHorizal];
    
    NSLog(@"%@\n%@",NSStringFromCGRect(lineVertical.frame),NSStringFromCGRect(lineHorizal.frame));
    
    //加号、减号
    UILabel *lblPlus=[[UILabel alloc] init];
    lblPlus.text=@"＋";
    lblPlus.textColor=blueColor;
    lblPlus.frame=CGRectMake(0, 0, lineToLeft, lineToLeft);
    [self addSubview:lblPlus];
    
    UILabel *lblReduce=[[UILabel alloc] init];
    lblReduce.text=@"－";
    lblReduce.textColor=blueColor;
    lblReduce.frame=CGRectMake(0, self.height-lineToLeft-lineToBottom, lineToLeft, lineToLeft);
    [self addSubview:lblReduce];
    
    
}

-(void)SliderView:(UIPanGestureRecognizer *)recognizer{
    CGPoint original=[recognizer locationInView:self];
    UIView *view=recognizer.view;
    
    if (view.height>=minSliderHeight&&view.height<=maxSliderHeight) {
        
        view.height=currentHeight-original.y;
        view.y=original.y;
        
    }
   
    //手势离开设置强度值
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        [self setStrongValue:view];
    }


}

/**
 *  滑动结束后设置强度值
 *
 *  @param view <#view description#>
 */
-(void)setStrongValue:(UIView *)view{
    
    UILabel *lbl=[view.subviews firstObject];
    CGFloat area=maxSliderHeight/maxStrong;
    int strong=view.height<area?0:maxStrong-view.y/area;

    lbl.text=[NSString stringWithFormat:@"%d",strong];
    
    //设为0时给一个最低高度15
    view.height=strong==0?minSliderHeight:area*strong;
    view.y=currentHeight-view.height;

    //将数字放到slider下方，否则为0 时，标签会挡住手势
    [view insertSubview:lbl belowSubview:view];
}

/**
 *  初始动画
 */
-(void)setupAnimation{
    float time=1;
    float originalH=0;
    float originalY=0;
    
    for (UIView *view in self.subviews) {
        if (view.tag&&view.tag==labelTag) {
            originalH=view.height;
            originalY=view.y;

            [UIView animateWithDuration:time animations:^{
                view.height=self->maxSliderHeight;
                view.y=currentHeight-view.height;
            } completion:^(BOOL finished) {
                view.height=originalH;
                view.y=originalY;
            }];
            time+=0.5;
        }
    }
    
}

/**
 *  获得每个拖动条数值
 *
 *  @return <#return value description#>
 */
-(NSMutableArray *)getSliderNum{
    NSMutableArray *arry=[NSMutableArray array];
    for (UIView *view in self.subviews) {
        if (view.tag&&view.tag==labelTag) {
            UILabel *lbl=[view.subviews firstObject];
            [arry addObject:lbl.text];
            NSLog(@"%@",lbl.text);
        }
    }
    
    
    return arry;
    
}
@end
