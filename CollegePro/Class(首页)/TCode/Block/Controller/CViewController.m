//
//  CViewController.m
//  B
//
//  Created by jabraknight on 2019/9/17.
//  Copyright © 2019 jabraknight. All rights reserved.
//

#import "CViewController.h"
#import "LeftContainerView.h"


#define RGB(x,y,z) [UIColor colorWithRed:x/255. green:y/255. blue:z/255. alpha:1.]

@interface CViewController ()

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"字符串知识";

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
    
    UILabel * examp_Attrb_LB7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 535, self.view.frame.size.width, 50)];
    examp_Attrb_LB7.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0 alpha:0.2f];
    [self.view addSubview:examp_Attrb_LB7];
    
    
    
    
    
    
    
    
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
    
    //=======================================================
    // 可变 富文本7
    NSString *doingString = @"878天健身状态查询";
    ///提取数字和汉字
    NSCharacterSet *nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *numString =[doingString stringByTrimmingCharactersInSet:nonDigits] ;
    NSString *string = [doingString substringWithRange:NSMakeRange(numString.length, doingString.length-numString.length)];
    ///设置文本展示风格
    NSMutableAttributedString *attrStr71 = [[NSMutableAttributedString alloc] initWithString:numString];
    NSDictionary *attr_Dict71 = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                  NSFontAttributeName:[UIFont boldSystemFontOfSize:24]};
    [attrStr71 setAttributes:attr_Dict71 range:NSMakeRange(0, numString.length)];
    
    ///设置汉字
    NSMutableAttributedString *attrStr72 = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attr_Dict72 = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    [attrStr72 setAttributes:attr_Dict72 range:NSMakeRange(0, string.length)];
    
    [attrStr71 appendAttributedString:attrStr72];
    examp_Attrb_LB7.attributedText = attrStr71;

    // Do any additional setup after loading the view.
    [self attributedString];
    [self testGameKit1];
}
- (void)testGameKit1{
    
}
- (void)testB{
    /*
     通过自定义 LeftContainerView 然后在设置 leftBarButtonItem 的时候都使用这个作为 CustomView，这里面已经纠正了偏移的值。当然除了这个方案，还有其他的一些调整 _UIButtonBarStackView 的方案，或者可以和公司设计商量返回按钮不要往左边偏移太多。
     */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 44);
    button.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[LeftContainerView alloc] initWithCustomView:button]];

}
- (void)attributedString{
    //初始化NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]init];

    //设置字体格式和大小
    NSString *str0 = @"设置字体格式和大小";
    NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
    [attributedString appendAttributedString:attr0];

    //设置字体颜色
    NSString *str1 = @"\n设置字体颜色\n";
    NSDictionary *dictAttr1 = @{NSForegroundColorAttributeName:[UIColor purpleColor]};
    NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];
    [attributedString appendAttributedString:attr1];

    //设置字体背景颜色
    NSString *str2 = @"设置字体背景颜色\n";
    NSDictionary *dictAttr2 = @{NSBackgroundColorAttributeName:[UIColor cyanColor]};
    NSAttributedString *attr2 = [[NSAttributedString alloc]initWithString:str2 attributes:dictAttr2];
    [attributedString appendAttributedString:attr2];

    /*
     注：NSLigatureAttributeName设置连体属性，取值为NSNumber对象（整数），1表示使用默认的连体字符，0表示不使用，2表示使用所有连体符号（iOS不支持2）。而且并非所有的字符之间都有组合符合。如 fly ，f和l会连起来。
     */
    //设置连体属性
    NSString *str3 = @"fly";
    NSDictionary *dictAttr3 = @{NSFontAttributeName:[UIFont fontWithName:@"futura" size:14],NSLigatureAttributeName:[NSNumber numberWithInteger:1]};
    NSAttributedString *attr3 = [[NSAttributedString alloc]initWithString:str3 attributes:dictAttr3];
    [attributedString appendAttributedString:attr3];

    /*!
     注：NSKernAttributeName用来设置字符之间的间距，取值为NSNumber对象（整数），负值间距变窄，正值间距变宽
     */

    NSString *str4 = @"\n设置字符间距";
    NSDictionary *dictAttr4 = @{NSKernAttributeName:@(4)};
    NSAttributedString *attr4 = [[NSAttributedString alloc]initWithString:str4 attributes:dictAttr4];
    [attributedString appendAttributedString:attr4];

    /*!
     注：NSStrikethroughStyleAttributeName设置删除线，取值为NSNumber对象，枚举NSUnderlineStyle中的值。NSStrikethroughColorAttributeName设置删除线的颜色。并可以将Style和Pattern相互 取与 获取不同的效果
     */

    NSString *str51 = @"\n设置删除线为细单实线,颜色为红色";
    NSDictionary *dictAttr51 = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor redColor]};
    NSAttributedString *attr51 = [[NSAttributedString alloc]initWithString:str51 attributes:dictAttr51];
    [attributedString appendAttributedString:attr51];


    NSString *str52 = @"\n设置删除线为粗单实线,颜色为红色";
    NSDictionary *dictAttr52 = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick),NSStrikethroughColorAttributeName:[UIColor redColor]};
    NSAttributedString *attr52 = [[NSAttributedString alloc]initWithString:str52 attributes:dictAttr52];
    [attributedString appendAttributedString:attr52];

    NSString *str53 = @"\n设置删除线为细单实线,颜色为红色";
    NSDictionary *dictAttr53 = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleDouble),NSStrikethroughColorAttributeName:[UIColor redColor]};
    NSAttributedString *attr53 = [[NSAttributedString alloc]initWithString:str53 attributes:dictAttr53];
    [attributedString appendAttributedString:attr53];


    NSString *str54 = @"\n设置删除线为细单虚线,颜色为红色";
    NSDictionary *dictAttr54 = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternDot),NSStrikethroughColorAttributeName:[UIColor redColor]};
    NSAttributedString *attr54 = [[NSAttributedString alloc]initWithString:str54 attributes:dictAttr54];
    [attributedString appendAttributedString:attr54];

    /*!
     NSStrokeWidthAttributeName 设置笔画的宽度，取值为NSNumber对象（整数），负值填充效果，正值是中空效果。NSStrokeColorAttributeName  设置填充部分颜色，取值为UIColor对象。
     设置中间部分颜色可以使用 NSForegroundColorAttributeName 属性来进行
     */
    //设置笔画宽度和填充部分颜色
    NSString *str6 = @"设置笔画宽度和填充颜色\n";
    NSDictionary *dictAttr6 = @{NSStrokeWidthAttributeName:@(2),NSStrokeColorAttributeName:[UIColor blueColor]};
    NSAttributedString *attr6 = [[NSAttributedString alloc]initWithString:str6 attributes:dictAttr6];
    [attributedString appendAttributedString:attr6];

    //设置阴影属性，取值为NSShadow对象
    NSString *str7 = @"设置阴影属性\n";
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor redColor];
    shadow.shadowBlurRadius = 1.0f;
    shadow.shadowOffset = CGSizeMake(1, 1);
    NSDictionary *dictAttr7 = @{NSShadowAttributeName:shadow};
    NSAttributedString *attr7 = [[NSAttributedString alloc]initWithString:str7 attributes:dictAttr7];
    [attributedString appendAttributedString:attr7];

    //设置文本特殊效果，取值为NSString类型，目前只有一个可用效果  NSTextEffectLetterpressStyle（凸版印刷效果）
    NSString *str8 = @"设置特殊效果\n";
    NSDictionary *dictAttr8 = @{NSTextEffectAttributeName:NSTextEffectLetterpressStyle};
    NSAttributedString *attr8 = [[NSAttributedString alloc]initWithString:str8 attributes:dictAttr8];
    [attributedString appendAttributedString:attr8];

    //设置文本附件，取值为NSTextAttachment对象，常用于文字的图文混排
    NSString *str9 = @"文字的图文混排\n";
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = [UIImage imageNamed:@"logo.png"];
    textAttachment.bounds = CGRectMake(0, 0, 30, 30);
    NSDictionary *dictAttr9 = @{NSAttachmentAttributeName:textAttachment};
    NSAttributedString *attr9 = [[NSAttributedString alloc]initWithString:str9 attributes:dictAttr9];
    [attributedString appendAttributedString:attr9];

    /*!
     添加下划线 NSUnderlineStyleAttributeName。设置下划线的颜色 NSUnderlineColorAttributeName，对象为 UIColor。使用方式同删除线一样。
     */
    //添加下划线
    NSString *str10 = @"添加下划线\n";
    NSDictionary *dictAttr10 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor redColor]};
    NSAttributedString *attr10 = [[NSAttributedString alloc]initWithString:str10 attributes:dictAttr10];
    [attributedString appendAttributedString:attr10];

    /*!
     NSBaselineOffsetAttributeName 设置基线偏移值。取值为NSNumber （float），正值上偏，负值下偏
     */
    //设置基线偏移值 NSBaselineOffsetAttributeName
    NSString *str11 = @"添加基线偏移值\n";
    NSDictionary *dictAttr11 = @{NSBaselineOffsetAttributeName:@(-10)};
    NSAttributedString *attr11 = [[NSAttributedString alloc]initWithString:str11 attributes:dictAttr11];
    [attributedString appendAttributedString:attr11];

    /*!
     NSObliquenessAttributeName 设置字体倾斜度，取值为 NSNumber（float），正值右倾，负值左倾
     */
    //设置字体倾斜度 NSObliquenessAttributeName
    NSString *str12 = @"设置字体倾斜度\n";
    NSDictionary *dictAttr12 = @{NSObliquenessAttributeName:@(0.5)};
    NSAttributedString *attr12 = [[NSAttributedString alloc]initWithString:str12 attributes:dictAttr12];
    [attributedString appendAttributedString:attr12];

    /*!
     NSExpansionAttributeName 设置字体的横向拉伸，取值为NSNumber （float），正值拉伸 ，负值压缩
     */
    //设置字体的横向拉伸 NSExpansionAttributeName
    NSString *str13 = @"设置字体横向拉伸\n";
    NSDictionary *dictAttr13 = @{NSExpansionAttributeName:@(0.5)};
    NSAttributedString *attr13 = [[NSAttributedString alloc]initWithString:str13 attributes:dictAttr13];
    [attributedString appendAttributedString:attr13];

    /*!
     NSWritingDirectionAttributeName 设置文字的书写方向，取值为以下组合
     @[@(NSWritingDirectionLeftToRight | NSWritingDirectionEmbedding)]
     @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)]
     @[@(NSWritingDirectionRightToLeft | NSWritingDirectionEmbedding)]
     @[@(NSWritingDirectionRightToLeft | NSWritingDirectionOverride)]
     
     ???NSWritingDirectionEmbedding和NSWritingDirectionOverride有什么不同
     */
    //设置文字的书写方向 NSWritingDirectionAttributeName
    NSString *str14 = @"设置文字书写方向\n";
    NSDictionary *dictAttr14 = @{NSWritingDirectionAttributeName:@[@(NSWritingDirectionRightToLeft | NSWritingDirectionEmbedding)]};
    NSAttributedString *attr14 = [[NSAttributedString alloc]initWithString:str14 attributes:dictAttr14];
    [attributedString appendAttributedString:attr14];

    /*!
     NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为NSNumber对象（整数），0表示横排文本，1表示竖排文本  在iOS中只支持0
     */
    //设置文字排版方向 NSVerticalGlyphFormAttributeName
    NSString *str15 = @"设置文字排版方向\n";
    NSDictionary *dictAttr15 = @{NSVerticalGlyphFormAttributeName:@(0)};
    NSAttributedString *attr15 = [[NSAttributedString alloc]initWithString:str15 attributes:dictAttr15];
    [attributedString appendAttributedString:attr15];

    //段落样式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    //行间距
    paragraph.lineSpacing = 10;
    //段落间距
    paragraph.paragraphSpacing = 20;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    //指定段落开始的缩进像素
    paragraph.firstLineHeadIndent = 30;
    //调整全部文字的缩进像素
    paragraph.headIndent = 10;

    //添加段落设置
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attributedString.length)];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, 300, 0)];
    label.backgroundColor = [UIColor lightGrayColor];
    //自动换行
    label.numberOfLines = 0;
    //设置label的富文本
    label.attributedText = attributedString;
    //label高度自适应
    [label sizeToFit];
    [self.view addSubview:label];
}

