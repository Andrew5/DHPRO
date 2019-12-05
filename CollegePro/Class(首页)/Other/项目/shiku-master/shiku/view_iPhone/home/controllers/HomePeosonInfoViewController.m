//
//  HomePeosonInfoViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomePeosonInfoViewController.h"
// 配置列表
#import "HomePeosonInfoTableViewCell.h"
#import "HomeInfomanagerViewController.h"
#import "HomemapTableViewCell.h"
#import "UserViewController.h"
#import "SearchViewController.h"
#import "HomeViewControllernew.h"
@interface HomePeosonInfoViewController ()<UITextFieldDelegate,HomePeosonInfoTableViewCellDelegate,UserLoginViewControllerDelegate>

@end

@implementation HomePeosonInfoViewController
-(void)searchFieldTouched{
    SearchViewController *sc=[SearchViewController new];
    [self.navigationController pushViewController:sc animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *searchFieldView=[self tToolbarSearchField:[UIScreen mainScreen].bounds.size.width-100 withheight:20
                               isbecomeFirstResponder:false action:@selector(searchFieldTouched) textFieldDelegate:self];
    searchFieldView.autoresizingMask=YES;
    self.navigationItem.titleView=searchFieldView;
    
    rowNum =    _imageDic.allKeys.count+2;
    rowNum = rowNum<3?3:rowNum;
    self.navigationItem.leftBarButtonItem = [self leftBarBtnItem];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(5, 10, 26, 20);
    [rightBtn setImage:[UIImage imageNamed:@"iii_05"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    
}
- (void)getChange:(HomePersonBlock)block
{
    self.block = block;
}
-(void)clickleftButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
//返回区域数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}
//返回某区域内的行数   返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return rowNum;
}
//配置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //重用单元，当单元滚动出屏幕再出现在屏幕上时

    if (indexPath.row == 0) {
        HomePeosonInfoTableViewCell *cell = [HomePeosonInfoTableViewCell cellWithTableView:tableView];
        cell.delegate =self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell.labelmname) {
            cell.labelmname.text = [NSString stringWithFormat:@"农户姓名:%@",_mname];//;
        }
        else{
            cell.labelmname.text = @"农户姓名";

        }
        if (_titleStr == nil) {
            
            cell.labelTitle.text = @"农场主";

        }
        else{
            cell.labelTitle.text = _titleStr;

        }
        if ([_attentionStr isEqualToString:@" "]) {
            cell.labelAttention.text = @"0";
        }else {
            cell.labelAttention.text = _attentionStr;
        }
        
        if ([_stratStr intValue] == 1) {
            cell.imageStartone.hidden = NO;
        }
        else if ([_stratStr intValue] == 2) {
            cell.imageStartone.hidden = NO;
            cell.imageStarttwo.hidden = NO;
            
        }
        else if ([_stratStr intValue] == 3) {
            cell.imageStartone.hidden = NO;
            cell.imageStartthree.hidden = NO;
            cell.imageStarttwo.hidden = NO;
        }
        else if ([_stratStr intValue] == 4) {
            cell.imageStartone.hidden = NO;
            cell.imageStarttwo.hidden = NO;
            cell.imageStartthree.hidden = NO;
            cell.imageStartfour.hidden = NO;
            
        }
        else if ([_stratStr intValue] == 5) {
            cell.imageStartone.hidden = NO;
            cell.imageStarttwo.hidden = NO;
            cell.imageStartthree.hidden = NO;
            cell.imageStartfour.hidden = NO;
            cell.imageStartfive.hidden = NO;
        }
        
        if (_saleStr == nil) {
            cell.labelSales.text = @"0";
        }else{
            cell.labelSales.text = _saleStr;
        }
        if (_addressStr == nil) {
            cell.labelAdress.text = @"北京市密云县古北口口镇北甸子村";
        }else{
            cell.labelAdress.text =[NSString stringWithFormat:@"农户地址:%@",_addressStr];// ;
        }
        
        cell.btnAttention.selected = _isAttention==YES?1:0;
        [cell.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:_iconImage] placeholderImage:[UIImage imageNamed:@"FarmerIcon.png"]];
        cell.imageViewIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.imageViewIcon.layer.borderWidth = 2;
        cell.imageViewIcon.layer.masksToBounds = YES;
        return cell;
    }
    else if (indexPath.row == rowNum-1){
        HomemapTableViewCell *cell = [HomemapTableViewCell cellWithTableView:tableView];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        [cell.imageViewMap sd_setImageWithURL:[NSURL URLWithString:_mapImage] placeholderImage:nil];
        if (!_addressStr) {
            cell.labelAdress.text = @"北京市密云县古北口口镇北甸子村";
        }else{
            cell.labelAdress.text =_addressStr;
        }
        
        return cell;
    }
    else {
        HomeInfomanagerViewController *cell = [HomeInfomanagerViewController cellWithTableView:tableView];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.labelComment.text = @"";

        if (indexPath.row==1) {
            cell.labelComment.text = _commentStr;

        }
        NSString *url = [Helper checkImgType:_imageDic[[NSString stringWithFormat:@"img_%ld",indexPath.row-1]]];
        
     
        [cell.imageViewGoods sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //        [cell.imageGoods sd_setImageWithURL:[NSURL URLWithString:url]];
            if (error) {
                [cell.imageViewGoods sd_setImageWithURL:[NSURL URLWithString:_imagU] placeholderImage:nil];
            }
        }];
        
        [cell.imageViewGoods setContentScaleFactor:[[UIScreen mainScreen] scale]];
        cell.imageViewGoods.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell.imageViewGoods.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageViewGoods.clipsToBounds = YES;
        
        return cell;
    }
}
//选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    }
    else if (indexPath.row == 1){
        CGSize maxSize = CGSizeMake(SCREEM_W-30,1000);
        CGSize size =  [self labelAutoCalculateRectWith:_commentStr FontSize:12 MaxSize:maxSize];
        return size.height +200+20;
    }
    else if (indexPath.row == rowNum-1){
        return 290;
    }
    return 220;
}
- (void)attentionAction:(UIButton *)sender
{
    USER *user = [App shared].currentUser;
    if (![user authorized]) {
        UserLoginViewController *userVC= [[UserLoginViewController alloc]init];
        [self showNavigationView:userVC];
        return;
    }
    [self Showprogress];
    sender.userInteractionEnabled = NO;

    if (sender.selected) {
        [self dele:sender];
    }else
    {
        [self add:sender];
    }
}

