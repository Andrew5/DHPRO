//
//  FriendInfoViewController.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "FriendEntity.h"
#import "FriendManagerHandler.h"
#import "UserEntity.h"
#import "UserInfoStorage.h"
#import "UIImageView+AFNetworking.h"
#import "TempAuditDao.h"
#import "ShowQRCodeViewController.h"
@interface FriendInfoViewController ()
{
    FriendEntity *_friend;
    FriendManagerHandler *_handler;
    UserEntity *_user;
}
@end

@implementation FriendInfoViewController

-(void)loadView{
    [super loadView];
    
    self.infoView = [[FriendInfoView alloc]initWithController:self];
    
    [self.view addSubview:self.infoView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"好友信息"];
    
    [self.infoView.makeFriendBtn addTarget:self action:@selector(markFriendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.infoView.codeBtn addTarget:self action:@selector(showQRCode) forControlEvents:UIControlEventTouchUpInside];
    _handler = [[FriendManagerHandler alloc]init];
    
    __unsafe_unretained FriendInfoViewController *safeSelf = self;
    
    _handler.successBlock = ^(id obj){
        int opt = [[obj objectForKey:REQUEST_ACTION]intValue];
        if (opt == GET_FRIEND_INFO_OPT) {
            safeSelf -> _friend = [obj objectForKey:@"friend"];
            [safeSelf setInfo];
        }
        else if (opt == APPLY_AUDIT_OPT){
            //保存好友信息到临时好友表
            safeSelf -> _friend.auditState = WAITE_AUDIT;
            TempAuditDao *dao = [[TempAuditDao alloc]init];
            [dao saveTempFriend:safeSelf -> _friend];
            safeSelf.infoView.makeFriendBtn.hidden = YES;
        }
        
    };
    
    [_handler getFriendInfo:_friend.equipId];
}

-(void)setInfo{
    self.infoView.nameLabel.text = _friend.equipName;
    
    NSString *placeHolderHead = (_friend.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
    NSString *imageUrl = [BaseHandler retImageUrl:_friend.equipIcon];
    [self.infoView.headImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:placeHolderHead]];
 
    self.infoView.psLabel.text = _friend.remark;
    
    if (_friend.relationship == FRIEND) {
        self.infoView.makeFriendBtn.hidden = YES;
    }
}

-(void)markFriendBtnAction{
    _user = [[[UserInfoStorage alloc]init] getUserInfo];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"添加好友" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.text = [NSString stringWithFormat:@"我是%@",_user.nickName];
    
    [alertView show];
}

-(void)showQRCode{
    ShowQRCodeViewController *codeVC = [[ShowQRCodeViewController alloc]init];
    self.valueDelegate = codeVC;
    [self.valueDelegate setValue:_friend.equipId];
    [self.navigationController pushViewController:codeVC animated:YES];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *des = tf.text;
        
        NSDictionary *params = @{@"equipId":_user.equipID,@"friendEquipId":_friend.equipId,@"applyDesc":des};
        [_handler applyMakeFriend:params];
    }
}

#pragma mark - PassValueDelegate
- (void)setValue:(NSObject *)value{
    _friend = (FriendEntity *)value;
}

@end
