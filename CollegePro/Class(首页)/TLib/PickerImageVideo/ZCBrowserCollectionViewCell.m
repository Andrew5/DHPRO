//
//  ZCBrowserCollectionViewCell.m
//  ZCAssetsPickerController

#import "ZCBrowserCollectionViewCell.h"

@interface ZCBrowserCollectionViewCell ()

@property (nonatomic,strong) UIImageView *originalImageV;

@property (nonatomic,strong) PHCachingImageManager *imageManager;

@end

@implementation ZCBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self.contentView addSubview:self.originalImageV];
    }
    return self;
}


#pragma mark - setter & getter

- (UIImageView *)originalImageV
{
    if (!_originalImageV) {
        _originalImageV = [[UIImageView alloc] init];
        _originalImageV.contentMode = UIViewContentModeScaleAspectFill;
        _originalImageV.frame = self.contentView.bounds;
    }
    return _originalImageV;
}

- (void)setAsset:(PHAsset *)asset
{
    if (!asset)
    {
        return;
    }
    _asset = asset;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    __weak typeof(self) weakSelf = self;
    [self.imageManager requestImageForAsset:_asset
                                 targetSize:CGSizeMake([UIScreen mainScreen].scale*KItemW, [UIScreen mainScreen].scale*KItemH)
                                contentMode:PHImageContentModeAspectFit
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info)
    {
                                  if (result)
                                  {
                                      weakSelf.originalImageV.image = result;
                                      weakSelf.originalImageV.frame = [weakSelf imageViewRectWithImageSize:result.size];
                                  }

                              }];
}

- (CGRect)imageViewRectWithImageSize:(CGSize)imageSize
{
    CGFloat heightRatio = imageSize.height / KItemH;
    CGFloat widthRatio = imageSize.width / KItemW;
    
    CGSize size = CGSizeZero;
    if (heightRatio > 1 && widthRatio <= 1) {
        size = [self ratioSize:imageSize ratio:heightRatio];
    }
    if (heightRatio <= 1 && widthRatio > 1) {
        size = [self ratioSize:imageSize ratio:widthRatio];
    }else{
        size = [self ratioSize:imageSize ratio:MAX(heightRatio, widthRatio)];
    }
    CGFloat x = (KItemW - size.width) / 2;
    CGFloat y = (KItemH - size.height) / 2;
    return CGRectMake(x, y, size.width, size.height);
}

- (CGSize)ratioSize:(CGSize)originSize ratio:(CGFloat)ratio
{
    return CGSizeMake(originSize.width / ratio, originSize.height / ratio);
}


@end
