//
//  CViewController.m
//  B
//
//  Created by jabraknight on 2019/9/17.
//  Copyright © 2019 jabraknight. All rights reserved.
//

#import "CViewController.h"
#define RGB(x,y,z) [UIColor colorWithRed:x/255. green:y/255. blue:z/255. alpha:1.]

@interface CViewController ()

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 垃圾代码部分
    UILabel * examp_Attrb_LB1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    examp_Attrb_LB1.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.2f];
    [self.view addSubview:examp_Attrb_LB1];
    
    
    UILabel * examp_Attrb_LB2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 50)];
    examp_Attrb_LB2.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.2f];
    [self.view addSubview:examp_Attrb_LB2];
    
    
    UILabel * examp_Attrb_LB3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 50)];
    examp_Attrb_LB3.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.2f];
    [self.view addSubview:examp_Attrb_LB3];
    
    
    UILabel * examp_Attrb_LB4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, self.view.frame.size.width, 50)];
    examp_Attrb_LB4.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.2f];
    [self.view addSubview:examp_Attrb_LB4];
    
    
    UILabel * examp_Attrb_LB5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, self.view.frame.size.width, 50)];
    examp_Attrb_LB5.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.2f];
    [self.view addSubview:examp_Attrb_LB5];
    
    
    UILabel * examp_Attrb_LB6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 380, self.view.frame.size.width, 150)];
    examp_Attrb_LB6.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.2f];
    [self.view addSubview:examp_Attrb_LB6];
    
    
    
    
    
    
    
    
    //《《《《《《《《《《《《《 进入主题 》》》》》》》》》》》》》
    
    // 富文本 字符串1
    NSAttributedString * attrStr1 = [[NSAttributedString alloc] initWithString:@"abcdefghij"]; // 几近无用😂
    
    
    // 不可变 富文本2    (附带设置 富文本属性(⭐️全体⭐️的属性)   )
    NSAttributedString * attrStr2 = [[NSAttributedString alloc] initWithString:@"hijklmnopqr" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30.f],NSForegroundColorAttributeName:RGB(137, 198, 41)}];
    
    // 不可变 富文本3   (⭐️复制⭐️一份富文本 )
    NSAttributedString * attrStr3 = [[NSAttributedString alloc] initWithAttributedString:attrStr2]; // ⭐️复制⭐️一份富文本
    
    
    //=======================================================
    // 可变 富文本4
    NSMutableAttributedString * attrStr4 = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr2];
    // 获取“mno”字符串     ⭐️所在范围⭐️
    NSRange rag_1;
    if (@available(iOS 9.0, *)) {
        rag_1 = [attrStr4.string localizedStandardRangeOfString:@"mno"];
    } else {
        rag_1 = [attrStr4.string rangeOfString:@"mno"];
    }
    // 添加       “mno”字符串所在范围 字体  属性
    [attrStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f] range:rag_1];
    
    //=======================================================
    // 可变 富文本5
    NSMutableAttributedString * attrStr5 = [[NSMutableAttributedString alloc] initWithString:@"stuvwxyz"];
    // 要添加或更改属性 的字典
    NSDictionary * attr_Dict = @{NSForegroundColorAttributeName:[UIColor orangeColor],
                                 NSUnderlineStyleAttributeName:[NSNumber numberWithFloat:1.0]
                                 };    //字体颜色 及 下划线
    
    // ⭐️添加⭐️ 范围内 富文本属性
    [attrStr5 addAttributes:attr_Dict range:NSMakeRange(0, attrStr5.length)]; // 整个字符串(NSMakeRange(0, attrStr5.length))的范围
    
    // 要添加或更改属性 的字典
    NSDictionary * attr_Dict2 = @{NSBackgroundColorAttributeName:[UIColor cyanColor],
                                  NSForegroundColorAttributeName:[UIColor blueColor],
                                  NSStrikethroughStyleAttributeName:[NSNumber numberWithFloat:1.0]
                                  };     //背景色、字体颜色 及 删除线
    
    // 要添加或更改属性的 范围
    NSRange rag_2 = NSMakeRange(2, 2);
    // ⭐️设置⭐️ 范围内 富文本属性
    [attrStr5 setAttributes:attr_Dict2 range:rag_2];
    
    //=======================================================
    // 可变 富文本6
    NSMutableAttributedString * attrStr6 = [[NSMutableAttributedString alloc] initWithString:@"abcdefghijklmnopqrstuvwxyz"];
    // 随机色Label
    for (int i = 0; i < attrStr6.string.length; i ++) {
        // 所有更改属性 的字典
        NSDictionary * attr_Dict = @{NSForegroundColorAttributeName:[UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1],
                                     NSFontAttributeName:[UIFont systemFontOfSize:(arc4random()%20+30)/1.f]
                                     }; // 字体：随机颜色、随机大小
        
        // 要添加或更改属性的 范围
        NSRange rag = NSMakeRange(i, 1);
        // ⭐️设置⭐️ 范围内 富文本属性
        [attrStr6 setAttributes:attr_Dict range:rag];
    }
    
    
    
    // Label添加 富文本字符串
    examp_Attrb_LB1.attributedText = attrStr1;
    examp_Attrb_LB2.attributedText = attrStr2;
    examp_Attrb_LB3.attributedText = attrStr3;
    examp_Attrb_LB4.attributedText = attrStr4;
    examp_Attrb_LB5.attributedText = attrStr5;
    examp_Attrb_LB6.attributedText = attrStr6;
    // 自动换行
    examp_Attrb_LB6.numberOfLines = 0;
    examp_Attrb_LB6.lineBreakMode = NSLineBreakByCharWrapping;
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
