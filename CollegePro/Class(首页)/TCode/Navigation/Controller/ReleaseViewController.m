//
//  ReleaseViewController.m
//  Announcement
//
//  Created by 邸明宇 on 16/7/15.
//  Copyright © 2016年 邸明宇. All rights reserved.
//
#define MaxCount 3
#import "ReleaseViewController.h"
//#import "receiveViewController.h"
//#import "SGImagePickerController.h"
//#import "SGAssetModel.h"
//#import "receiveViewController.h"
//#import "PrefixHeader.pch"

/**
 *  dyc
 */
#import "LxGridViewFlowLayout.h"
#import "TZImagePickerController.h"
#import "TZTestCell.h"
#import "UIView+Layout.h"
#import <StoreKit/StoreKit.h>

/**
 *  跳转页
 */
#import "EditPicturesViewController.h"

@interface ReleaseViewController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SKStoreProductViewControllerDelegate>

{
    UIView *titleView;
    UITextField *titleTextField;
    UIView *contentView;
    UITextField *contentTextField;
    UILabel *jiamiLabel;
    UIView *jiamiView;
    UISwitch *jiamiSwitch;
    
    UITextView *textVieMy;
    UILabel *bianjiLabel;
    // 添加相片
    UIButton *photoBtn;
    NSString *jiamiStr;
    NSArray *photoArray;
    
    
    /**
     *  dyc
     */
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    CGFloat _itemWH;
    CGFloat _margin;
    LxGridViewFlowLayout *_layout;
}
/**
 *  dyc
 */
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ReleaseViewController

#pragma mark - base method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1];
    
    photoArray = [NSArray array];
    
    jiamiStr = @"0";
    
    self.navigationItem.title = @"编辑公告";
    /**
     *  dyc
     */
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    [self UI];
    //    [self configCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - private method
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _layout = [[LxGridViewFlowLayout alloc] init];
        _margin = 12;
        _itemWH = (self.view.tz_width - 2 * _margin - 4) / 4 - _margin;
        _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        _layout.minimumInteritemSpacing = _margin;
        _layout.minimumLineSpacing = _margin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, 64, (self.view.tz_width-2*_margin)/4*MaxCount, _itemWH+5) collectionViewLayout:_layout];
		
		_collectionView.layer.borderColor = [UIColor redColor].CGColor;
		_collectionView.layer.borderWidth = 1.0;
        //        CGFloat rgb = 244 / 255.0;
        _collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.scrollEnabled = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
//        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    }
    
    return _collectionView;
}

