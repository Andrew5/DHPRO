//
//  UserEditViewController.m
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserEditViewController.h"
#import "Cart.h"
@interface UserEditViewController ()

@end

@implementation UserEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.user=[[App shared] currentUser];

    self.backend=[UserBackend shared];
    self.title=@"我的资料";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    
    UIBarButtonItem *rbtn =[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveEdit)];
    rbtn.tintColor=TEXT_COLOR_BLACK;
    self.navigationItem.rightBarButtonItem=rbtn;
    
    self.tableView.backgroundColor=WHITE_COLOR;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0.0, 0.0);
    self.btnLoginOut.backgroundColor=MAIN_COLOR2;
    self.btnLoginOut.layer.cornerRadius=5;

}
-(void)showdatePickView
{
    if (!toolBar) {
        toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-200, screenSize.width, 300)];
        [toolBar sizeToFit];
        toolBar.backgroundColor=[UIColor colorWithWhite:0.906 alpha:1.000];
        
        
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;//这句作用是切换时宽度自适应.
        
        
        UIBarButtonItem * item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(datepickerViewCancelBtnTaped)];
        item0.tintColor = MAIN_COLOR;
        
        UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(datepickerViewOkBtnTaped)];
        item2.tintColor = MAIN_COLOR;
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        [toolBar setItems:[NSArray arrayWithObjects:item0, spaceItem, spaceItem, item2, nil] animated:YES];
        
        //[self.view addSubview:toolBar];
        
        
        oneDatePicker = [[UIDatePicker alloc] init];
        oneDatePicker.frame = CGRectMake(0, self.view.frame.size.height-160, screenSize.width, 300); // 设置显示的位置和大小
        oneDatePicker.backgroundColor=[UIColor whiteColor];
        
        oneDatePicker.date = [NSDate date]; // 设置初始时间
        // [oneDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES]; // 设置时间，有动画效果
        oneDatePicker.timeZone = [NSTimeZone systemTimeZone]; // 设置时区，中国在东八区
        //    oneDatePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1]; // 设置最小时间
        //    oneDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60]; // 设置最大时间
        
        
        oneDatePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
    }
    [self.view addSubview:toolBar];
    [self.view addSubview:oneDatePicker];
    
    self.tableViewHeight.constant=400;
}
-(void)hidedatePickView
{
    [toolBar removeFromSuperview];
    [oneDatePicker removeFromSuperview];
}
-(void)saveEdit
{
    self.user.card_id=self.tfSFZ.text;
    self.user.email=self.tfEmail.text;
    self.user.name=self.tfName.text;
    self.user.birthday=self.tfBirthday.text;
    self.user.sex=[NSString stringWithFormat:@"%ld",(long)segmentedControl.selectedSegmentIndex];
    self.user.intro=self.tfDesc.text;
    [[self.backend requestSaveUser:self.user] subscribeNext:[self didUpdate:@"保存成功" withTableView:self.tableView]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateSuyccessful" object:self.user];

    NSLog(@"%@--头像，，%@--名字",self.user.avatarimg,self.user.name);
    [self.backend clearStore];
    [self.backend.repository storage:self.user];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return CGFLOAT_MIN;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row==0) {
    //        return 100;
    //    }
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *_cell=[[UITableViewCell alloc] init];
    
 
    if (indexPath.row==0) {
        
        UILabel *lb=[UILabel new];
        lb.text=@"头像:";
        [_cell addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cell).offset(20);
            make.centerY.equalTo(_cell);
        }];
        
        userImage=[UIImageView new];
        userImage.layer.cornerRadius=20;
        userImage.layer.masksToBounds=YES;
        [userImage sd_setImageWithURL:url(self.user.avatarimg) placeholderImage:img_placehold];

        [_cell addSubview:userImage];
        [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb.mas_right).offset(40);
            make.centerY.equalTo(lb);
            make.height.equalTo(@40);
            make.width.equalTo(@40);
//      make.right.equalTo(_cell);
        }];
        [self addListener:userImage action:@selector(avatarTapped)];
        
    }

    if (indexPath.row==1) {
        
        UILabel *lb=[UILabel new];
        lb.text=@"昵称:";
        [_cell addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cell).offset(20);
            make.centerY.equalTo(_cell);
        }];
        
        self.tfName=[UITextField new];
        self.tfName.placeholder=@"请输入昵称";
        self.tfName.text=self.user.name;
        self.tfName.delegate=self;
        [_cell addSubview:self.tfName];
        [self.tfName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb.mas_right).offset(40);
            make.centerY.equalTo(lb);
            make.height.equalTo(_cell);
//            make.right.equalTo(_cell);
        }];
        
    }
    else if(indexPath.row==2)
    {
   
        UILabel *lb=[UILabel new];
        lb.text=@"手机号:";
        [_cell addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cell).offset(20);
            make.centerY.equalTo(_cell);
        }];
        App *app = [App shared];
        UILabel *lbzh=[UILabel new];
