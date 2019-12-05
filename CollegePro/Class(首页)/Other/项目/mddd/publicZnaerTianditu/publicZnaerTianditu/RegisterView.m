//
//  RegisterView.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "RegisterView.h"
#import "Constants.h"
@implementation RegisterView


-(void)layoutView:(CGRect)frame
{
    
    self.tfNick = [[UITextField alloc]initWithFrame:CGRectMake(10, self.NavigateBarHeight + 10, frame.size.width - 20, 45)];
    
    self.tfNick.borderStyle = UITextBorderStyleRoundedRect;
    
    self.tfNick.placeholder = @"请输入昵称";
    
    self.tfNick.textColor = [UIColor blackColor];
    
    self.tfNick.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.tfNick.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tfNick.layer.borderColor = [[self retRGBColorWithRed:228 andGreen:228 andBlue:228] CGColor];
    
    self.tfNick.layer.borderWidth = 1.0f;
    
    self.tfNick.layer.masksToBounds = YES;
    
    self.tfNick.layer.cornerRadius = 5.0f;

    
    [self addSubview:self.tfNick];

    
    UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, [self relativeY:self.tfNick.frame withOffY:25], 50, 20)];
    
    sexLabel.text = @"性别";
    
    sexLabel.textColor = [self retRGBColorWithRed:188 andGreen:188 andBlue:188];
    
    sexLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [self addSubview:sexLabel];
    
    UIImageView *manImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"man.png"]];
    
    manImage.frame = CGRectMake(frame.size.width * 0.28 - 15, [self relativeY:self.tfNick.frame withOffY:24], 20, 20);
    
    [self addSubview:manImage];
    
    self.btnMan = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width * 0.28, [self relativeY:self.tfNick.frame withOffY:20], 50, 30)];
    
    [self.btnMan setImage:[UIImage imageNamed:@"check_bt2.png"] forState:UIControlStateNormal];
    
    [self.btnMan setImage:[UIImage imageNamed:@"check_bt1.png"] forState:UIControlStateSelected];
    
    [self.btnMan setTitle:@"男" forState:UIControlStateNormal];
    
    [self.btnMan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.btnMan.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    self.btnMan.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    
    self.btnMan.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    self.btnMan.selected = YES;
   
    [self.btnMan addTarget:self action:@selector(sexBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnMan];
    
    
    UIImageView *womanImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"woman.png"]];
    
    womanImage.frame = CGRectMake(frame.size.width * 0.6 - 15, [self relativeY:self.tfNick.frame withOffY:24], 20, 20);
    
    [self addSubview:womanImage];

    self.btnWoman = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width * 0.6, [self relativeY:self.tfNick.frame withOffY:20], 50, 30)];
    
    [self.btnWoman setImage:[UIImage imageNamed:@"check_bt2.png"] forState:UIControlStateNormal];
    
    [self.btnWoman setImage:[UIImage imageNamed:@"check_bt1.png"] forState:UIControlStateSelected];
    
    [self.btnWoman setTitle:@"女" forState:UIControlStateNormal];
    
    [self.btnWoman setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.btnWoman.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    self.btnWoman.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    
    self.btnWoman.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    [self.btnWoman addTarget:self action:@selector(sexBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnWoman];

    
    self.tfPwd = [[UITextField alloc]initWithFrame:CGRectMake(10, [self relativeY:sexLabel.frame withOffY:25], frame.size.width - 20, 45)];
    
    self.tfPwd.borderStyle = UITextBorderStyleRoundedRect;
    
    self.tfPwd.placeholder = @"请输入密码";
    
    self.tfPwd.textColor = [UIColor blackColor];
    
    self.tfPwd.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.tfPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tfPwd.secureTextEntry = YES;
    
    self.tfPwd.layer.borderColor = [[self retRGBColorWithRed:228 andGreen:228 andBlue:228] CGColor];
    
    self.tfPwd.layer.borderWidth = 1.0f;
    
    self.tfPwd.layer.masksToBounds = YES;
    
    self.tfPwd.layer.cornerRadius = 5.0f;
    
    [self addSubview:self.tfPwd];
    
    
    self.tfRePwd = [[UITextField alloc]initWithFrame:CGRectMake(10, [self relativeY:self.tfPwd.frame withOffY:10], frame.size.width - 20, 45)];
    
    self.tfRePwd.borderStyle = UITextBorderStyleRoundedRect;
    
    self.tfRePwd.placeholder = @"请输入确认密码";
    
    self.tfRePwd.textColor = [UIColor blackColor];
    
    self.tfRePwd.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    self.tfRePwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tfRePwd.secureTextEntry = YES;
    
    self.tfRePwd.layer.borderColor = [[self retRGBColorWithRed:228 andGreen:228 andBlue:228] CGColor];
    
    self.tfRePwd.layer.borderWidth = 1.0f;
    
    self.tfRePwd.layer.masksToBounds = YES;
    
    self.tfRePwd.layer.cornerRadius = 5.0f;
    
    [self addSubview:self.tfRePwd];
    
    

    self.btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.btnFinish.frame = CGRectMake(10, [self relativeY:self.tfRePwd.frame withOffY:30], frame.size.width - 20, 45);
    
    [self.btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.btnFinish setTitle:@"完 成" forState:UIControlStateNormal];
    
    self.btnFinish.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    self.btnFinish.backgroundColor = [self retRGBColorWithRed:57 andGreen:158 andBlue:239];
    
    self.btnFinish.layer.cornerRadius = 5.0f;
    
    self.btnFinish.layer.masksToBounds = YES;
    
    [self.btnFinish addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnFinish];

}

-(void)sexBtnAction:(UIButton *)btn
{
    if (btn == self.btnMan) {
        self.btnMan.selected = YES;
        self.btnWoman.selected = NO;
    }else{
        self.btnMan.selected = NO;
        self.btnWoman.selected = YES;
    }
}



@end
