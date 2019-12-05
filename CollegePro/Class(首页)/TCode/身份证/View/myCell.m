//
//  myCell.m
//  Test
//
//  Created by Rillakkuma on 16/7/12.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "myCell.h"

@implementation myCell
@synthesize myLabel;
@synthesize myImageView;
@synthesize title;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        myLabel = [[UILabel alloc] init];
        myLabel.lineBreakMode=NSLineBreakByCharWrapping;
        myLabel.numberOfLines = 0;
        myLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20.0];
        [self addSubview:myLabel];
        
        myImageView = [[UIImageView alloc] init];
        [self addSubview:myImageView];
        title = [[UILabel alloc] init];
        title.frame = CGRectMake(10, 10, 50, 30);
        title.backgroundColor = [UIColor colorWithRed:230/255.0 green:192/255.0 blue:203/255.0 alpha:1.0];
        title.layer.cornerRadius = 10.0;
        [self addSubview:title];
        
//        addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        addImageButton.frame = CGRectMake(10, 05, 30, 30);
//        [addImageButton setImage:[UIImage imageNamed:@"work_comming"] forState:(UIControlStateNormal)];
//        addImageButton.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20.0];
//        addImageButton.contentMode = UIViewContentModeScaleAspectFill;
//        addImageButton.clipsToBounds = YES;
//        addImageButton.tag = 1000;
//        [self addSubview:addImageButton];
        }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
