//
//  saoSeven.m
//  saoSeven
//

//


/*************************************************************
 
 
      更多IOS问题可以加群138240252咨询交流学习
 
                                   ------- saoSeven
 **************************************************************/

#import "saoSeven.h"

@implementation saoSeven
@synthesize array;
@synthesize number;
@synthesize count;

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        NSLog(@"123");
    }else{
        NSLog(@"123");
    }
    
    
    array=[[NSMutableArray alloc]init]; //初始化数组
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    int  max=[number intValue];
    
    
    
    
     int  todayHour=[count intValue];
       
    if (array.count ==0) {
        
        
    }else{
        
        
        
        NSLog(@"%@",array);
        
        
        int todayCount=-1;
        
        
        
        
        float pointW=(self.bounds.size.width-30)/24; // 每个点的距离 30 为 底部 0 0 相加w
        
        
        //阴影
        
        CGContextRef context2=UIGraphicsGetCurrentContext();
         CGContextMoveToPoint(context2, 10, self.frame.size.height-45);
        
//        int xx=-1;
        for (int i=0; i<todayHour; i++) {
            int cc=[array[i] intValue];
//            for (int j=0; j<4; j++) {
//                xx++;
//                cc+=[array[xx] intValue];
//            }
            
            NSLog(@"cc:%d",cc);
//            if (i==0) {
//                CGContextMoveToPoint(context2, 10, self.frame.size.height-45-  (self.frame.size.height-80)/max*cc);  // 刻度为5000  y=计算后的值
//            }else{
                CGContextAddLineToPoint(context2, 10+i*pointW+pointW, self.frame.size.height-  (self.frame.size.height-80)/max*cc-45);// 同上
//            }
            
        }
        CGContextAddLineToPoint(context2, 10+todayHour*pointW, self.frame.size.height-45);// 阴影是要填充的，最后 一个点 构成不规则矩形。
        //        [[UIColor greenColor]setFill];
        [[UIColor colorWithRed:1 green:1 blue:1 alpha:.5] setFill];
        CGContextFillPath(context2);  //填充路径
        
              //   折线
        CGContextRef context1=UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] setStroke];
        
        
        //        折线
        CGContextSetLineWidth(context1, 1.0);//线粗细
        
        
        CGContextMoveToPoint(context1, 10,self.frame.size.height-45); // 0点数据
       
        for (int i=0; i<todayHour; i++) { // 1-当前时间数据
            int  ez=[array[i] intValue];
            CGContextAddLineToPoint(context1, 10+i*pointW+pointW, self.frame.size.height-  (self.frame.size.height-80)/max*ez-45);
            
            
        }
        CGContextStrokePath(context1);
        todayCount=-1;
        
        //画圆点
        [[UIColor whiteColor] setFill];
        
        CGContextFillEllipseInRect(context1,CGRectMake(10, self.frame.size.height-48, 5, 5));
        [[UIColor orangeColor]setFill];
        CGContextFillEllipseInRect(context1,CGRectMake(10.8, self.frame.size.height-47.5, 3, 3));
        
        for (int i=0; i<todayHour; i++) {
            int  vn=[array[i] intValue];
            
            [[UIColor whiteColor]setFill];
            CGContextFillEllipseInRect(context1,CGRectMake( 10+i*pointW-2+pointW, self.frame.size.height-45-  (self.frame.size.height-80)/max*vn-3, 5, 5));// 大圆点 背景为白色
            [[UIColor orangeColor]setFill];
            CGContextFillEllipseInRect(context1, CGRectMake( 9+i*pointW+pointW, self.frame.size.height-45-  (self.frame.size.height-80)/max*vn-2, 3, 3));//小圆点颜色和背景色一样  叠加后出现 空心圆效果
            
            //        }
        }
        
        
        
        
    }
    
    
    
    //    上下白线
    CGContextRef context7=UIGraphicsGetCurrentContext();
    //        CGContextSetLineDash(context7, 0, lenghts, 2);//虚线模式
    CGContextMoveToPoint(context7, 5, 40);
    CGContextAddLineToPoint(context7, self.bounds.size.width-5, 40);
    //    [[UIColor orangeColor]setStroke];
    CGContextSetStrokeColorWithColor(context7, [UIColor whiteColor].CGColor);
    
    
    CGContextMoveToPoint(context7, 5, self.bounds.size.height-40);
    CGContextAddLineToPoint(context7, self.bounds.size.width-5, self.bounds.size.height-40);
    
    CGContextStrokePath(context7);
    
    
    //虚线
    CGFloat lenghts[]={5,5};//虚线的长度
    
    
    CGContextRef ctx2=UIGraphicsGetCurrentContext();
    CGContextSetLineDash(ctx2, 0, lenghts, 2);//虚线模式
    CGContextMoveToPoint(ctx2, 5, self.bounds.size.height/2);
    CGContextAddLineToPoint(ctx2, self.bounds.size.width-5, self.bounds.size.height/2);
    CGContextStrokePath(ctx2);
    //文字
    
    float cs=(self.bounds.size.width-30)/24;
    CGContextRef ctxW=UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor (ctxW,  1, 1, 1, 1.0);//设置填充颜色
    UIFont  *font12 = [UIFont boldSystemFontOfSize:12.0];//设置
    UIFont  *font20 = [UIFont boldSystemFontOfSize:20.0];
    UIFont  *font10 =[UIFont boldSystemFontOfSize:10.0];
    
    
    [@"步数" drawInRect:CGRectMake(5, 5, 40, 20) withFont:font20];
    [@"日平均值:最强青铜8000" drawInRect:CGRectMake(5, 25, 100, 10) withFont:font10];
    if (array.count ==0) {
        [@"0步"  drawInRect:CGRectMake(self.bounds.size.width-40 , 5, 100, 20) withFont:font20];
    }else{
        int tt=0;
        for (int i=0; i<todayHour; i++) {
            tt +=[array[i] intValue];
            NSLog(@"tt:%d",tt);
        }
        NSString *strr=[NSString stringWithFormat:@"%d步",tt];
        int dd;
        if (strr.length>3) {
            dd=100;
        }else if(strr.length>4){
            dd=120;
        }else{
            dd=100;
        }
        [strr  drawInRect:CGRectMake(self.bounds.size.width-80 , 5, dd, 20) withFont:font20];
    }
    [@"记录整点数据" drawInRect:CGRectMake(self.bounds.size.width-80, 25, 100, 10) withFont:font10];
    
    [@"0" drawInRect:CGRectMake(10, self.bounds.size.height-30, 20, 20) withFont:font12];
    [@"12" drawInRect:CGRectMake(cs*12+10-5 , self.bounds.size.height-30, 20, 20) withFont:font12];
    [@"0" drawInRect:CGRectMake(self.bounds.size.width-20, self.bounds.size.height-30, 20, 20) withFont:font12];
    
    [@"0" drawInRect:CGRectMake(self.bounds.size.width-20, self.bounds.size.height-55, 20, 20) withFont:font12];
    
    [number drawInRect:CGRectMake(self.bounds.size.width-30, 45, 100, 20) withFont:font12];
    
}

@end