- (void)UI{
    
    titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 12 + 64, self.view.frame.size.width, 48);
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    // 标题textField
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 0, self.view.frame.size.width - 24, 48)];
    titleTextField.placeholder = @"请输入公告标题(12个字符)";
    [titleTextField setDelegate:self];
    titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    titleTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    titleTextField.returnKeyType = UIReturnKeyDone;
    [titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [titleView addSubview:titleTextField];
    
    // contentView
    contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 75 + 64, self.view.frame.size.width, 215);
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    //
    //    // contentTextField
    //    contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 14, self.view.frame.size.width - 24, 315 / 2)];
    //    contentTextField.placeholder = @"编辑公告内容";
    //    [contentTextField setDelegate:self];
    //    contentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    //    contentTextField.autocapitalizationType = UITextAutocorrectionTypeNo;
    //    contentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //    contentTextField.returnKeyType = UIReturnKeyDone;
    //    [contentView addSubview:contentTextField];
    
    // textView
    textVieMy = [[UITextView alloc] initWithFrame:CGRectMake(12, 14, self.view.frame.size.width - 24, 315/ 3)];
    //    textView.text = @"编辑公告内容";
    [textVieMy setDelegate:self];
    textVieMy.font = [UIFont systemFontOfSize:14];
    textVieMy.returnKeyType = UIReturnKeyDefault;
    textVieMy.keyboardType = UIKeyboardTypeDefault;
    //    textVieMy.scrollEnabled = YES;  // 拖动
    textVieMy.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [contentView addSubview:textVieMy];
    
    //    // 照片
    //    photoBtn = [UIButton buttonWithType:0];
    //       photoBtn.frame = CGRectMake(12, 130, 73.00 / 375.00 * self.view.frame.size.width, 73.00 / 667.00 * self.view.frame.size.height);
    //    [photoBtn setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    //    [photoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [contentView addSubview:photoBtn];
    [contentView addSubview:self.collectionView];
    
    
    // 加密
    jiamiView = [[UIView alloc] init];
    jiamiView.frame = CGRectMake(0, 300 + 64, self.view.frame.size.width, 48);
    jiamiView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:jiamiView];
    
    jiamiLabel = [[UILabel alloc] init];
    jiamiLabel.frame = CGRectMake(12, 12, 100, 22);
    jiamiLabel.text = @"是否加密";
    jiamiLabel.font = [UIFont systemFontOfSize:16];
    jiamiLabel.textColor = [UIColor blackColor];
    [jiamiView addSubview:jiamiLabel];
    
    // 加密Switch
    jiamiSwitch = [[UISwitch alloc] init];
    jiamiSwitch.frame = CGRectMake(self.view.frame.size.width - 70, 11, 37, 22.4);
    jiamiSwitch.onImage = [UIImage imageNamed:@"开.png"];
    jiamiSwitch.offImage = [UIImage imageNamed:@"关闭.png"];
    [jiamiSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [jiamiView addSubview:jiamiSwitch];
    
    // 下一步
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(nextAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.3176 green:0.7843 blue:1.0000 alpha:1];
    
    // 编辑公告内容
    bianjiLabel = [[UILabel alloc] init];
    bianjiLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    bianjiLabel.textColor = [UIColor colorWithRed:0.7843 green:0.7843 blue:0.8078 alpha:1];
    bianjiLabel.text = @"编辑公告内容";
    [textVieMy addSubview:bianjiLabel];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"work_navleft_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popViewController:)];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [shareButton setFrame:CGRectMake(10.0 ,450.0 ,50.0 ,20.0)];
    shareButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];
    [shareButton setTitle:@"分享" forState:(UIControlStateNormal)];
    [shareButton addTarget:self action:@selector(shareActive) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:shareButton];
    
}
- (void)shareActive{
    NSUserDefaults *userShare= [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dhTool.selfpro.CollegeProShareExtension"];
    NSURL *url = [userShare URLForKey:@"URL"];
    NSLog(@"url==%@",url);
    bianjiLabel.text = [NSString stringWithFormat:@"%@",url];
}
#pragma mark UICollectionView delegate and dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pickPhotoButtonClick:nil];
    }else{
        EditPicturesViewController * vc = [[EditPicturesViewController alloc]init];
        vc.imageArray = _selectedPhotos;
        vc.selectedAssets = _selectedAssets;
        vc.integer = indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
//    _layout.itemCount = _selectedPhotos.count;
	
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
}

- (void)pickPhotoButtonClick:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MaxCount delegate:self];
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    //     设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
//    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}


// rightbarbuttonitem 下一步
- (void)nextAction:(UIBarButtonItem *)item{
    
//    if (titleTextField.text.length > 0 && textView.text.length > 0) {
//        receiveViewController *receiveVC = [[receiveViewController alloc] init];
//        
//        receiveVC.titleStr = titleTextField.text;
//        receiveVC.contentStr = textView.text;
//        receiveVC.jiamiNum = jiamiStr;
//        receiveVC.photoArr = _selectedPhotos;
//        
//        [self.navigationController pushViewController:receiveVC animated:YES];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"标题或内容不能为空" duration:1.5];
//    }
    
    
}

- (void)switchAction:(UISwitch *)btn{
    if (btn.on == YES) {
        jiamiStr = @"1";
		[self openAppStore:@"1149644212"];
        
    } if (btn.on == NO) {
        
        jiamiStr = @"0";
        
    }
}
//实现openAppStore函数
- (void)openAppStore:(NSString *)appId
{
	SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
	// Configure View Controller
	[storeProductViewController setDelegate:self];
	[storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : appId}
										  completionBlock:^(BOOL result, NSError *error) {
											  if (error) {
              NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
											  } else {
												  // Present Store Product View Controller
												  [self presentViewController:storeProductViewController animated:YES completion:nil];
											  }
										  }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    //在代理方法里dismiss这个VC
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

// leftbarbuttonitem返回
-(void)popViewController:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//textfield 点击事件
//过滤非汉字、字母、数字字符
//长度限制，对超出部分进行截取
- (void)textFieldDidChange:(UITextField *)textField{
	UITextRange *selectedRange = textField.markedTextRange;
	UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
	if (!position) {
		// 没有高亮选择的字
		// 1. 过滤非汉字、字母、数字字符
		titleTextField.text = [self filterCharactor:textField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
		// 2. 截取
		if (titleTextField.text.length >= 12) {
			titleTextField.text = [titleTextField.text substringToIndex:12];
		}
	} else {
		// 有高亮选择的字 不做任何操作
	}

	
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
    
    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length) withTemplate:@""];
    
    
    
    if (![noEmojiStr isEqualToString:textField.text]) {
        
        textField.text = noEmojiStr;
        
    }
    
}


