//
//  MeInfoViewController.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/20.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "MeInfoViewController.h"
#import "UserEntity.h"
#import "UIImageView+AFNetworking.h"
#import "AlertInfoItemViewController.h"
#import "UserManagerHandler.h"
#import "UserInfoStorage.h"
#import "ShowQRCodeViewController.h"
@interface MeInfoViewController ()
{

    UserEntity *_userEntity;
    UIImage *_headImage;
    UserManagerHandler *_handler;
}
@end

@implementation MeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的资料";
    
    self.infoView = [[MeInfoView alloc]initWithController:self];
    self.infoView.tableview.delegate = self;
    self.infoView.tableview.dataSource = self;

    [self.view addSubview:self.infoView];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.infoView.tableview reloadData];
     
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if (section == 1){
        return 2;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"头像";
            NSString *placeHolderHead = (_userEntity.gender == SEXMAN ? @"user_man.png" : @"user_woman.png");
            
            NSString *imageUrl = [BaseHandler retImageUrl:_userEntity.equipIcon];
            NSURL *url = [NSURL URLWithString:imageUrl];
            UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 15, 50, 50)];
            if (_headImage != nil) {
                headImageView.image = _headImage;
            }else{
                 [headImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeHolderHead]];
            }
           
            headImageView.layer.masksToBounds = YES;
            headImageView.layer.cornerRadius = 5.0f;
            [cell.contentView addSubview:headImageView];
            
            
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"昵称";
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 15, 100, 30)];
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.font = [UIFont systemFontOfSize:16.0f];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.text = _userEntity.nickName;
            [cell.contentView addSubview:nameLabel];
        }
        else if(indexPath.row == 2){
            cell.textLabel.text = @"二维码";
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2code.png"]];
            imageView.frame = CGRectMake(self.view.frame.size.width - 80, 16, 28, 28);
            [cell.contentView addSubview:imageView];
           
        }
        
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"性别";
            UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 15, 20, 30)];
            sexLabel.textAlignment = NSTextAlignmentRight;
            sexLabel.font = [UIFont systemFontOfSize:16.0f];
            sexLabel.textColor = [UIColor blackColor];
            if (_userEntity.gender == SEXMAN) {
                sexLabel.text = @"男";
            }
            else{
                sexLabel.text = @"女";
            }
            
            [cell.contentView addSubview:sexLabel];
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"备注";
            UILabel *psLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, 0, self.view.frame.size.width/2, 60)];
            psLabel.numberOfLines = 2;
            psLabel.textAlignment = NSTextAlignmentRight;
            psLabel.font = [UIFont systemFontOfSize:14.0f];
            psLabel.textColor = [UIColor blackColor];
           
            psLabel.text =  _userEntity.remark;
            [cell.contentView addSubview:psLabel];
        }
    }
    

    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80.0f;
    }
    else{
        return 60.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
           //头像
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            sheet.tag = 100;
            [sheet showInView:self.view];
        }
        else if (indexPath.row == 1){
            NSNumber *code = [NSNumber numberWithInt:ALERT_NICKNAME];
            NSDictionary *value = @{@"code":code,@"user":_userEntity};
           //昵称
            AlertInfoItemViewController *alertInfoVC = [[AlertInfoItemViewController alloc]init];
            self.valueDelegate = alertInfoVC;
            [self.valueDelegate setValue:value];
            [self.navigationController pushViewController:alertInfoVC animated:YES];
        }
        else if(indexPath.row == 2){
            ShowQRCodeViewController *showQRVC = [[ShowQRCodeViewController alloc]init];
            self.valueDelegate = showQRVC;
            [self.valueDelegate setValue:_userEntity.equipID];
            [self.navigationController pushViewController:showQRVC animated:YES];
            
        }
      
        
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //性别
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            sheet.tag = 101;
            [sheet showInView:self.view];

        }
        else if(indexPath.row == 1){
        //备注
            NSNumber *code = [NSNumber numberWithInt:ALERT_PS];
            NSDictionary *value = @{@"code":code,@"user":_userEntity};
            AlertInfoItemViewController *alertInfoVC = [[AlertInfoItemViewController alloc]init];
            self.valueDelegate = alertInfoVC;
            [self.valueDelegate setValue:value];
            [self.navigationController pushViewController:alertInfoVC animated:YES];
        }
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag == 101 && buttonIndex != 2){
        //性别修改
        _userEntity.gender = (buttonIndex == 0 ? SEXMAN : SEXWOMAN);
        [self.infoView.tableview reloadData];
        NSDictionary *params = @{@"gender":[NSNumber numberWithInt:_userEntity.gender],@"equipId":_userEntity.equipID};
        __unsafe_unretained MeInfoViewController *safeSelf = self;
        _handler = [[UserManagerHandler alloc]init];
        _handler.successBlock = ^(id obj){
            
            UserInfoStorage *stroage = [UserInfoStorage defaultStorage];
            [stroage saveUserInfo:safeSelf->_userEntity];
        };
        [_handler alertUserInfo:params];
    }
    else if(actionSheet.tag == 100 && buttonIndex != 2){
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if (buttonIndex == 0) {
            //拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        else if (buttonIndex == 1){
            //手机相册
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    }
    
}

#pragma 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSData *data;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        CaptureViewController *captureView = [[CaptureViewController alloc] init];
        captureView.delegate = self;
        captureView.image = image;
        //隐藏UIImagePickerController本身的导航栏
        picker.navigationBar.hidden = YES;
        [picker pushViewController:captureView animated:YES];
        
    }
}


#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(void)passImage:(UIImage *)image{
    
    //开始上传头像
    __unsafe_unretained MeInfoViewController *safeSelf = self;
    
    _handler = [[UserManagerHandler alloc]init];
    _handler.successBlock=^(id obj){
        safeSelf->_headImage = [obj objectForKey:@"image"];
        safeSelf->_userEntity.equipIcon = [obj objectForKey:@"equipIcon"];
        [safeSelf.infoView.tableview reloadData];
    };
    
    
    [_handler uploadHeadImage:image];
}

- (void)setValue:(NSObject *)value{
    _userEntity = (UserEntity *)value;
}
@end
