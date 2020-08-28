//
//  UserCell.m
//  UserDetail
//
//  Created by Rainy on 16/10/8.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import "UserCell.h"


@interface UserCell ()

@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self.img.layer setMasksToBounds:YES];
    [self.img.layer setCornerRadius:self.img.frame.size.width/2];
    self.lab.font = [UIFont systemFontOfSize:12];
    self.lab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    // Configure the view for the selected state
}

-(void)setImg_name:(NSString *)img_name
{
    _img_name = img_name;
    self.img.image = [UIImage imageNamed:img_name];
    
}
-(void)setLab_text:(NSString *)lab_text
{
    _lab_text = lab_text;
    self.lab.text = lab_text;
}

@end
