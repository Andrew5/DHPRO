//
//  NewFriendViewController.m
//  publicZnaer
//
//  Created by 吴小星 on 15-1-8.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "NewFriendViewController.h"
#import "UserInfoStorage.h"
#import "UserEntity.h"
#import "TempAuditDao.h"
#import "UIImageView+AFNetworking.h"
#import "FriendInfoViewController.h"

@interface NewFriendViewController ()
{
    TempAuditDao *_tempAuditDao;
}
@end

@implementation NewFriendViewController
@synthesize friendView,dateList,_friendHandler,auditList;

#define ACCEPT @"1"//接受好友请求
#define REJECT @"2"//拒绝好友请求

-(void)loadView{
    [super loadView];
    self.friendView=[[NewFriendView alloc]initWithFrame:self.view.frame];
    self.view=self.friendView;
    auditList=[[NSMutableArray alloc]init];
    _friendHandler = [[FriendManagerHandler alloc]init];
    _tempAuditDao = [TempAuditDao sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated{
    [self hideTabBar];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self showTabBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"新朋友"];
    [self hideTabBar];
    
     __unsafe_unretained NewFriendViewController *safeSelf = self;
    
    _friendHandler.successBlock=^(id obj){
        
        NSDictionary *resultInfor=obj;
        int opt = [[resultInfor objectForKey:REQUEST_ACTION]intValue];

        if (opt == REQUEST_FRIEND_OPT) {
            NSArray *auditArray = [resultInfor objectForKey:RET_RESULT];
            
            for (FriendEntity *entity in auditArray) {
                entity.auditState = REQUEST_AUDIT;
                //先保存在数据库
                [safeSelf->_tempAuditDao saveTempFriend:entity];
            }
            
            safeSelf->dateList = [NSMutableArray arrayWithArray:[safeSelf->_tempAuditDao getAllDatas]];
            [safeSelf.friendView.tableview reloadData];
        }
        else if (opt == AUDIT_FRIEND_OPT){
            //审核好友操作

            NSString *state = [resultInfor objectForKey:@"state"];
            FriendEntity *entity = [resultInfor objectForKey:@"friend"];
            if ([ACCEPT isEqualToString:state]) {
                //接受
                entity.auditState = ACCEPT_AUDIT;
               
                //通知通讯录列表保存更新数据
                [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONTACTS object:entity];
            }else{
                //拒绝
                 entity.auditState = REJECT_AUDIT;
            }
            [safeSelf.friendView.tableview reloadData];
            [safeSelf->_tempAuditDao saveTempFriend:entity];
        }

        
    };
    
    self.friendView.tableview.dataSource=self;
    self.friendView.tableview.delegate=self;
 
    UserInfoStorage *userStorage = [UserInfoStorage defaultStorage];
    UserEntity *userInfor=[userStorage getUserInfo];
    [_friendHandler searchNewFriend:userInfor.equipID];
    
}


#pragma mark TableViewDateSource and tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dateList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
       
        cell.imageView.layer.cornerRadius = 5.0f;
        cell.imageView.layer.masksToBounds = YES;
        
    
    }
    
    
    FriendEntity *entity = [dateList objectAtIndex:indexPath.row];
   
    cell.textLabel.text = entity.equipName;
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = entity.applyDesc;
    
    NSString *placeHolderHead = (entity.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
    
    NSString *imageUrl = [BaseHandler retImageUrl:entity.equipIcon];
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderHead]];
    
    /**---------这固定imageview大小----------**/
    CGSize itemSize = CGSizeMake(50, 50);
    
    UIGraphicsBeginImageContext(itemSize);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    
    [cell.imageView.image drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    /**-----------END-------------------**/
    
    switch (entity.auditState) {
        case REQUEST_AUDIT:{
            //请求审核
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 60, 35);
            btn.backgroundColor = [UIColor greenColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 3.0f;
            btn.tag = indexPath.row;
            [btn setTitle:@"接受" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = btn;
            break;
        }
        case ACCEPT_AUDIT:{
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 35)];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor greenColor];
            label.text = @"已添加";
            cell.accessoryView = label;
            break;
        }
        case REJECT_AUDIT:{
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 35)];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor redColor];
            label.text = @"已拒绝";
            cell.accessoryView = label;
            break;
        }
        case WAITE_AUDIT:{
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 35)];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor grayColor];
            label.text = @"等待审核";
            cell.accessoryView = label;
            break;
        }
           
            
        default:
            break;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendEntity *entity = dateList[indexPath.row];
    FriendInfoViewController *infoVC = [[FriendInfoViewController alloc]init];
    self.valueDelegate = infoVC;
    [self.valueDelegate setValue:entity];
    [self.navigationController pushViewController:infoVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendEntity *entity = [dateList objectAtIndex:indexPath.row];
    [_tempAuditDao deleteData:entity];
    [dateList removeObjectAtIndex:indexPath.row];
    [self.friendView.tableview reloadData];
}

#pragma mark - Button Action
-(void)btnAction:(UIButton *)button{
    FriendEntity *entity = dateList[button.tag];
    NSString *titleStr = [NSString stringWithFormat:@"您是否接受%@的好友请求",entity.equipName];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:titleStr delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"接受",@"拒绝", nil];
    sheet.tag = button.tag;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //接受
        FriendEntity *entity = dateList[actionSheet.tag];
        [self agree:entity];
    }
    else if (buttonIndex == 1){
        //拒绝
        FriendEntity *entity = dateList[actionSheet.tag];
        [self refust:entity];
    }
}


#pragma mark -
#pragma mark -好友审核
-(void)refust:(FriendEntity *)entity{
    
    UserInfoStorage *userStorage = [UserInfoStorage defaultStorage];
    UserEntity *userInfor=[userStorage getUserInfo];
    [_friendHandler audit:userInfor.equipID andFriend:entity andState:REJECT];

}

-(void)agree:(FriendEntity *)entity{
    
    UserInfoStorage *userStorage = [UserInfoStorage defaultStorage];
    UserEntity *userInfor=[userStorage getUserInfo];
    [_friendHandler audit:userInfor.equipID andFriend:entity andState:ACCEPT];
}

@end
