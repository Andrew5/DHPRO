//
//  PostTableViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/9.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "PostTableViewController.h"
static NSMutableArray *currentImages;

@interface PostTableViewController ()
@property (weak, nonatomic) IBOutlet UITextView *shareContent;
- (IBAction)postStatus:(id)sender;
- (IBAction)cancelPost:(id)sender;
-(void) loadSNSStatus;
@property (weak, nonatomic) IBOutlet UISwitch *DoubanSwitch;
@property (weak, nonatomic) IBOutlet UITextView *backgroundTextView;
@property NSMutableArray *snsArray;
//@property NSMutableArray *photos;
//@property NineShareService *dataContext;
@property NSMutableDictionary *tempDict;
-(void) openCamera;
-(void) openLibary;
@end

@implementation PostTableViewController
- (void)WeiboSwitched:(id)sender{
    
}
- (void)RenrenSwitched:(id)sender{
    
}
-(void)DoubanSwitched:(id)sender{
    
}
-(void)postStatus:(id)sender{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if(currentImages ==nil)
    {
        currentImages=[[NSMutableArray alloc] init];
    }
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self loadSNSStatus];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [_photosCollectionView reloadData];
}

-(void) loadSNSStatus{
    _snsArray=[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sns" ofType:@"plist"]];
    if(_snsArray.count>0)
    {
        [_WeiboSwitch setOn:[_snsArray[0] boolValue] animated:YES];
        [_RenrenSwitch setOn:[_snsArray[1] boolValue] animated:YES];
        [_DoubanSwitch setOn:[_snsArray[2] boolValue] animated:YES];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![text isEqualToString:@""])
    {
        [_backgroundTextView setHidden:YES];
    }
    if ([text isEqualToString:@""]&&range.length==1&&range.location==0) {
        [_backgroundTextView setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = textView.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==currentImages.count)
    {
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从摄像头选取", @"从图片库选择",nil];
        [action showInView:self.view];
    }
    else
    {
        [YSYPreviewViewController setPreviewImage:currentImages[indexPath.row]];
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PreviewVC"] animated:YES];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return currentImages.count==0?1:currentImages.count+1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    if(currentImages.count==0||indexPath.row==currentImages.count)
    {
        imageView.image=[UIImage imageNamed:@"Add"];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        imageView.image=currentImages[indexPath.row];
    }
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView];
    return  cell;
}
-(void)saveSNSToFile{
    NSString *destPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"sns" ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:destPath error:nil];
    }
    if(_snsArray==nil)
        _snsArray=[[NSMutableArray alloc] init];
    [_snsArray removeAllObjects];
    [_snsArray addObject:_WeiboSwitch.isOn?@"YES":@"NO"];
    [_snsArray addObject:_RenrenSwitch.isOn?@"YES":@"NO"];
    [_snsArray addObject:_DoubanSwitch.isOn?@"YES":@"NO"];
    if(_snsArray.count>0)
    {
        [_snsArray writeToFile:destPath atomically:YES];
    }
}
//- (IBAction)postStatus:(id)sender {
//    if(_WeiboSwitch.isOn)
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_shareContent.text.length>0?_shareContent.text: @"9Share for ios test message" image:currentImages.count==0?nil:currentImages[0] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                if(!(_RenrenSwitch.isOn||_DoubanSwitch.isOn))
//                {
//                    [self saveSNSToFile];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
//            }
//        }];
//    if(_RenrenSwitch.isOn)
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToRenren] content:_shareContent.text.length>0?_shareContent.text: @"9Share for ios test message" image:currentImages.count==0?nil:currentImages[0] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                if(!_DoubanSwitch.isOn)
//                {
//                    [self saveSNSToFile];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
//            }
//        }];
//    if(_DoubanSwitch.isOn)
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToDouban] content:_shareContent.text.length>0?_shareContent.text: @"9Share for ios test message" image:currentImages.count==0?nil:currentImages[0] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                [self saveSNSToFile];
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }
//        }];
//}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *tempData=UIImageJPEGRepresentation(image, 0.5f);
    image=[UIImage imageWithData:tempData];
    if(currentImages ==nil)
    {
        currentImages=[[NSMutableArray alloc] init];
    }
    [currentImages addObject:image];
    [_photosCollectionView reloadData];
    // [self saveImage:image withName:@""]
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelPost:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self openLibary];
            break;
        default:
            break;
    }
}
-(void)openCamera{
    //UIImagePickerControllerSourceType *type=UIImagePickerControllerSourceTypeCamera;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
-(void)openLibary{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing=YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
-(void) saveImage:(UIImage *)image withName:(NSString *)name
{
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:name];
    [imageData writeToFile:path atomically:YES];
}
//- (IBAction)DoubanSwitched:(id)sender {
//    if(_DoubanSwitch.isOn){
//        if(![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToDouban])
//        {
//            //进入授权页面
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToDouban].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    //获取微博用户名、uid、token等
//                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToDouban];
//                    NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
//                    //进入你的分享内容编辑页面
//                    UMSocialAccountEntity *doubanAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToDouban];
//                    doubanAccount.usid = snsAccount.usid;
//                    doubanAccount.accessToken = snsAccount.accessToken;
//                    //	weiboAccount.openId = @"tencent weibo openId";		  //腾讯微博账户必需设置openId
//                    //同步用户信息
//                    [UMSocialAccountManager postSnsAccount:doubanAccount completion:^(UMSocialResponseEntity *response){
//                        if (response.responseCode == UMSResponseCodeSuccess) {
//                            //在本地缓存设置得到的账户信息
//                            [UMSocialAccountManager setSnsAccount:doubanAccount];
//                            //进入你自定义的分享内容编辑页面或者使用我们的内容编辑页面
//                        }}];
//                }
//                else {
//                    [_DoubanSwitch setOn:NO animated:YES];
//                }
//            });
//        }
//    }
//}
//- (IBAction)RenrenSwitched:(id)sender {
//    if(_DoubanSwitch.isOn)
//    {
//        if(![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToRenren])
//        {
//            //进入授权页面
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToRenren].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    //获取微博用户名、uid、token等
//                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToRenren];
//                    NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
//                    //进入你的分享内容编辑页面
//                    UMSocialAccountEntity *renrenAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToRenren];
//                    renrenAccount.usid = snsAccount.usid;
//                    renrenAccount.accessToken = snsAccount.accessToken;
//                    //	weiboAccount.openId = @"tencent weibo openId";		  //腾讯微博账户必需设置openId
//                    //同步用户信息
//                    [UMSocialAccountManager postSnsAccount:renrenAccount completion:^(UMSocialResponseEntity *response){
//                        if (response.responseCode == UMSResponseCodeSuccess) {
//                            //在本地缓存设置得到的账户信息
//                            [UMSocialAccountManager setSnsAccount:renrenAccount];
//                            //进入你自定义的分享内容编辑页面或者使用我们的内容编辑页面
//                        }}];
//                }
//                else{
//                    [_RenrenSwitch setOn:NO animated:YES];
//                }
//            });
//        }
//    }
//}
//- (IBAction)WeiboSwitched:(id)sender {
//    if(_WeiboSwitch.isOn)
//    {
//        if(![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina])
//        {
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//                if(response.responseCode==UMSResponseCodeSuccess){
//                    UMSocialAccountEntity *snsAccount=[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
//                    UMSocialAccountEntity *sinaAccount=[[UMSocialAccountEntity alloc] initWithPlatformName:UMShareToSina];
//                    //缓存到本地
//                    sinaAccount.usid = snsAccount.usid;
//                    sinaAccount.accessToken = snsAccount.accessToken;
//                    //	weiboAccount.openId = @"tencent weibo openId";		  //腾讯微博账户必需设置openId
//                    //同步用户信息
//                    [UMSocialAccountManager postSnsAccount:sinaAccount completion:^(UMSocialResponseEntity *response){
//                        if (response.responseCode == UMSResponseCodeSuccess) {
//                            //在本地缓存设置得到的账户信息
//                            [UMSocialAccountManager setSnsAccount:sinaAccount];
//                            //进入你自定义的分享内容编辑页面或者使用我们的内容编辑页面
//                        }}];
//                }
//                else
//                {
//                    [_WeiboSwitch setOn:NO animated:YES];
//                }
//            });
//        }
//    }
//}
+(void)deleteSelectedImage:(NSInteger)index
{
    if(currentImages!=nil)
        [currentImages removeObjectAtIndex:index];
}
+(void)deleteSelectedImageWithImage:(UIImage *)image{
    if(currentImages!=nil)
        [currentImages removeObject:image];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark - return the number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
#pragma mark - return the number of rows

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