-(void)add:(UIButton *)sender{
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/member_favs/add",url_share];
    
    //    NSString *urlStr1 = @"http://api.shiku.com/buyerApi/member_favs/add";
    NSMutableDictionary * parmeter = [[NSMutableDictionary alloc]init];
    [parmeter setObject:[NSString stringWithFormat:@"{\"mid\":\"%@\"}",_midStr]
                 forKey:@"data"];
    
    [[[Backend alloc] init] POST:urlStr1 parameters:parmeter success:^(AFHTTPRequestOperation *operation,id json) {
        //DB3A57e3f81997b82a0f
        [self hideHUDView];
        NSString *s = json[@"status"];
        if ( [s isEqual:[NSNumber numberWithInt:0]]) {
            [self.view showHUD:json[@"result"] afterDelay:1.5];
        }else{
            _isAttention = YES;
            
            [self.view showHUD:@"关注成功" afterDelay:1.5];
            [self saveAttention];
            _attentionStr = [NSString stringWithFormat:@"%ld",[_attentionStr integerValue]+1];
            self.block(_attentionStr,_isAttention);

            [self.tableView reloadData];
            sender.userInteractionEnabled = YES;
        }
        
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sender.userInteractionEnabled = YES;

    }];
}
-(void)dele:(UIButton *)sender{
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/member_favs/delete",url_share];
    
    //    NSString *urlStr1 = @"http://www.shiku.com/buyerApi/member_favs/delete";
    NSMutableDictionary * parmeter = [[NSMutableDictionary alloc]init];
    __block UIButton *btn =sender;
    [parmeter setObject:[NSString stringWithFormat:@"{\"mid\":\"%@\"}",_midStr]
                 forKey:@"data"];
    [[[Backend alloc] init] POST:urlStr1 parameters:parmeter success:^(AFHTTPRequestOperation *operation,id json)  {
        sender.userInteractionEnabled = YES;
        [self hideHUDView];
        
        NSString *s = json[@"status"];
      
        if ( [s isEqual:[NSNumber numberWithInt:0]]) {
            [self.view showHUD:json[@"result"] afterDelay:1.5];
        }else{
            btn.selected = NO;
            
            _isAttention = NO;
            
            [self.view showHUD:@"已取消关注" afterDelay:1.5];
            [self saveAttention];
            _attentionStr = [NSString stringWithFormat:@"%ld",[_attentionStr integerValue]-1];
            [self.tableView reloadData];
            self.block(_attentionStr,_isAttention);
        }
    }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             sender.userInteractionEnabled = YES;

                         }
     ];
    
}
- (void)saveAttention
{
    NSUserDefaults *attentionUser = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *attentionList = [NSMutableArray arrayWithArray:[attentionUser objectForKey:@"attentionList"]];
    if (attentionList==nil) {
        attentionList = [NSMutableArray array];
    }
    [attentionList addObject:_midStr];

    [attentionUser setObject:attentionList forKey:@"attentionList"];
    
    [attentionUser synchronize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
