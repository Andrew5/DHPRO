//
//  Capture.m
//  idcard
//
//  Created by hxg on 16-4-10.
//  Copyright (c) 2016年 林英伟. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "Capture.h"

@implementation Capture
{
    unsigned char* _buffer;
    IdInfo * _lastIdInfo;
}

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize stillImage;
@synthesize outPutSetting;
@synthesize delegate;
@synthesize verify;


#pragma mark - Init

- (id)init
{
	if ((self = [super init]))
    {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
        
        // Init default values
        //self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        //AVCaptureSessionPresetHigh
        //AVCaptureSessionPresetPhoto
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        //kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        //kCVPixelFormatType_32BGRA
        self.outPutSetting = [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
        self.verify = true;
	}
    
	return self;
}

#pragma mark - Public Functions

- (void)addVideoPreviewLayer
{
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
}

- (void)addVideoInput:(AVCaptureDevicePosition)_campos
{
	AVCaptureDevice *videoDevice=nil;
	
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if (_campos == AVCaptureDevicePositionBack)
    {
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionBack)
            {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
                {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error])
                    {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                videoDevice = device;
            }
        }
    }
    else if (_campos == AVCaptureDevicePositionFront)
    {
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionFront)
            {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
                {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error])
                    {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                videoDevice = device;
            }
        }
    }
    else
        NSLog(@"Error setting camera device position.");
    
	
    if (videoDevice)
    {
        NSError *error;
		
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		
        if (!error)
        {
			if ([[self captureSession] canAddInput:videoIn])
            {
				[[self captureSession] addInput:videoIn];
            }
			else
				NSLog(@"Couldn't add video input");
		}
		else
			NSLog(@"Couldn't create video input");
	}
	else
		NSLog(@"Couldn't create video capture device");
}


- (void)addVideoOutput
{
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
	
    [[self captureSession] addOutput:output];
	
    // Specify the pixel format
    output.videoSettings = [NSDictionary dictionaryWithObject:outPutSetting forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	
    output.alwaysDiscardsLateVideoFrames = YES;
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    
    [output setSampleBufferDelegate:self queue:queue];
    
}


#pragma mark - Private Functions

- (void)addStillImageOutput
{
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey,nil];
    
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            [videoConnection setVideoMinFrameDuration:CMTimeMake(1, 15)];
            break;
        }
    }
    
    [[self captureSession] addOutput:[self stillImageOutput]];
}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
	
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
		for (AVCaptureInputPort *port in [connection inputPorts])
        {
			if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    static int n = 0;
    if (++n % 2)
        return;
    
    if ([outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] ||
        [outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]  )
    {
        if([delegate respondsToSelector:@selector(idCardRecognited:)])
        {
            IdInfo *idInfo = [self idCardRecognit:sampleBuffer];
            if (idInfo !=nil && [idInfo isOK])
            {
                [self.delegate idCardRecognited:idInfo];
            }
        }
    }
    else
    {
        NSLog(@"Error output video settings");
    }
}

- (IdInfo *)idCardRecognit:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    IdInfo *idInfo = nil;
    // Lock the image buffer
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
	{
        size_t width= CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
        size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
        size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
        unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
        unsigned char* pixelAddress = baseAddress + offset;
        /*
         size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
         size_t buffeSize = CVPixelBufferGetDataSize(imageBuffer);
         NSLog(@"bytesPerRow[%zu] width[%zu] height[%zu] buffeSize[%zu] offset[%zu]",
         bytesPerRow, width, height, buffeSize, offset);
         NSLog(@"componentInfoY.rowBytes[%zu]", rowBytes);
         NSLog(@"componentInfoCbCr.rowBytes[%zu]", uvrowBytes);
         */
        if (_buffer == NULL)
            _buffer = (unsigned char*)malloc(sizeof(unsigned char) * width * height);
        
        memcpy(_buffer, pixelAddress, sizeof(unsigned char) * width * height);
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        
        unsigned char pResult[1024];
 
        
        int ret = EXCARDS_RecoIDCardData(_buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
        if (ret <= 0)
        {
            NSLog(@"IDCardRecApi，ret[%d]", ret);
        }
        else
        {
            NSLog(@"ret=[%d]", ret);
            char ctype;
            char content[256];
            int xlen;
            int i = 0;
    
            idInfo = [[IdInfo alloc] init];
            ctype = pResult[i++];
            idInfo.type = ctype;
            while(i < ret){
                ctype = pResult[i++];
                for(xlen = 0; i < ret; ++i){
                    if(pResult[i] == ' ') { ++i; break; }
                    content[xlen++] = pResult[i];
                }
                content[xlen] = 0;
                if(xlen){
                    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    if(ctype == 0x21)
                        idInfo.code = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x22)
                        idInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x23)
                        idInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x24)
                        idInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x25)
                        idInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x26)
                        idInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x27)
                        idInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                }
            }
            if (self.verify)
            {
                if (_lastIdInfo == nil)
                {
                    _lastIdInfo = idInfo;
                    idInfo = nil;
                }
                else
                {
                    if (![_lastIdInfo isEqual:idInfo])
                    {
                        _lastIdInfo = idInfo;
                        idInfo = nil;
                    }
                }
            }
            if ([idInfo isOK])
            {
                //NSLog(@"[%@]", [idInfo toString]);
            }
        }
    }
    
    return idInfo;
    printf(".");
    //NSLog(@"end of idCardRecognit");
}


- (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Dealloc

- (void)dealloc
{
	[[self captureSession] stopRunning];
    
	previewLayer        = nil;
	captureSession      = nil;
    stillImageOutput    = nil;
    stillImage          = nil;
    outPutSetting       = nil;
    delegate            = nil;
}

@end