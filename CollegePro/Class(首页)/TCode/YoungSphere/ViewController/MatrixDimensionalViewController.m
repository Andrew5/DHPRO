//
//  MatrixDimensionalViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/9/2.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "MatrixDimensionalViewController.h"
//三维球相册
#import "YoungSphere.h"

#import "ChildGestureRecognizer.h"
#import "ChildLongPress.h"
//三维球相册
@interface MatrixDimensionalViewController ()
@property (nonatomic, strong) YoungSphere *sphereView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *titleName; // 标题

@property(nonatomic, strong) NSData *fileData;

@property (nonatomic, strong) NSUserDefaults * userDefault; // 本地保存信息

// 图片位置
@property(nonatomic, assign) NSInteger newflag;
@end

@implementation MatrixDimensionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     <p align="center">
     <img src="https://github.com/silencesmile/3DPhotos/blob/master/11359.gif" alt="Screenshot"/>
     </p>
     */
    // 调用展示
    self.sphereView = [[YoungSphere alloc] initWithFrame:CGRectMake(20, 200, 340, 320)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 30; i ++) {
        self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btn setBackgroundImage:[UIImage imageNamed:@"dog"] forState:(UIControlStateNormal)];
        _btn.frame = CGRectMake(0, 0, 60, 60);
        [_btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:_btn];
        [_sphereView addSubview:_btn];
        
        _btn.tag = 100 + i;
        // 长按
        ChildLongPress * longPressGr = [[ChildLongPress alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.flag = _btn.tag;
        longPressGr.minimumPressDuration = 1.0;
        [_btn addGestureRecognizer:longPressGr];
        
    }
    [_sphereView setCloudTags:array];
    _sphereView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_sphereView];
    
    self.userDefault= [NSUserDefaults standardUserDefaults];
    
    
    NSString *firstName = [_userDefault objectForKey:@"firstName"];
    
    // 影集标题
    self.titleName = [[UILabel alloc]initWithFrame:(CGRectMake(0, 80, self.view.frame.size.width, 30))];
    _titleName.userInteractionEnabled = TRUE;
    _titleName.font = [UIFont boldSystemFontOfSize:21];
    _titleName.textColor = [UIColor redColor];
    _titleName.textAlignment = 1;
    [self.view addSubview:_titleName];
    
    if (firstName.length > 0) {
        _titleName.text = firstName;
    }
    else
    {
        _titleName.text = @"我的影集";
    }
    
    
    // 影集重命名
    ChildGestureRecognizer *recommendProTap = [[ChildGestureRecognizer alloc]initWithTarget:self action:@selector(resetTitle:)];
    recommendProTap.numberOfTapsRequired = 1;
    recommendProTap.numberOfTouchesRequired = 1;
    [_titleName addGestureRecognizer:recommendProTap];
    
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 40))];
    label.text = @"点击标题更改标题，长按图片更换照片";
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    
    // 获取Documents的缓存
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *imageArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
    NSLog(@"dic:%@",imageArray);
    
    for (NSString *imageName in imageArray) {
        NSLog(@"imageName:%@",imageName);
        NSArray *array = [imageName componentsSeparatedByString:@"."]; //从字符.中分隔成2个元素的数组
        NSLog(@"array:%@",array[0]); //取得名字，去掉后缀
        
//        UIImage *selfPhoto = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",docPath, imageName]];//读取图片文件
        // 图片所在展示框的位置
//        NSInteger newNum = [array[0] integerValue];
//        UIButton *tf1 = (UIButton *)[self.view viewWithTag: newNum];
//        [tf1 setBackgroundImage:selfPhoto forState:(UIControlStateNormal)];
        
    }
}
// 影集重命名
- (void)resetTitle:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"影集重命名");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题重命名" message:@"快给我起个响亮的名字吧" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
        _titleName.text = [weakAlert.textFields.firstObject text];
        
        
        [_userDefault setObject:_titleName.text forKey:@"firstName"];
    
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    
    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.textColor = [UIColor redColor];
        textField.placeholder =  @"快给我起个响亮的名字";
        
        // 处理方法
        //        [textField addTarget:self action:@selector(usernameDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        // 可发通知
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)usernameDidChange:(UITextField *)username
{
    NSLog(@"%@", username.text);
}


-(void)longPressToDo:(ChildLongPress  *)longPress
{
    [_sphereView timerStop];
    
    self.newflag = longPress.flag;
    
    [self openCamera:longPress.flag];
    
}

/// 打开相机
- (void)openCamera:(NSInteger )flag
{
    [self openImagePickerControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

- (void)openImagePickerControllerWithType:(UIImagePickerControllerSourceType)type
{
    // 设备不可用  直接返回
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = type;
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
// 选择照片之后
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    ChaosLog(@"%@",info);
    // 获取用户选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 退出imagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 保存图片
    [self saveImage:image];
    
    
    
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageTag = [NSString stringWithFormat:@"%ld.jpg", (long)_newflag ];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:imageTag];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    
    CGFloat fixelW = CGImageGetWidth(image.CGImage);
    CGFloat fixelH = CGImageGetHeight(image.CGImage);
    
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(fixelW, fixelH)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    // 选中图片展示
    UIButton *tf1 = (UIButton *)[self.view viewWithTag:_newflag];
    [tf1 setBackgroundImage:selfPhoto forState:(UIControlStateNormal)];
    
    
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


// 点击后的效果图
- (void)buttonPressed:(UIButton *)btn
{
    
    CGFloat fixelW = 0.0 ;
    CGFloat fixelH = 0.0 ;
    CGFloat scale = 0.0;
    
    NSString *imageTag = [NSString stringWithFormat:@"%ld.jpg", (long)btn.tag];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",docPath, imageTag]];//读取图片文件
    
    
    if (selfPhoto != nil) {
        fixelW = CGImageGetWidth(selfPhoto.CGImage);
        fixelH = CGImageGetHeight(selfPhoto.CGImage);
        scale = fixelH / fixelW;
    }
    else
    {
        scale = 1.0;
    }
    
    
    [_sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(5, 5*scale);
    } completion:^(BOOL finished) {
        // 放大后显示时长
        [UIView animateWithDuration:3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [_sphereView timerStart];
        }];
    }];
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
