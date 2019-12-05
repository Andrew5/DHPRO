//
//  MultiTextView.h
//  SimpleLife
//

#import <UIKit/UIKit.h>

/* 
 本类的作用：
 显示不同类型的字符串［字体大小、颜色等等］
 @1.0:目前只支持在同一行显示
*/

typedef enum _MutiTextAlignmentType
{
    Muti_Alignment_Left_Type = 0x20,
    Muti_Alignment_Mid_Type = 0x21,
    Muti_Alignment_Right_Type = 0x22,
}MutiTextAlignmentType;

@interface MultiTextView : UIView

@property(nonatomic)MutiTextAlignmentType alignmentType;

/*
 @text : 要显示的分割字符，以｜号隔开 ps:xxx|xxx|xxx
 @setDictionary:每个字符的设置项目 [NSDictionary]
  Color:[字体的颜色]
  Font:[字体的大小]
*/
-(void)setShowText:(NSString*)text Setting:(NSArray*)setDictionary;
@end
