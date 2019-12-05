//
//  DisassemblyView.m
//  18-06手势解锁
//
//  Created by 袁涛 on 16/1/25.
//  Copyright © 2016年 TY. All rights reserved.
//

#import "DisassemblyView.h"

@interface DisassemblyView ()

//创建一个可变数组来保存选中的按钮
@property (nonatomic,strong)NSMutableArray *selectedData;

//保存当前点
@property (nonatomic,assign) CGPoint curP;

@end


@implementation DisassemblyView

//懒加载  确保只有一个数组用来保存按钮
- (NSMutableArray *)selectedData
{
    if (!_selectedData) {
        _selectedData=[NSMutableArray array];
    }
    return _selectedData;
}

-(instancetype)init{
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];

		[self setUp];
	}
	return self;
}

//初始化
-(void)awakeFromNib
{
	[super awakeFromNib];
	

}

//初始化尺寸
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat btnWH=74;
    //一行有多少个
    int row=3;
    CGFloat space=(self.frame.size.width-row*btnWH)/(row+1);
    
    
    for (int i=0; i<9; i++) {
        //第几行第几列
        
        int btnLine=i%row;
        int btnList=i/row;
        
        CGFloat X=space+(btnWH+space)*btnLine;
        CGFloat Y=space+(btnWH+space)*btnList;
        
        //取出按钮
        UIButton *btn=self.subviews[i];
        
        btn.frame=CGRectMake(X, Y, btnWH, btnWH);
        
    }
	
}

//初始化
- (void)setUp
{
    for (int i=0; i<9; i++) {
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled=NO;
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:@"gesture_indicator_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_indicator_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
		
    }
	
}
//开始触摸屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //当前点的坐标
    UITouch *touch =[touches anyObject];
    CGPoint curP=[touch locationInView:self];
    
    //判断当前坐标是否在按钮上面
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, curP)&&btn.selected==NO) {
            btn.selected=YES;
            [self.selectedData addObject:btn];
        }
    }
    
    
}
//在屏幕上移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint curP=[touch locationInView:self];
    self.curP=curP;
    
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, curP)&&btn.selected==NO) {
            btn.selected=YES;
            [self.selectedData addObject:btn];
        }
    }
        //重绘
        [self setNeedsDisplay];
}
//手离开屏幕后
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableString *str=[NSMutableString string];

    //清除被选中的按钮 不能取出一个删除一个
    for (int i=0; i<self.selectedData.count; i++) {
        UIButton *btn=self.selectedData[i];
        btn.selected=NO;
        
//    [str appendString:[NSString stringWithFormat:@"%zd",btn.tag]];
        [str appendFormat:@"%zd",btn.tag];
        
    }
    
    
    
    [self.selectedData removeAllObjects];
    [self setNeedsDisplay];
    
    //判断是否为第一次进行设置密码
    NSString *pwd=[[NSUserDefaults standardUserDefaults] objectForKey:@"pwdKey"];
    if (!pwd) {
        //将第一次的密码导入系统中 生成plist文件
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"pwdKey"];
        //立刻保存
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else
    {
        if ([str isEqualToString:pwd]) {//弹框
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"手势正确" message:@"欢迎回来,正在进入桌面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alt show];
        }else
        {
            static int order= 5;
            static NSTimeInterval time=10;
            NSString *message=[NSString stringWithFormat:@"你还有%d次输入,距离下次输入时间还剩%.2lf秒",order,time];
            UIAlertView *alt=[[UIAlertView alloc] initWithTitle:@"手势错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alt show];
            order--;
        }
        
    
    }
    
    
    

}




- (void)drawRect:(CGRect)rect {
   
    
    if (self.selectedData.count) {
        UIBezierPath *path=[UIBezierPath bezierPath];
        
        for (int i=0; i<self.selectedData.count; i++) {
            UIButton *btn=self.selectedData[i];
            if (i==0) {
                [path moveToPoint:btn.center];
            }else
            {
                [path addLineToPoint:btn.center];
            }
        }
        
        //添加一根线到当前点
        [path addLineToPoint:self.curP];
        //绘制线的颜色
        [path setLineWidth:2];
        [[UIColor lightGrayColor] set];
        //去除交界处的尖角
        [path setLineJoinStyle:kCGLineJoinRound];
        
        [path stroke];
    }
    
    
    
    
}


@end
