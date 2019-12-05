//
//  loginInterface.m
//  registrationDebarkation
//
//  Created by 邵峰 on 2017/4/6.
//  Copyright © 2017年 邵峰. All rights reserved.
//

#import "loginInterface.h"

@implementation loginInterface

+(instancetype)loadLoginView
{
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];

}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.loginBtn.tag = login;
    self.registerBtn.tag = registerBtn;
    self.forgetBtn.tag = forgetBtn;
    self.facebook.tag = facebook;
    self.google.tag = google;
    self.skip.tag = skip;
    
}

- (void)btnClicked:(btnClicked)block
{
    _block = block;
}
- (IBAction)BtnClickedAction:(UIButton *)sender {
    
    if (_block) {
        _block((int)sender.tag);
    }
}

@end
