//
//  IDCardViewController.m
//  idcard
//
//  Created by hxg on 16-4-10.
//  Copyright (c) 2016年 林英伟. All rights reserved.
//
@import MobileCoreServices;
@import ImageIO;
#import "IDCardViewController.h"
#import "IdInfo.h"

@interface IDCardViewController ()

@end

@implementation IDCardViewController
@synthesize verify = _verify;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

static Boolean init_flag = false;
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
   
    if (!init_flag)
    {
        const char *thePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
        int ret = EXCARDS_Init(thePath);
        if (ret != 0)
        {
            NSLog(@"Init Failed!ret=[%d]", ret);
        }
        
        init_flag = true;
    }
    
    self.toolbar = [UIToolbar new];
    _toolbar.barStyle = UIBarStyleDefault;
    
    // size up the toolbar and set its frame
    [_toolbar sizeToFit];
    CGFloat toolbarHeight = [_toolbar frame].size.height;
    CGRect frame = self.view.bounds;
    [_toolbar setFrame:CGRectMake(CGRectGetMinX(frame),
                                  CGRectGetMinY(frame) + CGRectGetHeight(frame) - toolbarHeight,
                                  CGRectGetWidth(frame),
                                  toolbarHeight)];
    
    [self.view addSubview:_toolbar];
    
    // Create spacing
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                              target:self
                              action:@selector(closeAction)];
    
    UIBarButtonItem *start = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                              target:self
                              action:@selector(startAction)];
    
    NSMutableArray *items = [NSMutableArray arrayWithObjects: close, flex, start, flex, nil];
    [self.toolbar setItems:items animated:NO];
}

- (void)closeAction
{
    [self removeCapture];
    [self dismissViewControllerAnimated: YES completion:nil];
    if(init_flag){
        EXCARDS_Done();
        init_flag = false;
    }
}

- (void)startAction
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [nameLabel setText:@""];
        [genderLabel setText:@""];
        [nationLabel setText:@""];
        [addressLabel setText:@""];
        [codeLabel setText:@""];
        [issueLabel setText:@""];
        [validLabel setText:@""];
    });
    
    [[_capture captureSession] startRunning];
}

-(void) viewDidUnload
{
    if (_buffer != NULL)
    {
        free(_buffer);
        _buffer = NULL;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
    [self initCapture];
}
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Capture

- (void)initCapture
{
    // init capture manager
    _capture = [[Capture alloc] init];
    
    _capture.delegate = self;
    _capture.verify = self.verify;
    
    // set video streaming quality
    // AVCaptureSessionPresetHigh   1280x720
    // AVCaptureSessionPresetPhoto  852x640
    // AVCaptureSessionPresetMedium 480x360
    _capture.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    //kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
    //kCVPixelFormatType_32BGRA
    [_capture setOutPutSetting:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]];
    
    // AVCaptureDevicePositionBack
    // AVCaptureDevicePositionFront
    [_capture addVideoInput:AVCaptureDevicePositionBack];
    
    [_capture addVideoOutput];
    [_capture addVideoPreviewLayer];
    
    CGRect layerRect = self.view.bounds;
    [[_capture previewLayer] setOpaque: 0];
    [[_capture previewLayer] setBounds:layerRect];
    [[_capture previewLayer] setPosition:CGPointMake( CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    
    // create a view, on which we attach the AV Preview layer
    CGRect frame = self.view.bounds;
    CGFloat toolbarHeight = [_toolbar frame].size.height;
    frame.size.height = frame.size.height - toolbarHeight;
    _cameraView = [[UIView alloc] initWithFrame:frame];
    [[_cameraView layer] addSublayer:[_capture previewLayer]];
    
    
    NSString *str = @"姓名";
    str = @"";
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = [str sizeWithFont:font
                  constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                      lineBreakMode:NSLineBreakByWordWrapping];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, (3+size.height)*1, size.width, size.height)];
    nameLabel.text = str;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor =[UIColor redColor];
    nameLabel.font = [UIFont systemFontOfSize:13];
    [_cameraView addSubview:nameLabel];
    
    
    //str = @"性别";
    size = [str sizeWithFont:font
           constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
               lineBreakMode:NSLineBreakByWordWrapping];
    genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, (3+size.height)*2, size.width, size.height)];
    genderLabel.text = str;
    genderLabel.backgroundColor = [UIColor clearColor];
    genderLabel.textColor =[UIColor redColor];
    genderLabel.font = [UIFont systemFontOfSize:13];
    [_cameraView addSubview:genderLabel];
    
    
    //str = @"民族";
    size = [str sizeWithFont:font
           constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
               lineBreakMode:NSLineBreakByWordWrapping];
    nationLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, (3+size.height)*3, size.width, size.height)];
    nationLabel.text = str;
    nationLabel.backgroundColor = [UIColor clearColor];
    nationLabel.textColor =[UIColor redColor];
    nationLabel.font = [UIFont systemFontOfSize:13];
    [_cameraView addSubview:nationLabel];
    
    
    //str = @"地址";
    size = [str sizeWithFont:font
           constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
               lineBreakMode:NSLineBreakByWordWrapping];
    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, (3+size.height)*4, size.width, size.height)];
    addressLabel.text = str;
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor =[UIColor redColor];
    addressLabel.font = [UIFont systemFontOfSize:13];
    [_cameraView addSubview:addressLabel];
    
    
    
    //str = @"身份证号";
    size = [str sizeWithFont:font
           constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
               lineBreakMode:NSLineBreakByWordWrapping];
    codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, (3+size.height)*5, size.width, size.height)];
    codeLabel.text = str;
    codeLabel.backgroundColor = [UIColor clearColor];
    codeLabel.textColor =[UIColor redColor];
    codeLabel.font = [UIFont systemFontOfSize:13];
    [_cameraView addSubview:codeLabel];
    
    
    
    //str = @"签发机关";
    size = [str sizeWithFont:font
           constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
               lineBreakMode:NSLineBreakByWordWrapping];
    issueLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, (3+size.height)*6, size.width, size.height)];
    issueLabel.text = str;
    issueLabel.backgroundColor = [UIColor clearColor];
    issueLabel.textColor =[UIColor redColor];
    issueLabel.font = [UIFont systemFontOfSize:13];
    [_cameraView addSubview:issueLabel];
    
    
    //str = @"有效期";
    size = [str sizeWithFont:font
           constrainedToSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
               lineBreakMode:NSLineBreakByWordWrapping];
    validLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, (3+size.height)*7, size.width, size.height)];
    validLabel.text = str;
    validLabel.backgroundColor = [UIColor clearColor];
    validLabel.textColor =[UIColor redColor];
    validLabel.font = [UIFont systemFontOfSize:13];
    [_cameraView addSubview:validLabel];
    
    
    // add the view we just created as a subview to the View Controller's view
    [self.view addSubview: _cameraView];
    [self.view sendSubviewToBack:_cameraView];
    
    // start !
    [self performSelectorInBackground:@selector(startCapture) withObject:nil];
}