- (void)testDecimalNumber{
    NSDecimalNumber *price1 = [NSDecimalNumber decimalNumberWithString:@"15.99"];
    NSDecimalNumber *price2 = [NSDecimalNumber decimalNumberWithString:@"29.99"];
    NSDecimalNumber *coupon = [NSDecimalNumber decimalNumberWithString:@"5.00"];
    NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:@".90"];
    NSDecimalNumber *numProducts = [NSDecimalNumber decimalNumberWithString:@"2.0"];
    
    // 加
    NSDecimalNumber *subtotal = [price1 decimalNumberByAdding:price2];
    // 减
    NSDecimalNumber *afterCoupon = [subtotal decimalNumberBySubtracting:coupon];
    // 乘
    NSDecimalNumber *afterDiscount = [afterCoupon decimalNumberByMultiplyingBy:discount];
    // 除
    NSDecimalNumber *average = [afterDiscount decimalNumberByDividingBy:numProducts];
    // 乘方
    NSDecimalNumber *averageSquared = [average decimalNumberByRaisingToPower:2];
    
    NSLog(@"Subtotal: %@", subtotal);                    // 45.98
    NSLog(@"After coupon: %@", afterCoupon);           // 40.98
    NSLog((@"After discount: %@"), afterDiscount);       // 36.882
    NSLog(@"Average price per product: %@", average);    // 18.441
    NSLog(@"Average price squared: %@", averageSquared); // 340.070481
    
    /*
     NSRoundPlain:四舍五入  NSRoundDown:向下取正   NSRoundUp:向上取正     NSRoundBankers:(特殊的四舍五入，碰到保留位数后一位的数字为5时，根据前一位的奇偶性决定。为偶时向下取正，为奇数时向上取正。如：1.25保留1为小数。5之前是2偶数向下取正1.2；1.35保留1位小数时。5之前为3奇数，向上取正1.4）
     scale:精确到几位小数
     raiseOnExactness:发生精确错误时是否抛出异常，一般为NO
     raiseOnOverflow:发生溢出错误时是否抛出异常，一般为NO
     raiseOnUnderflow:发生不足错误时是否抛出异常，一般为NO
     raiseOnDivideByZero:被0除时是否抛出异常，一般为YES
     */
    NSDecimalNumber * inputNumber = [[NSDecimalNumber alloc]initWithString:@"340.0700001"];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:2
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber * number = [inputNumber decimalNumberByRoundingAccordingToBehavior: roundUp];
    NSLog(@"%@",number);

}

