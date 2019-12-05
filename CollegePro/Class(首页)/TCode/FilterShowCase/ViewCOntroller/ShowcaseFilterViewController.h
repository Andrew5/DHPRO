#import <UIKit/UIKit.h>
#import "GPUImage.h"

typedef enum {
    GPUIMAGE_SATURATION,
    GPUIMAGE_CONTRAST,
    GPUIMAGE_BRIGHTNESS,
    GPUIMAGE_EXPOSURE,
    GPUIMAGE_RGB_GREEN,
    GPUIMAGE_RGB_BLUE,
    GPUIMAGE_RGB_RED,
    GPUIMAGE_VIGNETTE,
    GPUIMAGE_HUE,
    GPUIMAGE_MONOCHROME,
    GPUIMAGE_FALSECOLOR,
    GPUIMAGE_SHARPEN,
//    GPUIMAGE_UNSHARPMASK,
//    GPUIMAGE_TRANSFORM,
//    GPUIMAGE_TRANSFORM3D,
//    GPUIMAGE_CROP,
//	GPUIMAGE_MASK,
    GPUIMAGE_GAMMA,
    GPUIMAGE_TONECURVE,
//    GPUIMAGE_HIGHLIGHTSHADOW,
    GPUIMAGE_HAZE,
    GPUIMAGE_SEPIA,
    GPUIMAGE_AMATORKA,
    GPUIMAGE_MISSETIKATE,
    GPUIMAGE_SOFTELEGANCE,
    GPUIMAGE_COLORINVERT,
    GPUIMAGE_GRAYSCALE,
//    GPUIMAGE_HISTOGRAM,
//    GPUIMAGE_AVERAGECOLOR,
//    GPUIMAGE_LUMINOSITY,
    GPUIMAGE_THRESHOLD,
//    GPUIMAGE_ADAPTIVETHRESHOLD,
//    GPUIMAGE_AVERAGELUMINANCETHRESHOLD,
//    GPUIMAGE_PIXELLATE,
//    GPUIMAGE_POLARPIXELLATE,
//    GPUIMAGE_POLKADOT,
//    GPUIMAGE_CROSSHATCH,
//    GPUIMAGE_SOBELEDGEDETECTION,
//    GPUIMAGE_PREWITTEDGEDETECTION,
//    GPUIMAGE_CANNYEDGEDETECTION,
//    GPUIMAGE_XYGRADIENT,
//    GPUIMAGE_HARRISCORNERDETECTION,
//    GPUIMAGE_NOBLECORNERDETECTION,
//    GPUIMAGE_SHITOMASIFEATUREDETECTION,
//    GPUIMAGE_BUFFER,
    GPUIMAGE_SKETCH,
    GPUIMAGE_TOON,
    GPUIMAGE_SMOOTHTOON,
//    GPUIMAGE_TILTSHIFT,
//    GPUIMAGE_CGA,
    GPUIMAGE_POSTERIZE,
//    GPUIMAGE_CONVOLUTION,
    GPUIMAGE_EMBOSS,
//    GPUIMAGE_KUWAHARA,
    
    GPUIMAGE_GAUSSIAN,
//    GPUIMAGE_GAUSSIAN_SELECTIVE,
    GPUIMAGE_FASTBLUR,
    GPUIMAGE_BOXBLUR,
//    GPUIMAGE_MEDIAN,
    GPUIMAGE_BILATERAL,
    GPUIMAGE_SWIRL,
    GPUIMAGE_BULGE,
    GPUIMAGE_PINCH,
    GPUIMAGE_SPHEREREFRACTION,
    GPUIMAGE_GLASSSPHERE,
    GPUIMAGE_STRETCH,
    GPUIMAGE_DILATION,
    GPUIMAGE_EROSION,
//    GPUIMAGE_OPENING,
//    GPUIMAGE_CLOSING,
//    GPUIMAGE_PERLINNOISE,
    GPUIMAGE_VORONI,
    GPUIMAGE_MOSAIC,
//    GPUIMAGE_LOCALBINARYPATTERN,
//    GPUIMAGE_DISSOLVE,
//    GPUIMAGE_CHROMAKEY,
//    GPUIMAGE_ADD,
//    GPUIMAGE_DIVIDE,
//    GPUIMAGE_MULTIPLY,
//    GPUIMAGE_OVERLAY,
//    GPUIMAGE_LIGHTEN,
//    GPUIMAGE_DARKEN,
//    GPUIMAGE_COLORBURN,
//    GPUIMAGE_COLORDODGE,
//    GPUIMAGE_SCREENBLEND,
//    GPUIMAGE_DIFFERENCEBLEND,
//	GPUIMAGE_SUBTRACTBLEND,
//    GPUIMAGE_EXCLUSIONBLEND,
//    GPUIMAGE_HARDLIGHTBLEND,
//    GPUIMAGE_SOFTLIGHTBLEND,
    GPUIMAGE_OPACITY,
//    GPUIMAGE_CUSTOM,
//    GPUIMAGE_UIELEMENT,
//    GPUIMAGE_FILECONFIG,
//    GPUIMAGE_FILTERGROUP,
//    GPUIMAGE_FACES,
//    GPUIMAGE_NUMFILTERS
} GPUImageShowcaseFilterType;


