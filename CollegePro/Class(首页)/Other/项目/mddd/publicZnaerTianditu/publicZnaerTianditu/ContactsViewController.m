//
//  ContactsViewController.m
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "ContactsViewController.h"
#import "UserInfoStorage.h"
#import "UserEntity.h"
#import "BDMapViewController.h"
#import "FriendDao.h"
#import "UIImageView+AFNetworking.h"
#import "MJExtension.h"
#import "MainTabBarController.h"
#import "JPSPopoverView.h"
#import "AddFirendViewController.h"
//#import "ScanViewController.h"
@implementation ContactsViewController
{
    FriendDao *_dao;
    FriendEntity *_selectedEntity;
    FriendEntity *_deledEntity;
}
@synthesize contactsView,friendHandler;

-(void)loadView
{
    [super loadView];
    
    self.contactsView = [[ContactsView alloc]initWithController:self];
    [self.view addSubview:self.contactsView];
    friendHandler=[[FriendManagerHandler alloc]init];
    _dao = [FriendDao sharedInstance];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"通讯录"];
    
    [self initNav];
    
    [self hideLeftBackBtn];
    
    __unsafe_unretained ContactsViewController *safeSelf = self;
    
    friendHandler.successBlock=^(id obj){
        
        int opt = [[obj objectForKey:REQUEST_ACTION]intValue];
        switch (opt) {
            case GET_ALL_FRIENDS_OPT:{
                //获取通讯录列表返回
                safeSelf->_dataList=[NSMutableArray arrayWithArray:[obj objectForKey:RET_RESULT]];
                //保存数据到本地数据库
                [safeSelf->_dao saveFriendArray:safeSelf->_dataList];
                
                [safeSelf showSectionName];
                 break;
            }
            case GET_FRIEND_LOCATION_OPT:{
                
                NSDictionary *retDic = [obj objectForKey:RET_RESULT];
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:retDic];
                [info setObject:safeSelf->_selectedEntity.equipId forKey:@"equipId"];
                [info setObject:safeSelf->_selectedEntity.equipName forKey:@"equipName"];
                [info setObject:(safeSelf->_selectedEntity.equipIcon ? safeSelf->_selectedEntity.equipIcon : @"")forKey:@"equipIcon"];
                [info setObject:[NSNumber numberWithInt:safeSelf->_selectedEntity.gender] forKey:@"gender"];
             //   [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_FRIEND_LOCATION object:info];
                
                [safeSelf.valueDelegate setValue:info];
                
                [(MainTabBarController *)safeSelf.tabBarController backFirstVC];
                break;
            }
            case DEL_FRIEND_OPT:{
                FriendEntity *entity = [obj objectForKey:RET_RESULT];
                [safeSelf -> _dataList removeObject:entity];
                [safeSelf -> _dao deleteFriend:entity];
                [safeSelf showSectionName];
                [safeSelf.contactsView.tableview reloadData];
                break;
            }
                
               
                
            default:
                break;
        }
        
        
    };
    
    self.dataList = [NSMutableArray arrayWithArray:[_dao getAllFriend]];
    
    //如果本地没有数据，就发送网络请求获取
    if (self.dataList.count == 0) {
        UserInfoStorage *userInfor=[UserInfoStorage defaultStorage];
        UserEntity *user = [userInfor getUserInfo];
        [self.friendHandler searchContacts:user.equipID];
    }
    else{
        [self showSectionName];
    }
    
    self.contactsView.tableview.dataSource = self;
    self.contactsView.tableview.delegate = self;
    
    self.contactsView.searchBar.placeholder = @"输入查询关键字";
    self.contactsView.searchBar.delegate = self;
    
    [self.contactsView.searchBar sizeToFit];
    
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.contactsView.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showTabBar];
}