//        lbzh.text=[self.user.rank_level stringValue];
        lbzh.text=[app.currentUser.tele description];
        
        [_cell addSubview:lbzh];
        [lbzh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb.mas_right).offset(40);
            make.centerY.equalTo(lb);
            make.height.equalTo(_cell);
            //            make.right.equalTo(_cell);
        }];
        
    }
    else if(indexPath.row==3)
    {
        UILabel *lb=[UILabel new];
        lb.text=@"性别:";
        [_cell addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cell).offset(20);
            make.centerY.equalTo(_cell);
        }];
        
        segmentedControl=[UISegmentedControl new];
        
        [segmentedControl insertSegmentWithTitle:@"女" atIndex:0 animated:YES];
        [segmentedControl insertSegmentWithTitle:@"男" atIndex:1 animated:YES];
        [segmentedControl setTintColor:MAIN_COLOR];
        segmentedControl.selectedSegmentIndex =[[[NSDecimalNumber alloc] initWithString: self.user.sex] integerValue];//设置默认选择项索
        [_cell addSubview:segmentedControl];
        [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb.mas_right).offset(40);
            make.centerY.equalTo(lb);
            make.height.equalTo(@25);
            make.width.equalTo(@80);
            //            make.right.equalTo(_cell);
        }];
    }

    else if(indexPath.row==4)
    {
        UILabel *lb=[UILabel new];
        lb.text=@"地区:";
        [_cell addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cell).offset(20);
            make.centerY.equalTo(_cell);
        }];
        self.lbArea=[UILabel new];
        
        if (self.user.provence) {
            self.lbArea.text=[NSString stringWithFormat:@"%@ %@ %@", self.user.provence, self.user.city, self.user.area];
        }
        [_cell addSubview:self.lbArea];
        
        [self.lbArea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lb.mas_right).offset(40);
            make.centerY.equalTo(lb);
            make.height.equalTo(_cell);
        }];
    }
    _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return _cell;
}
-(void)getCardFr
{
//    iscardbg=NO;
//    if ([self.user authorized]) {
//        [XZActionView showSheetWithTitle:NSLocalizedString(@"picgettitle", @"")
//                              itemTitles:@[NSLocalizedString(@"picget1", @""), NSLocalizedString(@"picget2", @"")]
//         //itemSubTitles:@[ @"Depapepe - Let's go!!!", @"Jason Mraz", @"Bruno Mars" ]
//                           selectedIndex:nil
//                          selectedHandle:^(NSInteger index){
//                              [self clickedButton:index];
//                          }
//         ];
//        
//    }
//    else
//    {
//        UserAuthenticationViewController *controller;
//        controller = [[UserAuthenticationViewController alloc] init];
//        
//        [self showNavigationView:controller];
//        
//    }
    
}

