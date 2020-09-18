//
//  ZCAssetCollectionViewCell.m
//  ZCAssetsPickController

#import "ZCAssetCollectionViewCell.h"

@interface ZCAssetCollectionViewCell ()

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) PHCachingImageManager *imageManager;

@property (nonatomic,strong) UIImageView *typeImageV;

@end

@implementation ZCAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectedBtn];
        [self.contentView addSubview:self.typeImageV];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = self.contentView.bounds;
    self.selectedBtn.frame = CGRectMake(self.frame.size.width-40, 0, 40, 40);
    self.typeImageV.frame = CGRectMake(10, self.frame.size.height-20, 15, 8);
}

#pragma mark - setter & getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_unselected"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_selected"] forState:UIControlStateSelected];
        [_selectedBtn addTarget:self action:@selector(selectedClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}

- (void)setImageSelected:(BOOL)selected
{
    if (selected) {
        self.model.isSelected = YES;
        [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_selected"] forState:UIControlStateNormal];
    }else{
        self.model.isSelected = NO;
        [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_unselected"] forState:UIControlStateNormal];
    }
    
}

- (UIImageView *)typeImageV
{
    if (!_typeImageV) {
        _typeImageV = [[UIImageView alloc] init];
        _typeImageV.image = [UIImage imageNamed:@"ic_assets_video"];
    }
    return _typeImageV;
}

- (void)setAsset:(PHAsset *)asset
{
    if (!asset)
    {
        return;
    }
    _asset = asset;
    
    self.typeImageV.hidden = (_asset.mediaType == PHAssetMediaTypeImage);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    __weak typeof(self) weakSelf = self;
    [self.imageManager requestImageForAsset:_asset
                                 targetSize:KAssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  weakSelf.imageView.image = result;
                              }];
    
   
//    [self.imageManager requestAVAssetForVideo:_asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info)
//     {
//         NSURL *URL = [(AVURLAsset *)asset URL];
//         NSNumber *fileSizeValue = nil;
//         [URL getResourceValue:&fileSizeValue forKey:NSURLFileSizeKey error:nil];
//         //or
//
//         NSString *videoName = [_asset valueForKey:@"filename"];
//
//         NSLog(@"%@",videoName);
//
//         
//         NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
//
//         NSLog(@"%ld",data.length);
//
//         NSLog(@"%lld",[self fileSizeAtPath:URL.path]);
//
//         float M =  [self fileSizeAtPath:URL.path]/1024.0/1024.0;
//         if (M<1) {
//             M =  [self fileSizeAtPath:URL.path]/1024.0;
//             NSLog(@"%.3fK",M);
//             return;
//         }
//
//         NSLog(@"%.3fM",M);
//     }];
    
}

//获取文件大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - event
//点击事件
- (void)selectedClicked:(UIButton *)sender
{
    if (self.selectedBlock)
    {
        self.selectedBlock(self.asset,self.indexPath);
    }
}

@end