@interface ShowcaseFilterViewController : UIViewController <GPUImageVideoCameraDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageOutput<GPUImageInput> *filter1;
    GPUImageOutput<GPUImageInput> *filter2;
    GPUImageOutput<GPUImageInput> *filter3;
    GPUImageOutput<GPUImageInput> *filter4;
    GPUImageOutput<GPUImageInput> *filter5;
    GPUImageOutput<GPUImageInput> *filter6;
    GPUImageOutput<GPUImageInput> *filter7;
    GPUImageOutput<GPUImageInput> *tempFilter;
    GPUImagePicture *sourcePicture;
    GPUImageShowcaseFilterType filterType;
    GPUImageUIElement *uiElementInput;
    
    GPUImageFilterPipeline *pipeline;
    
    
    
    GPUImagePicture *staticPicture;
    
    
    
    UIView *faceView;
    
    CIDetector *faceDetector;
    
    IBOutlet UISwitch *facesSwitch;
    __unsafe_unretained UISlider *_filterSettingsSlider1;
    __unsafe_unretained UISlider *_filterSettingsSlider2;
     __unsafe_unretained UISlider *_filterSettingsSlider3;
     __unsafe_unretained UISlider *_filterSettingsSlider4;
    __unsafe_unretained UISlider *_filterSettingsSlider5;
    __unsafe_unretained UISlider *_filterSettingsSlider6;
    __unsafe_unretained UISlider *_filterSettingsSlider7;
    IBOutlet UILabel *facesLabel;
    __unsafe_unretained UISlider *_filterSettingsSlider;
    BOOL faceThinking;
    
    
    NSMutableArray *checkedArray,*checkedIndexArray;
    NSMutableArray *arrayTemp,*allCellArray;
    
    
    IBOutlet UILabel *nameLabel1;
    IBOutlet UILabel *nameLabel2;
    IBOutlet UILabel *nameLabel3;
    IBOutlet UILabel *nameLabel4;
    IBOutlet UILabel *nameLabel5;
    IBOutlet UILabel *nameLabel6;
    IBOutlet UILabel *nameLabel7;
    IBOutlet UILabel *nameLabel8;
    
    IBOutlet UILabel *currentValueLabel1;
    IBOutlet UILabel *currentValueLabel2;
    IBOutlet UILabel *currentValueLabel3;
    IBOutlet UILabel *currentValueLabel4;
    IBOutlet UILabel *currentValueLabel5;
    IBOutlet UILabel *currentValueLabel6;
    IBOutlet UILabel *currentValueLabel7;
    IBOutlet UILabel *currentValueLabel8;
    
    
    IBOutlet UIImageView *contentImageView;
    
    UISlider *filterSettingsSliderTemp;
    
  
    
    BOOL    isStatic;
    BOOL    isHideAll;
    UIImage * stillImage;
    
    UIButton *finishBtn;
}

@property(readwrite, unsafe_unretained, nonatomic) IBOutlet UISlider *filterSettingsSlider,*filterSettingsSlider1,*filterSettingsSlider2,*filterSettingsSlider3,*filterSettingsSlider4,*filterSettingsSlider5,*filterSettingsSlider6,*filterSettingsSlider7;
@property(nonatomic,retain) CIDetector*faceDetector;
@property(nonatomic,retain) NSMutableArray *checkedArray,*checkedIndexArray,*arrayTemp,*allCellArray;

@property(nonatomic,retain)IBOutlet UILabel *nameLabel1;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel2;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel3;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel4;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel5;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel6;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel7;
@property(nonatomic,retain)IBOutlet UILabel *nameLabel8;

@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel1;
@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel2;
@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel3;
@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel4;
@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel5;
@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel6;
@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel7;
@property(nonatomic,retain)IBOutlet UILabel *currentValueLabel8;

@property(nonatomic,retain)IBOutlet UIImageView *contentImageView;


@property(nonatomic,assign) BOOL isStatic;


@property(nonatomic,retain)UIImage * stillImage;



// Initialization and teardown
- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
- (void)setupFilter;
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
// Filter adjustments
- (IBAction)updateFilterFromSlider:(id)sender;
- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation;
-(IBAction)facesSwitched:(id)sender;

-(IBAction)hideAll:(id)sender;



@end