-(void)getCardBg
{
//    iscardbg=YES;
//    if ([self.user authorized]) {
//        [XZActionView showSheetWithTitle:NSLocalizedString(@"picgettitle", @"")
//                              itemTitles:@[NSLocalizedString(@"picget1", @""), NSLocalizedString(@"picget2", @"")]
//         //itemSubTitles:@[ @"Depapepe - Let's go!!!", @"Jason Mraz", @"Bruno Mars" ]
//                           selectedIndex:nil
//                          selectedHandle:^(NSInteger index){
//                              [self clickedButton:index];
//                          }
//         ];
//        
//    }
//    else
//    {
//        UserAuthenticationViewController *controller;
//        controller = [[UserAuthenticationViewController alloc] init];
//        
//        [self showNavigationView:controller];
//        
//    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=1) {
        [self.tfName resignFirstResponder];

    }
    if(indexPath.row==4)
    {

        locatePicker = [[TAreaPickerView alloc] initWithStyle:TAreaPickerWithStateAndCityAndDistrict frame:self.view.frame delegate:self];
        [locatePicker showInView:self.view];
    }
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.tfBirthday) {
        [self showdatePickView];
        return NO;
        
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    [self.]
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//  
//    return YES;
//}
#pragma mark - HZAreaPicker delegate

-(void)pickerDidTapedOKBtn:(TAreaPickerView *)picker
{
    self.user.provence=picker.locate.state;
    self.user.city=picker.locate.city;
    self.user.area=picker.locate.district;
    self.lbArea.text=[NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
    [picker cancelPicker];
}

-(void)cancelLocatePicker
{
    [locatePicker cancelPicker];
    locatePicker.delegate = nil;
    locatePicker = nil;
}


#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
//    NSDate *select = [sender date]; // 获取被选中的时间
//    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
//    selectDateFormatter.dateFormat = @"yy:MM:dd HH:mm:ss"; // 设置时间和日期的格式
//    NSString *dateAndTime;
//    dateAndTime= [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
//    
//    //    // 通过UIAlertView显示出来
//    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"时间提示" message:dateAndTime delegate:select cancelButtonTitle:@"Cancle" otherButtonTitles:nil, nil];
//    //    [alertView show];
//    
//    // 在控制台打印消息
//    NSLog(@"%@", [sender date]);
}

-(void)clickedButton:(NSInteger)AtIndex{
    if (AtIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self.navigationController presentViewController:controller
                                                    animated:YES
                                                  completion:^(void){
                                                      NSLog(@"Picker View Controller is presented");
                                                  }];
        }
        
    } else if (AtIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self.navigationController presentViewController:controller
                                                    animated:YES
                                                  completion:^(void){
                                                      NSLog(@"Picker View Controller is presented");
                                                  }];
        }
    }
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
#define ORIGINAL_MAX_WIDTH 640.0f
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)datepickerViewCancelBtnTaped
{
    [self hidedatePickView];
}
-(void)datepickerViewOkBtnTaped
{
    NSDate *select = [oneDatePicker date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
    NSString *date = [selectDateFormatter stringFromDate:select];
    
    self.tfBirthday.text=date;
    
    [self hidedatePickView];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        CGFloat width=super.view.frame.size.width;
        CGFloat height=super.view.frame.size.height;
        CGFloat top=(height-200.0f)/2.0f;
        CGFloat left=(width-200.0f)/2.0f;
        // 裁剪
        XZImageCropperViewController *imgEditorVC = [[XZImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(left, top, 200.0f, 200.0f) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self.navigationController presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];

    }];
}
- (void(^)(RACTuple *))didUpLoad
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            
//            //[mheadercell.portraitImageView sd_setImageWithURL:[NSURL URLWithString:self.user.avatarimg]];
//            if (iscardbg) {
//                self.user.card_bg=rs.strdata;
//                [imgviewSFZBM sd_setImageWithURL:url(self.user.card_bg) placeholderImage:img_placehold];
//            }
//            else
//            {
//                self.user.card_fr=rs.strdata;
//                [imgviewSFZZM sd_setImageWithURL:url(self.user.card_fr) placeholderImage:img_placehold];
//            }
//            [[UserRepository shared] clearStore];
//            [[UserRepository shared] storage:self.user];
//            [[App shared] setCurrentUser:self.user];
//            [self.view showHUD:@"上传成功" afterDelay:2];
        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        
    };
}
//手动实现图片压缩，可以写到分类里，封装成常用方法。按照大小进行比例压缩，改变了图片的size。
- (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale {
    UIImage *thumbnail = nil;
    //CGSize imageSize = CGSizeMake(srcImage.size.width * imageScale, srcImage.size.height * imageScale);
    CGSize imageSize=CGSizeMake(100, 100);
    if (srcImage.size.width != imageSize.width || srcImage.size.height != imageSize.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [srcImage drawInRect:imageRect];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        thumbnail = srcImage;
    }
    return thumbnail;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark XZImageCropperDelegate
- (void)imageCropper:(XZImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    NSData *data=UIImageJPEGRepresentation(editedImage, 0.5);
    
    while ([data length]/1024>300) {
        data=UIImageJPEGRepresentation(editedImage, 0.5);
    }
    NSString *_encodedImageStr = [data base64Encoding];
    
    self.user.avatarimg=_encodedImageStr;
    
    [[self.backend requestUpdateUserAvatar:self.user] subscribeNext:[self didUpdate]];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}
- (void(^)(RACTuple *))didUpdate
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            
            [userImage sd_setImageWithURL:[NSURL URLWithString:self.user.avatarimg]];
            
            self.user.avatarimg=rs.strdata;

            [[UserRepository shared] clearUserStore];
            [[UserRepository shared] storage:self.user];
            [[App shared] setCurrentUser:self.user];
            [self.tableView reloadData];
            [[UIApplication sharedApplication].keyWindow showHUD:@"更新成功" afterDelay:2];

        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        
    };
}


- (void)imageCropperDidCancel:(XZImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)btnLoginOutTapped:(id)sender {
    [[UserBackend shared] clearStore];
    [[App shared] setCurrentUser:nil];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"attentionList"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Exit" object:self userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
-(void)avatarTapped
{
    [self.tfName  resignFirstResponder];
        [XZActionView showSheetWithTitle:NSLocalizedString(@"picgettitle", @"")
                              itemTitles:@[NSLocalizedString(@"picget1", @""), NSLocalizedString(@"picget2", @"")]
         //itemSubTitles:@[@"Depapepe - Let's go!!!", @"Jason Mraz", @"Bruno Mars" ]
                           selectedIndex:nil
                          selectedHandle:^(NSInteger index){
                              [self clickedButton:index];
                          }
         ];

}
@end
