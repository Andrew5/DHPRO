//
//  AddressBookViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/25.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "AddressBookViewController.h"
#import "APAddress.h"
#import "APAddressBook.h"
#import "APContact.h"
#import "FriendManagerHandler.h"
#import "UserInfoStorage.h"
#import "UserEntity.h"


@interface AddressBookViewController ()
{
    APAddressBook *addressBook;
    FriendManagerHandler *_handler;
    NSMutableDictionary *_itemDic;//被操作的联系人项
    UserEntity *_user;
}
@end

#define STATE_KEY @"state"
#define CONTACT_KEY @"contact"

@implementation AddressBookViewController

-(void)loadView{
    [super loadView];
    
    self.addressBookView = [[AddressBookView alloc]initWithController:self];
   
    [self.view addSubview:self.addressBookView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"手机联系人"];
    
    self.addressBookView.tableView.delegate = self;
    
    self.addressBookView.tableView.dataSource = self;
    
    _handler = [[FriendManagerHandler alloc]init];
    
     __weak __typeof(self) weakSelf = self;
   
    _handler.successBlock = ^(id obj){
        NSDictionary *retDic = obj;
        int retCode = [[retDic objectForKey:REQUEST_ACTION]intValue];
       
        if (retCode == VALI_CONTACTS_OPT) {
            NSString *retResult = [retDic objectForKey:RET_RESULT];
            NSArray *resultArray = [retResult componentsSeparatedByString:@","];
            for (int i = 0; i < weakSelf.contactsArray.count; i ++ ) {
                APContact *contact = [weakSelf.contactsArray objectAtIndex:i];
                NSString *state = [resultArray objectAtIndex:i];
                NSDictionary *itemDic = @{STATE_KEY:state,CONTACT_KEY:contact};
               
                [weakSelf.contactsArray replaceObjectAtIndex:i withObject:itemDic];
               
            }
        }
        else if(retCode == APPLY_AUDIT_OPT){
            //好友请求成功返回
        }
        [weakSelf showSectionName];
    };
    
    [self loadContacts];
    
}



- (void)loadContacts
{
    addressBook = [[APAddressBook alloc] init];

//    __weak __typeof(self) weakSelf = self;
    __unsafe_unretained AddressBookViewController *weakSelf = self;
    addressBook.fieldsMask =  APContactFieldLastName | APContactFieldCompositeName | APContactFieldPhones;
    addressBook.sortDescriptors = @[
                                    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]];
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
     {
         
         if (!error)
         {
             
             weakSelf.contactsArray = [[NSMutableArray alloc]initWithArray:contacts];
           
             NSString *phones = [weakSelf splitPhoneStr];
             
             if (phones.length > 0) {
                 [weakSelf->_handler valiMobileContact:phones];
             }
             
         }
         else
         {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:error.localizedDescription
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
             [alertView show];
         }
     }];
    
  
}

//显示右边快速搜索条
-(void)showSectionName{
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
    for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for(NSDictionary *itemDic in self.contactsArray){
        APContact *contact = [itemDic objectForKey:CONTACT_KEY];
        NSInteger index = [collation sectionForObject:contact.compositeName collationStringSelector:@selector(description)];
        [[unsortedSections objectAtIndex:index] addObject:itemDic];
    }
    
    
    NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
    
    for (NSMutableArray *section in unsortedSections) {
        
        [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
    }
    
    self.sections = sortedSections;
    
    [self.addressBookView.tableView reloadData];
}

//拼接电话字符串
-(NSString *)splitPhoneStr{
    
    NSMutableString *contactsStr = [[NSMutableString alloc]init];
    
    for (int i = 0; i < self.contactsArray.count; i ++) {
        APContact *contact = [self.contactsArray objectAtIndex:i];
        NSString *phone = contact.phones[0];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [contactsStr appendString:phone];
        [contactsStr appendString:@","];
    }
    
    return [contactsStr substringToIndex:contactsStr.length - 1];

}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.sections objectAtIndex:section] count] > 0) {
        
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections objectAtIndex:section] count];;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.sections.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCell = @"contactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCell];
        
    }
    
    NSDictionary *itemDic = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    APContact *contact = [itemDic objectForKey:CONTACT_KEY];
    
    NSString *state = [itemDic objectForKey:STATE_KEY];
    
    if ([state isEqualToString:@"0"]) {
        //未注册用户
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 30);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"邀请" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:0.0f green:211/255.0f blue:11/255.0f alpha:1.0];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        
        [btn addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView = btn;
      
        cell.imageView.image = [UIImage imageNamed:@"user_icon_df_01.png"];

    }
    else if ([state isEqualToString:@"2"]){
        //已注册好友
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.text = @"已添加";
        cell.accessoryView = label;
       
        cell.imageView.image = [UIImage imageNamed:@"user_icon_baby_04.png"];
    }

    else {
//        state 就是联系人的equipID
        //已注册非好友
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 60, 30);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [btn setTitle:@"加好友" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        btn.layer.borderColor = [[UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f] CGColor];
        btn.layer.borderWidth = 1.0f;
        [btn addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = btn;
        
        cell.imageView.image = [UIImage imageNamed:@"user_icon_df_02.png"];
    }
    
    
    cell.textLabel.text = contact.compositeName;
    
    NSString *strPhone = contact.phones[0];
    
    cell.detailTextLabel.text = [strPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}


//点击按钮后走的方法
- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.addressBookView.tableView];
    NSIndexPath *indexPath = [self.addressBookView.tableView indexPathForRowAtPoint: currentTouchPosition];
    
    if (indexPath != nil)
    {
        [self tableView: self.addressBookView.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
   
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
   
    _itemDic = [NSMutableDictionary dictionaryWithDictionary:[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    APContact *contact = [_itemDic objectForKey:CONTACT_KEY];
    NSString *state = [_itemDic objectForKey:STATE_KEY];
    
    if ([@"0" isEqualToString:state]) {
        //未注册用户
        NSString *strBody = @"邀请加入在那儿";
        NSArray *phones = @[contact.phones[0]];
        [self sendSMS:strBody recipientList:phones];
    }
    else{
        //已注册用户，请求加好友
        UserInfoStorage *userInfoStorage = [UserInfoStorage defaultStorage];
        _user = [userInfoStorage getUserInfo];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"添加好友" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = [alertView textFieldAtIndex:0];
        tf.text = [NSString stringWithFormat:@"我是%@",_user.nickName];
        
        [alertView show];
        
    }
    
}

//发送短信
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        
        controller.body = bodyOfMessage;
        
        controller.recipients = recipients;
        
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }   
    
}

#pragma MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent){
        //修改状态
         NSLog(@"Message success");
    }
 
        
    
    else
        NSLog(@"Message failed");
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *des = tf.text;
        
        NSString *equipId = [_itemDic objectForKey:STATE_KEY];
    
        [self.addressBookView.tableView reloadData];
        NSDictionary *params = @{@"equipId":_user.equipID,@"friendEquipId":equipId,@"applyDesc":des};
        [_handler applyMakeFriend:params];
    }
}

@end
