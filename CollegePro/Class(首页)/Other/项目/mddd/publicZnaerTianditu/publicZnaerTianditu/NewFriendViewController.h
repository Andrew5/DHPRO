//
//  NewFriendViewController.h
//  publicZnaer
//
//  Created by 吴小星 on 15-1-8.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "NewFriendView.h"
#import "FriendManagerHandler.h"

#define UPDATE_CONTACTS @"update_contacts"

@interface NewFriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>


@property(nonatomic,retain)NSMutableArray *dateList;
@property(nonatomic,retain) NewFriendView *friendView;
@property(nonatomic,retain)FriendManagerHandler *_friendHandler;
@property(nonatomic,assign)NSInteger selectTag;
@property(nonatomic,retain) NSMutableArray *auditList;
@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;
@end
