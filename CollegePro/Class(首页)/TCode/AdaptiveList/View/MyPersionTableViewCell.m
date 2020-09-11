//
//  MyPersionTableViewCell.m
//  XLCircleProgressDemo
//
//  Created by TY on 2018/7/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "MyPersionTableViewCell.h"

@interface MyPersionTableViewCell()
/** 昵称 */
@property (nonatomic,strong) UILabel * lb_title;
/** 内容 */
@property (nonatomic,strong) UILabel * lb_subtitle;

@end

@implementation MyPersionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(UILabel *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}
/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param label 字体的大小
 @param width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForStrings:(NSString *)value andWidth:(float)width andView:(UILabel *)label{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    label.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

/**
 计算文字高度

 @param text 待计算的字符串
 @param font 字体的大小
 @param maxSize 字体最大Size
 @return 返回计算的Size
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)autoSizeWithText:(NSString *)str Font:(UIFont *)font{
    CGSize size_textfont = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    return size_textfont;
}
#pragma mark - 根据字符串计算label高度
- (CGFloat)getHeightLineWithString:(NSString *)string withWidth:(CGFloat)width withFont:(UIFont *)font andView:(UILabel *)lb{
    
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 2000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:0];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:dic];
//    lb.attributedText = attributeStr;
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
    return height;
}
//- (float)getString:(NSString *)tipStr andView:(UILabel *)lb{
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    [style setLineSpacing:0];
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:style};
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:tipStr attributes:dic];
//    lb.attributedText = attributeStr;
//    lb.numberOfLines = 0;
//    CGFloat height = [self getHeightLineWithString:tipStr withWidth:[UIScreen mainScreen].bounds.size.width - 20 withFont:[UIFont systemFontOfSize:12]];
//    return height;
//}
-(void)setModel:(CustomerTitleModel *)model {
    
    self.lb_title.text = model.newsTitle;
    self.lb_subtitle.text = model.newsDocSubject;
    
    CGFloat margin = 20.0;
    CGFloat titleH = [self getHeightLineWithString:model.newsTitle withWidth:kScreenW - 2 * margin withFont:kFont(12.0) andView:self.lb_title];
    CGFloat subTitleH = [self getHeightLineWithString:model.newsDocSubject withWidth:kScreenW - 2 * margin withFont:kFont(12.0) andView:self.lb_subtitle];
    
    self.lb_title.frame = CGRectMake(margin, 0, kScreenW - 2 * margin, titleH);
    self.lb_subtitle.frame = CGRectMake(margin, titleH, kScreenW - 2 * margin, subTitleH);
    
    model.cellHeight = CGRectGetMaxY(self.lb_subtitle.frame);
    
//    self.lb_title.text = model.newsTitle;
//    CGRect frame = self.lb_title.frame;
//    frame.origin.x = 30;
//    //问题疑问：问题出现在iPhone X，iPhone 6，iPhone 7，iPhone 8 其他没问题
//    //当frame.origin.x = 30， row = 2、7时，汉字上下间距差8像素；
//    //当frame.origin.x = 40， row = 0、1、5、6时，汉字上下间距差8像素；
//    frame.size.width = [UIScreen mainScreen].bounds.size.width - frame.origin.x*2;
//    self.lb_title.frame = frame;
//    [self.lb_title sizeToFit];
//
//    self.lb_subtitle.text = model.newsDocSubject;
//    CGRect contentFrame = self.lb_title.frame;
//    model.type = 1;
//    if (model.type == 1) {//与上述问题一致
//        contentFrame.origin.x = 30;
//        self.lb_subtitle.frame = contentFrame;
//        [self.lb_subtitle sizeToFit];
//    }
//    if (model.type == 2) {//row = 2、3、7、8时 width显示不全
//        self.lb_subtitle.frame = frame;
//        contentFrame.size.height = [self getHeightLineWithString:model.newsDocSubject withWidth:[UIScreen mainScreen].bounds.size.width withFont:];
//        self.lb_subtitle.frame = contentFrame;
//    }
//    if (model.type == 3) {//row == 3、8 宽有问题
//        contentFrame.size.width = [UIScreen mainScreen].bounds.size.width - frame.origin.x*2;
//        self.lb_subtitle.frame = contentFrame;
//        [self.lb_subtitle sizeToFit];
//    }
//
//    //计算cell高度
//    model.cellHeight = CGRectGetMaxY(self.lb_subtitle.frame)+CGRectGetMaxY(self.lb_title.frame);
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
//// 标题
//    self.lb_title.frame = CGRectMake(self.lb_title.frame.origin.x , 0, [UIScreen mainScreen].bounds.size.width - self.lb_title.frame.origin.x*2, CGRectGetMaxY(self.lb_title.frame));
//// 副标题
//    self.lb_subtitle.frame = CGRectMake(self.lb_subtitle.frame.origin.x, CGRectGetMaxY(self.lb_title.frame), self.lb_subtitle.frame.size.width, self.lb_subtitle.frame.size.height);
    
}

#pragma mark - 懒加载
- (UILabel *)lb_title{
    if (_lb_title == nil) {
        UILabel * lb_title = [[UILabel alloc] init];
        lb_title.textColor = [UIColor orangeColor];
        lb_title.numberOfLines = 0;
        lb_title.font = kFont(12.0);
        lb_title.layer.borderColor = [UIColor redColor].CGColor;
        lb_title.layer.borderWidth = 1.0;
        [self.contentView addSubview:lb_title];
        _lb_title = lb_title;
    }
    return _lb_title;
}

- (UILabel *)lb_subtitle{
    if (_lb_subtitle == nil) {
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor lightGrayColor];
        contentLabel.numberOfLines = 0;
        contentLabel.font = kFont(12.0);
        contentLabel.layer.borderColor = [UIColor greenColor].CGColor;
        contentLabel.layer.borderWidth = 1.0;
        [self.contentView addSubview:contentLabel];
        _lb_subtitle = contentLabel;
    }
    return _lb_subtitle;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