// 过滤字符串中的非汉字、字母、数字
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
	NSString *filterText = string;
	NSError *error = NULL;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
	NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
	return result;
}


#pragma mark TZImagePickerControllerDelegate

/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
	
}

/// User finish picking photo，if assets are not empty, user picking original photo.

#pragma mark - TextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 20) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[titleTextField resignFirstResponder];
	[self.view endEditing:YES];
	if (textField.text.length < 2) {
		// 提示用户，名称长度至少为2位
		[SVProgressHUD showErrorWithStatus:@"名称长度至少为2位"];
		return NO;
	}
	// 设置用户名
	return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	
	[titleTextField resignFirstResponder];
	
}

#pragma mark - TextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView1{
    
    [bianjiLabel removeFromSuperview];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	[textView resignFirstResponder];
	[self.view endEditing:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	[textVieMy resignFirstResponder];
	[titleTextField resignFirstResponder];

}

//- (void)textViewDidChange:(UITextView *)textView{
//    NSRange textRange = [textView selectedRange];
//    //    [textView setText:[self disable_emoji:[textView text]]];
//    [textView setSelectedRange:textRange];
//}


//// 相册按钮
//- (void)photoBtnAction:(UIButton *)btn
//{
//
//    SGImagePickerController *picker = [[SGImagePickerController alloc] initWithRootViewController:nil];
//    //返回选择的缩略图
//    [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
//        NSLog(@"缩略图%@",thumbnails);
//    }];
//
//    //返回选中的原图
//    [picker setDidFinishSelectImages:^(NSArray *images) {
//        NSLog(@"原图确定%@",images);
//        NSLog(@"选择图个数:%ld",images.count);
//        photoArray = images;
//
//
//        if (images.count <= 2) {
//
//            for (int a = 0; a < images.count; a++) {
//
//                UIImageView *imageView = [[UIImageView alloc] init];
//                imageView.frame = CGRectMake(((100.00 + a * 83.00) / 375.00 * self.view.frame.size.width), 130, 73.00 / 375.00 * self.view.frame.size.width, 73.00 / 667.00 * self.view.frame.size.height);
//                imageView.image = [images objectAtIndex:a];
//                imageView.contentMode = UIViewContentModeScaleAspectFit;
//                [contentView addSubview:imageView];
//                photoBtn.frame = CGRectMake(12, 130, 73.00 / 375.00 * self.view.frame.size.width, 73.00 / 667.00 * self.view.frame.size.height);
////             photoBtn.frame = CGRectMake(12 + (a + 1) * 83, 130, 73, 73);
//
//            }
//
//        } else {
//
//            for (int a = 0; a < 3; a++) {
//
//                UIImageView *imageView = [[UIImageView alloc] init];
//                imageView.frame = CGRectMake(((100.00 + a * 83.00) / 375.00 * self.view.frame.size.width), 130, 73.00 / 375.00 * self.view.frame.size.width, 73.00 / 667.00 * self.view.frame.size.height);
//                imageView.image = [images objectAtIndex:a];
//                imageView.contentMode = UIViewContentModeScaleAspectFit;
//                [contentView addSubview:imageView];
//                photoBtn.frame = CGRectMake(12, 130, 73.00 / 375.00 * self.view.frame.size.width, 73.00 / 667.00 * self.view.frame.size.height);
//
////              photoBtn.frame = CGRectMake(12 + (a + 1) * 83, 130, 73, 73);
//            }
//
//        }
//
//    }];
//    [self presentViewController:picker animated:YES completion:nil];
//
//}





//禁止输入表情
//- (NSString *)disable_emoji:(NSString *)text
//{
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
//                                                               options:0
//                                                                 range:NSMakeRange(0, [text length])
//                                                          withTemplate:@""];
//    return modifiedString;
//}






@end