- (NSString *)hexStringFromString:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

//产生随机字符串
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (NSString*)SPAUrl2StandardUrl:(NSString*)raw {
    int questionMark = -1;
    int hashtagMark = -1;

    for (int i=0;i< raw.length;i++){
        char cc= [raw characterAtIndex:i];

        if(cc == '#' && hashtagMark == -1){
            hashtagMark=i;
        }
        // 仅当找到 hashtag 后才再找?, 不然不是 SPA url
        if(hashtagMark != -1 && cc == '?' && questionMark == -1){
            questionMark=i;
        }
    }
    if(questionMark != -1 && hashtagMark != -1){
        NSString* sub1= [raw substringToIndex:hashtagMark];
        NSString* sub2= [raw substringWithRange:NSMakeRange(hashtagMark, questionMark-hashtagMark)];
        NSString* sub3=[ [raw substringFromIndex:questionMark]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return [NSString stringWithFormat:@"%@%@%@",sub1,sub3,sub2] ;
    }
    return raw;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 //封装下拉头部变大
 @interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
 {
     UIView *backgroundView;
     UIImageView *headImageView;
 }
 @property(nonatomic,strong)UITableView *table;
 @end

 @implementation ViewController
 -(UITableView *)table{
     if (_table==nil) {
         _table =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
         _table.dataSource = self;
         _table.delegate = self;
     }
     return _table;
 }
 - (void)viewDidLoad {
     [super viewDidLoad];
     [self initHeaderView];
     [self.view addSubview:self.table];
     [self.table setBigView:backgroundView withHeaderView:nil];
 }
 - (void)initHeaderView {
     //顶部背景
     backgroundView = [UIView new];
     backgroundView.frame = CGRectMake(0, 0, kScreenWidth, 300);
     backgroundView.backgroundColor = [UIColor cyanColor];
     //头像背景
     headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-100, 50, 200, 200)];
     headImageView.image = [UIImage imageNamed:@"1.jpg"];
     [backgroundView addSubview:headImageView];
 }
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return 20;
 }
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"wuyu"];
     cell.textLabel.text = @"无语无语无语无语无语无语······";
     return cell;
 }
 @end
 */
@end