- (void)removeCapture
{
    [_capture.captureSession stopRunning];
    [_cameraView removeFromSuperview];
    _capture     = nil;
    _cameraView  = nil;
}

- (void)startCapture
{
    //@autoreleasepool
    {
        [[_capture captureSession] startRunning];
    }
}

#pragma mark - Capture Delegates
- (void)idCardRecognited:(IdInfo*)idInfo
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (idInfo.name != nil)
        {
            [nameLabel setText:[NSString stringWithFormat:@"姓名:%@", idInfo.name]];
            CGSize size = [nameLabel.text sizeWithFont:nameLabel.font
                                     constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];
            [nameLabel setFrame:CGRectMake(3, (3+size.height)*1, size.width, size.height)];
        }
        
        if (idInfo.gender != nil)
        {
            [genderLabel setText:[NSString stringWithFormat:@"性别:%@", idInfo.gender]];
            CGSize size = [genderLabel.text sizeWithFont:nameLabel.font
                                       constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];
            [genderLabel setFrame:CGRectMake(3, (3+size.height)*2, size.width, size.height)];
        }
        
        if (idInfo.nation != nil)
        {
            [nationLabel setText:[NSString stringWithFormat:@"民族:%@", idInfo.nation]];
            CGSize  size = [nationLabel.text sizeWithFont:nameLabel.font
                                        constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                            lineBreakMode:NSLineBreakByWordWrapping];
            [nationLabel setFrame:CGRectMake(3, (3+size.height)*3, size.width, size.height)];
        }
        
        if (idInfo.address != nil)
        {
            [addressLabel setText:[NSString stringWithFormat:@"地址:%@", idInfo.address]];
            CGSize size = [addressLabel.text sizeWithFont:nameLabel.font
                                        constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                            lineBreakMode:NSLineBreakByWordWrapping];
            [addressLabel setFrame:CGRectMake(3, (3+size.height)*4, size.width, size.height)];
        }
        
        if (idInfo.code != nil)
        {
            [codeLabel setText:[NSString stringWithFormat:@"身份证号:%@", idInfo.code]];
            CGSize size = [codeLabel.text sizeWithFont:nameLabel.font
                                     constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];
            [codeLabel setFrame:CGRectMake(3, (3+size.height)*5, size.width, size.height)];
        }
        
        if (idInfo.issue != nil)
        {
            [issueLabel setText:[NSString stringWithFormat:@"签发机关:%@", idInfo.issue]];
            CGSize size = [issueLabel.text sizeWithFont:issueLabel.font
                                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                          lineBreakMode:NSLineBreakByWordWrapping];
            [issueLabel setFrame:CGRectMake(3, (3+size.height)*6, size.width, size.height)];
        }
        
        if (idInfo.valid != nil)
        {
            [validLabel setText:[NSString stringWithFormat:@"有效期:%@", idInfo.valid]];
            CGSize size = [validLabel.text sizeWithFont:validLabel.font
                                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT)
                                          lineBreakMode:NSLineBreakByWordWrapping];
            [validLabel setFrame:CGRectMake(3, (3+size.height)*7, size.width, size.height)];
        }
    });
    
    //NSLog(@"%@", [idInfo toString]);
    [_capture.captureSession stopRunning];
    
    /*****
     [self removeCapture];
     [self dismissViewControllerAnimated: YES completion:nil];
     
     if([self.delegate respondsToSelector:@selector(idCardRecognited:)])
     {
     [self.delegate idCardRecognited:idInfo];
     }
     *****/
}


@end
