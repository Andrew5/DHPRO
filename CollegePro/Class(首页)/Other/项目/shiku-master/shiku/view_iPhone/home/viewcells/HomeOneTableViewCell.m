//
//  HomeOneTableViewCell.m
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeOneTableViewCell.h"

@implementation HomeOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_imageIcon setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _imageIcon.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _imageIcon.contentMode = UIViewContentModeScaleAspectFill;
    _imageIcon.clipsToBounds = YES;
    
    
    _btnIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    _btnIcon.layer.borderWidth = 8;
    
    
//    self.title = @"For iOS 6 & later";
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"Using NSAttributed String"];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,12)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(19,6)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(6, 12)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:30.0] range:NSMakeRange(19, 6)];
//    attrLabel.attributedText = str;
    
    /*
     关于如何在一个UILabelView中实现不同字体和颜色的问题一直困扰了我很久，之前一直想着如何自定义一个UILabelView来实现，结果总是失败，知道最近我深入接触了NSMutableAttributedString之后，才发现要实现它原来是那么的简单。
     
     遥想实现它，我们得换一种思路，那就是从要输入的字符串下手，而不是一味的从UILabelView找突破。那好，一个例子就可以说明一切问题：
     
     NSString *title = @"Please rank from most to least the personality below you like your partner to have";
     
     NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:title];
     
     NSRange range1, range2;
     range1 = NSMakeRange(17, 13);//通过NSRange来划分片段
     range2 = NSMakeRange(62, 12);
     
     UIColor*    color1 = TITLE_TEXT_COLLOR; //TITLE_TEXT_COLLOR 是我自定义的颜色
     
     [string addAttribute:NSForegroundColorAttributeName value:color1 range:range1];//给不同的片段设置不同的颜色
     [string addAttribute:NSForegroundColorAttributeName value:color1 range:range2];
     [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeueLTStd-BdCn" size:15] range:range1];//给不同的片段设置不同的字体
     [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeueLTStd-BdCn" size:15] range:range2];
     
     [lblTitle setAttributedText:string];
     
     好了，以上实例叫我们如何来给一个UILableView同事设定不同的颜色和字体。
     */
    
    

}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeOneTableViewCell";
    HomeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeOneTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
