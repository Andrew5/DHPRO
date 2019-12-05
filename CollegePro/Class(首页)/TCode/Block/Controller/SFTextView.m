//
//  SFTextView.m
//  Demo
//
//  Created by 佘峰 on 2018/4/5.
//  Copyright © 2018年 佘峰. All rights reserved.
//

#import "SFTextView.h"

@interface SFTextView(){

    UILabel *placeHolderLabel;
    UILabel *charCountLabel;
    NSInteger maxCharCount;
    NSInteger rightMargin;
    NSInteger bottomMargin;
}

@end

@implementation SFTextView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        //占位label
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.numberOfLines = 0;
        [placeHolderLabel sizeToFit];
        [self addSubview:placeHolderLabel];
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        maxCharCount = 50;
        //字数
        charCountLabel = [[UILabel alloc] init];
        charCountLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:charCountLabel];
        
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setPlaceHolderAttr:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font{
    
    placeHolderLabel.text = text;
    placeHolderLabel.textColor = textColor;
    placeHolderLabel.font = font;
    [placeHolderLabel sizeToFit];
}

- (void)setCharCountAttr:(NSInteger)charCount right:(NSInteger)right bottom:(NSInteger)bottom textColor:(UIColor *)textColor font:(UIFont *)font{
    rightMargin = right;
    bottomMargin = bottom;
    maxCharCount = charCount;
    charCountLabel.text = [NSString stringWithFormat:@"0/%ld",maxCharCount];
    charCountLabel.textColor = textColor;
    charCountLabel.font = font;
    [charCountLabel sizeToFit];
    
    CGSize superSize = self.frame.size;
    CGSize size = charCountLabel.frame.size;
    
    charCountLabel.frame = CGRectMake(superSize.width - size.width - rightMargin, superSize.height - size.height - bottomMargin, size.width, size.height);
}

- (void)textDidChange{
    
    //字数限制操作
    if (self.text.length >= maxCharCount) {
        self.text = [self.text substringToIndex:maxCharCount];
        
        charCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",maxCharCount,maxCharCount];
    }else{
        charCountLabel.text = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)self.text.length,maxCharCount];
    }
    
    [charCountLabel sizeToFit];
    
    CGSize superSize = self.frame.size;
    CGSize size = charCountLabel.frame.size;
    
    charCountLabel.frame = CGRectMake(superSize.width - size.width - rightMargin, superSize.height - size.height - bottomMargin, size.width, size.height);
    
}

@end