-(void)initNav{
    
    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [search addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [search setImage:[UIImage imageNamed:@"search_bt.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc]initWithCustomView:search];
    
    
    UIButton *add = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [add setImage:[UIImage imageNamed:@"add_bg.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithCustomView:add];
    
    [self.navigationItem setRightBarButtonItems:@[addBtn,searchBtn]];
    
    UIImageView *logoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_logo.png"]];
    UIBarButtonItem *leftLogo = [[UIBarButtonItem alloc]initWithCustomView:logoImage];
    [self.navigationItem setLeftBarButtonItem:leftLogo];
}

-(void)doSearch{
    
    
}

-(void)doAdd{
    CGPoint point = CGPointMake(self.view.frame.size.width-30, 65);
    JPSPopoverView *popView = [[JPSPopoverView alloc]initWithPoint:point];
    
    popView.selectItemAtIndex = ^(NSInteger index){
        
        if (index == 0) {
            
            AddFirendViewController *addController = [[AddFirendViewController alloc]init];
            [self hideTabBar];
            [self.navigationController pushViewController:addController animated:YES];
            
        }else{
//            [self.navigationController pushViewController:[[ScanViewController alloc]init] animated:YES];
//            [self hideTabBar];
        }
    };
    
    [popView show];
    
}

//显示右边快速搜索条
-(void)showSectionName{
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *unsortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
    for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    for(FriendEntity *entity in _dataList){
        
        NSInteger index = [collation sectionForObject:entity.equipName collationStringSelector:@selector(description)];
        [[unsortedSections objectAtIndex:index] addObject:entity];
    }
    
    
    NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unsortedSections.count];
    
    for (NSMutableArray *section in unsortedSections) {
        
        [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
    }
    
    self.sections = sortedSections;
    
    [self.contactsView.tableview reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 //   [[NSNotificationCenter defaultCenter]removeObserver:self name:UPDATE_CONTACTS object:nil];
    if (animated) {
        [self.contactsView.tableview flashScrollIndicators];
    }
}

- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [self.contactsView.tableview scrollRectToVisible:self.contactsView.searchBar.frame animated:animated];
}

#pragma mark - TableView Delegate and DataSource

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 60.0f;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.contactsView.tableview) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.contactsView.tableview) {
        if (section==0) {
            return nil;
        }else{
            
            if ([[self.sections objectAtIndex:section-1] count] > 0) {
                
                return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section-1];
            } else {
                return nil;
            }
            
        }
        
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self scrollTableViewToSearchBarAnimated:NO];
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 because we add the search symbol
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.contactsView.tableview) {
        
        return self.sections.count+1;
        
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.contactsView.tableview) {
        if (section ==0) {
            return 1;
        }else{
            return [[self.sections objectAtIndex:section-1] count];
        }
        //        return [[self.sections objectAtIndex:section] count];
    } else {
        return self.filteredList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
        imageView.layer.cornerRadius = 5.0f;
        imageView.layer.masksToBounds = YES;
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, tableView.frame.size.width - 80, 30)];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.tag = 200;
        [cell.contentView addSubview:nameLabel];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel     *nameLabel = (UILabel *)[cell.contentView viewWithTag:200];
    
    if (tableView == self.contactsView.tableview) {
        
       
        if (indexPath.section==0) {
            nameLabel.text=@"新朋友";
            imageView.image = [UIImage imageNamed:@"user_icon_add_03.png"];
        }else{
           
            
            FriendEntity *entity=[[self.sections objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            
            nameLabel.text = entity.equipName;
            
            NSString *placeHolderHead = (entity.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
            
            NSString *imageUrl = [BaseHandler retImageUrl:entity.equipIcon];
            NSURL *url = [NSURL URLWithString:imageUrl];
          
            [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderHead]];
           
            
            
        }
    } else {
    
        FriendEntity *entity = [self.filteredList objectAtIndex:indexPath.row];
        nameLabel.text=entity.equipName;
       
        NSString *placeHolderHead = (entity.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
        
        NSString *imageUrl = [BaseHandler retImageUrl:entity.equipIcon];
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderHead]];
        
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.contactsView.tableview == tableView) {
        if (indexPath.section==0&&indexPath.row==0) {
            
           NewFriendViewController *newFriendVC=[[NewFriendViewController alloc]init];
            
           [self.navigationController pushViewController:newFriendVC animated:YES];
            
           [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationUpdateContacts:) name:UPDATE_CONTACTS object:nil];
            
        }else{
            //查询好友最近共享位置
            FriendEntity *entity=[[self.sections objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            [friendHandler getFriendCurrentLocation:entity.equipId];
            _selectedEntity = entity;
            
        }

    }else{
        FriendEntity *entity = [self.filteredList objectAtIndex:indexPath.row];
        [friendHandler getFriendCurrentLocation:entity.equipId];
        _selectedEntity = entity;
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _deledEntity = [[self.sections objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除" message:[NSString stringWithFormat:@"确定要删除%@吗？",_deledEntity.equipName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        if (_deledEntity)
            [friendHandler deleteFrient:_deledEntity];

    }
    
}

#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.filteredList = self.dataList;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.filteredList = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    self.filteredList = [self.filteredList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"equipName contains[cd] %@", searchString]];
        
    return YES;
}

-(void)notificationUpdateContacts:(NSNotification *)notification{
    FriendEntity *entity = notification.object;
    [_dao saveFriend:entity];
    [_dataList addObject:entity];
    [self showSectionName];
    [self.contactsView.tableview reloadData];
}

@end
