//
//  WtDynamicPhotoViewController.m
//  DynamicPhoto
//
//  Created by imac on 14-7-27.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "WtDynamicPhotoViewController.h"
#import "WtDynamicPhotoCell.h"

NSInteger const Photo = 8;

@interface WtDynamicPhotoViewController ()
{
    BOOL isFullScreen;

}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger deleteIndex;
@property (assign, nonatomic) BOOL wobble;
@end

@implementation WtDynamicPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photos = [[NSMutableArray alloc ] init];
    
    self.dataArray = [[NSMutableArray alloc ] init];
    [self.dataArray addObject:[UIImage imageNamed:@"plus"]];
    isFullScreen=NO;
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WtDynamicPhotoCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"WtDynamicPhotoCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    // 删除按钮
    cell.closeBtn.tag = indexPath.row;
    [cell.closeBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoImageView.image = self.dataArray[indexPath.row];
    
    if (indexPath.row == self.dataArray.count -1) {
        cell.ddBtn.hidden = NO;
    }else
    {
        cell.ddBtn.hidden = YES;
    }
    
    [cell.ddBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    // 长按删除
   
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(longPressedAction)];
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}


// 删除方法
-(void)deletePhoto:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"您确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.deleteIndex = sender.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.dataArray removeObjectAtIndex:self.deleteIndex];
        NSIndexPath *path =  [NSIndexPath indexPathForRow:self.deleteIndex inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[path]];
        
        // 如果删除完，则取消编辑
        if (self.dataArray.count == 1) {
            [self cancelWobble];
            
        }
        // 没有删除完，执行晃动动画
        else
        {
            [self longPressedAction];
        }
    }
}

// 添加图片
-(void)addPhoto
{
    // 如果是编辑状态则取消编辑状态
    if (self.wobble) {
        [self cancelWobble];
    }
    // 不是编辑状态，添加图片
    else
    {
        
        if (self.dataArray.count > Photo) {
            UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"最多支持8个" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
         
            [alert show];
        }else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:(id)self
                                          cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:@"拍照", @"我的相册",nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
        }
    }
}


// 取消晃动
-(void)cancelWobble
{
    self.wobble = NO;
    NSArray *array =  [self.collectionView subviews];
    
    for (int i = 0; i < array.count; i ++) {
        
        
        if ([array[i] isKindOfClass:[WtDynamicPhotoCell class]]) {
            WtDynamicPhotoCell *cell = array[i];
            cell.closeBtn.hidden =  YES;
            if (cell.tag == 999999) {
                cell.photoImageView.image = [UIImage imageNamed:@"plus"];
            }
            
            // 晃动动画
            [self animationViewCell:cell];
        }
    }
}

// 长按
-(void)longPressedAction
{
   self.wobble = YES;
   NSArray *array =  [self.collectionView subviews];

    for (int i = 0; i < array.count; i ++) {
        
        if ([array[i] isKindOfClass:[WtDynamicPhotoCell class]]) {
            WtDynamicPhotoCell *cell = array[i];
            
            if (cell.ddBtn.hidden) {
                cell.closeBtn.hidden = NO;
            }
            else
            {
                cell.closeBtn.hidden = YES;
                cell.photoImageView.image = [UIImage imageNamed:@"ensure"];
                cell.tag = 999999;
            }
                
            // 晃动动画
            [self animationViewCell:cell];
        }
    }
}

// 晃动动画
-(void)animationViewCell:(WtDynamicPhotoCell *)cell
{
    //摇摆
    if (self.wobble){
        cell.transform = CGAffineTransformMakeRotation(-0.1);
        
        [UIView animateWithDuration:0.08
                              delay:0.0
                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear
                         animations:^{
                             cell.transform = CGAffineTransformMakeRotation(0.1);
                         } completion:nil];
    }
    else{
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.transform = CGAffineTransformIdentity;
                         } completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openCamera];
    }else if(buttonIndex == 1) {
        [self openPics];
    }
}

// 打开相机
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (_imagePicker == nil) {
            _imagePicker =  [[UIImagePickerController alloc] init];
        }
        _imagePicker.delegate = (id)self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.showsCameraControls = YES;
        _imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:_imagePicker animated:YES completion:nil];
    }
}

// 打开相册
- (void)openPics {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = (id)self;
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}

// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
    _imagePicker = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *theImage = nil;
      
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
            
        }
        [self.dataArray insertObject:theImage atIndex:0];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[path]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    isFullScreen = !isFullScreen;
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    //touchPoint.x ，touchPoint.y 就是触点的坐标
//    double w=(self.view.frame.size.width-5*5)/4;
//    NSInteger imageTag=touchPoint.x/w+120;
//     触点在imageView内，点击imageView时 放大,再次点击时缩小        // 设置图片放大动画
    [UIView beginAnimations:nil context:nil];
    // 动画时间
    [UIView setAnimationDuration:1];
    
    if (isFullScreen) {
        // 放大尺寸
//        UIImageView * selectImageView=(UIImageView *)[self.view viewWithTag:imageTag];
        //                int x=[[[NSUserDefaults standardUserDefaults]objectForKey:@"imageIndexX"]intValue];
//        selectImageView.frame = CGRectMake(0,40,self.view.frame.size.width,self.view.frame.size.height-40);
//        [self.view bringSubviewToFront:selectImageView];
        
    }
    else {
        // 缩小尺寸
//        UIImageView * selectImageView=(UIImageView *)[self.view viewWithTag:imageTag];
//        NSInteger touchPointTag=touchPoint.x/w;
//        selectImageView.frame = CGRectMake(touchPointTag*(w+5),30,80, 60);
        
    }
    // commit动画
    [UIView commitAnimations];
    
}


@end
