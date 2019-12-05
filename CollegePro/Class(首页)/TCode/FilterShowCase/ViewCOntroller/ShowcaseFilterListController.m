#import "ShowcaseFilterListController.h"
#import "ShowcaseFilterViewController.h"

@interface ShowcaseFilterListController ()

@end

@implementation ShowcaseFilterListController
@synthesize allCellArray,checkedArray,checkedIndexArray,segmentTextContent;
@synthesize segmentedControl;
@synthesize imagePicker;
@synthesize _accountBookPopSelectViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.allCellArray = [[NSMutableArray alloc]init];
    self.checkedArray = [[NSMutableArray alloc]init];
    self.checkedIndexArray = [[NSMutableArray alloc]init];
    
    for(int i=0;i<42;i++)
    {
        [checkedArray addObject:@"0"];
    }
    self.title = @"Choose Elements(8 limited)";
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [finishBtn setTitle:@"Done" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(DoneAction:) forControlEvents:UIControlEventTouchDown];
    finishBtn.frame = CGRectMake(0, 0, 52, 36);
    
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
	self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    segmentTextContent = [[NSMutableArray alloc]initWithObjects:@"Camera",@"Image",nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];

	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(CancelAction:) forControlEvents:UIControlEventTouchDown];
//    cancelBtn.frame = CGRectMake(0, 0, 100, 36);
    
    
    
    
    
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [self initAllCell];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - DoneAction
- (void)DoneAction:(id)sender
{
    if([checkedIndexArray count]>0)
    {
        if([checkedIndexArray count]>8)
        {
            
            
            
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"Exceed Elements Limited: 8"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil, nil];
            [errorAlertView show];
            
            return ;
        }
        
        ShowcaseFilterViewController *filterViewController = [[ShowcaseFilterViewController alloc] initWithFilterType:[[self.checkedIndexArray objectAtIndex:0] intValue]];
        filterViewController.checkedIndexArray = self.checkedIndexArray;
        filterViewController.checkedArray = self.checkedArray;
        filterViewController.allCellArray = self.allCellArray;
        filterViewController.isStatic = isStatic;
        
        if(stillImage)
        {
            filterViewController.stillImage = stillImage;
        }
        
        NSLog(@"checkedArray  %@",self.checkedArray);
        
        NSLog(@"checkedIndexArray %@",self.checkedIndexArray);
        [self.navigationController pushViewController:filterViewController animated:YES];
    }
}


- (void)CancelAction:(id)sender
{
    
}

#pragma mark - segmentAction
-(IBAction)segmentAction:(id)sender
{

	segmentedControl = (UISegmentedControl *)sender;
	if (segmentedControl.selectedSegmentIndex == 0)
	{
        isStatic = NO;
		
	}
	else if (segmentedControl.selectedSegmentIndex == 1)
	{

        isStatic = YES;
        
        imagePicker = [[UIImagePickerController alloc]init];
		UIImagePickerControllerSourceType	soureType;
        
        soureType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate =self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = soureType;
       
        
        
        
        UIDevice *device  = [UIDevice currentDevice];
        NSLog(@"device.model %@",device.model);
        if([device.model isEqualToString:@"iPad"])
        {
            _accountBookPopSelectViewController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            _accountBookPopSelectViewController.popoverContentSize = CGSizeMake(400,600);
            //        popoverViewController.curPopViewController = _accountBookPopSelectViewController;
            //        popoverViewController.curParentController = self;
            //        [popoverViewController setWithFrame:CGRectMake(0,0,w,h) withData:testArray_f];
            
            [_accountBookPopSelectViewController presentPopoverFromRect:CGRectMake(0 , 0, 80, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            //
        }
        else
        {
             [self presentModalViewController:imagePicker animated:YES];
        }
        

//

	}

    
	
}


#pragma mark - UIImagePicker
// UIImagePicker  选择图片处理方法
#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIDevice *device  = [UIDevice currentDevice];
    NSLog(@"device.model %@",device.model);
    if([device.model isEqualToString:@"iPad"])
    {
        [_accountBookPopSelectViewController dismissPopoverAnimated:YES];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
	

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	
	
    
	
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
    UIDevice *device  = [UIDevice currentDevice];
    NSLog(@"device.model %@",device.model);
    if([device.model isEqualToString:@"iPad"])
    {
        [_accountBookPopSelectViewController dismissPopoverAnimated:YES];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
	UIImage *imageselect= [info valueForKey:UIImagePickerControllerOriginalImage];

	stillImage =[imageselect copy] ;



}

#pragma mark - checkedAction

- (void)checkedAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    int tag = btn.tag - 888888;
    NSString *flag = [checkedArray objectAtIndex:tag];
    
    if([flag isEqualToString:@"0"])
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [checkedArray replaceObjectAtIndex:tag withObject:@"1"];
        [checkedIndexArray addObject:[NSString stringWithFormat:@"%d",tag]];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [checkedArray replaceObjectAtIndex:tag withObject:@"0"];
         [checkedIndexArray removeObject:[NSString stringWithFormat:@"%d",tag]];
        
    }
    
}

- (void)initAllCell
{
    for(int i=0;i<42;i++)
    {
//        UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
//        if (cell == nil)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"];
//            cell.textLabel.textColor = [UIColor blackColor];
//        }
        
        static NSString *SimpleTableIdentifier = @"Simple";
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:SimpleTableIdentifier];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(checkedAction:) forControlEvents:UIControlEventTouchDown];
        btn.frame = CGRectMake(280, 8, 22, 22);
        btn.tag = 888888+i;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BOOL addToTable = YES;
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        switch (i)
        {
            case GPUIMAGE_SATURATION: cell.textLabel.text = @"Saturation"; break;
            case GPUIMAGE_CONTRAST: cell.textLabel.text = @"Contrast"; break;
            case GPUIMAGE_BRIGHTNESS: cell.textLabel.text = @"Brightness"; break;
            case GPUIMAGE_EXPOSURE: cell.textLabel.text = @"Exposure"; break;
            case GPUIMAGE_RGB_GREEN: cell.textLabel.text = @"RGB Green"; break;
            case GPUIMAGE_RGB_BLUE: cell.textLabel.text = @"RGB Blue"; break;
            case GPUIMAGE_RGB_RED: cell.textLabel.text = @"RGB Red"; break;

            case GPUIMAGE_HUE: cell.textLabel.text = @"Hue"; break;
            case GPUIMAGE_MONOCHROME: cell.textLabel.text = @"Monochrome"; break;
            case GPUIMAGE_FALSECOLOR: cell.textLabel.text = @"False color (BUILD)"; break;
            case GPUIMAGE_SHARPEN: cell.textLabel.text = @"Sharpen"; break;
//            case GPUIMAGE_UNSHARPMASK: cell.textLabel.text = @"Unsharp mask"; addToTable = NO;break;
            case GPUIMAGE_GAMMA: cell.textLabel.text = @"Gamma"; break;
            case GPUIMAGE_TONECURVE: cell.textLabel.text = @"Tone curve";  break;
//            case GPUIMAGE_HIGHLIGHTSHADOW: cell.textLabel.text = @"Highlights and shadows";addToTable = NO; break;
            case GPUIMAGE_HAZE: cell.textLabel.text = @"Haze"; break;
//            case GPUIMAGE_HISTOGRAM: cell.textLabel.text = @"Histogram"; addToTable = NO; break;
//            case GPUIMAGE_AVERAGECOLOR: cell.textLabel.text = @"Average color";addToTable = NO; break;
//            case GPUIMAGE_LUMINOSITY: cell.textLabel.text = @"Luminosity";addToTable = NO; break;
            case GPUIMAGE_THRESHOLD: cell.textLabel.text = @"Threshold"; break;
//            case GPUIMAGE_ADAPTIVETHRESHOLD: cell.textLabel.text = @"Adaptive threshold";addToTable = NO; break;
//            case GPUIMAGE_AVERAGELUMINANCETHRESHOLD: cell.textLabel.text = @"Average luminance threshold"; addToTable = NO;break;
//            case GPUIMAGE_CROP: cell.textLabel.text = @"Crop"; addToTable = NO;break;
//            case GPUIMAGE_TRANSFORM: cell.textLabel.text = @"Transform (2-D)"; addToTable = NO;break;
//            case GPUIMAGE_TRANSFORM3D: cell.textLabel.text = @"Transform (3-D)"; addToTable = NO;break;
//            case GPUIMAGE_MASK: cell.textLabel.text = @"Mask"; addToTable = NO;break;
            case GPUIMAGE_COLORINVERT: cell.textLabel.text = @"Color invert"; break;
            case GPUIMAGE_GRAYSCALE: cell.textLabel.text = @"Grayscale"; break;
            case GPUIMAGE_SEPIA: cell.textLabel.text = @"Sepia tone"; break;
            case GPUIMAGE_MISSETIKATE: cell.textLabel.text = @"Miss Etikate (Lookup)"; break;
            case GPUIMAGE_SOFTELEGANCE: cell.textLabel.text = @"Soft elegance (Lookup)"; break;
            case GPUIMAGE_AMATORKA: cell.textLabel.text = @"Amatorka (Lookup)"; break;
//            case GPUIMAGE_PIXELLATE: cell.textLabel.text = @"Pixellate"; addToTable = NO;break;
//            case GPUIMAGE_POLARPIXELLATE: cell.textLabel.text = @"Polar pixellate"; addToTable = NO;break;
//            case GPUIMAGE_POLKADOT: cell.textLabel.text = @"Polka dot"; addToTable = NO;break;
//            case GPUIMAGE_CROSSHATCH: cell.textLabel.text = @"Crosshatch"; addToTable = NO;break;
//            case GPUIMAGE_SOBELEDGEDETECTION: cell.textLabel.text = @"Sobel edge detection"; addToTable = NO;break;
//            case GPUIMAGE_PREWITTEDGEDETECTION: cell.textLabel.text = @"Prewitt edge detection"; addToTable = NO;break;
//            case GPUIMAGE_CANNYEDGEDETECTION: cell.textLabel.text = @"Canny edge detection"; addToTable = NO;break;
//            case GPUIMAGE_XYGRADIENT: cell.textLabel.text = @"XY derivative"; addToTable = NO;break;
//            case GPUIMAGE_HARRISCORNERDETECTION: cell.textLabel.text = @"Harris corner detection"; addToTable = NO;break;
//            case GPUIMAGE_NOBLECORNERDETECTION: cell.textLabel.text = @"Noble corner detection"; addToTable = NO;break;
//            case GPUIMAGE_SHITOMASIFEATUREDETECTION: cell.textLabel.text = @"Shi-Tomasi feature detection"; addToTable = NO;break;
//            case GPUIMAGE_BUFFER: cell.textLabel.text = @"Image buffer"; addToTable = NO;break;
            case GPUIMAGE_SKETCH: cell.textLabel.text = @"Sketch"; break;
            case GPUIMAGE_TOON: cell.textLabel.text = @"Toon"; break;
            case GPUIMAGE_SMOOTHTOON: cell.textLabel.text = @"Smooth toon"; break;
//            case GPUIMAGE_TILTSHIFT: cell.textLabel.text = @"Tilt shift"; addToTable = NO;break;
//            case GPUIMAGE_CGA: cell.textLabel.text = @"CGA colorspace"; addToTable = NO;break;
//            case GPUIMAGE_CONVOLUTION: cell.textLabel.text = @"3x3 convolution"; addToTable = NO;break;
            case GPUIMAGE_EMBOSS: cell.textLabel.text = @"Emboss"; break;
            case GPUIMAGE_POSTERIZE: cell.textLabel.text = @"Posterize"; break;
            case GPUIMAGE_SWIRL: cell.textLabel.text = @"Swirl"; break;
            case GPUIMAGE_BULGE: cell.textLabel.text = @"Bulge"; break;
            case GPUIMAGE_SPHEREREFRACTION: cell.textLabel.text = @"Sphere refraction"; break;
            case GPUIMAGE_GLASSSPHERE: cell.textLabel.text = @"Glass sphere"; break;
            case GPUIMAGE_PINCH: cell.textLabel.text = @"Pinch"; break;
            case GPUIMAGE_STRETCH: cell.textLabel.text = @"Stretch"; break;
            case GPUIMAGE_DILATION: cell.textLabel.text = @"Dilation"; break;
            case GPUIMAGE_EROSION: cell.textLabel.text = @"Erosion"; break;
//            case GPUIMAGE_OPENING: cell.textLabel.text = @"Opening"; addToTable = NO;break;
//            case GPUIMAGE_CLOSING: cell.textLabel.text = @"Closing"; addToTable = NO;break;
//            case GPUIMAGE_PERLINNOISE: cell.textLabel.text = @"Perlin noise"; addToTable = NO;break;
            case GPUIMAGE_VORONI: cell.textLabel.text = @"Voroni"; break;
            case GPUIMAGE_MOSAIC: cell.textLabel.text = @"Mosaic"; break;
//            case GPUIMAGE_LOCALBINARYPATTERN: cell.textLabel.text = @"Local binary pattern"; addToTable = NO;break;
//            case GPUIMAGE_CHROMAKEY: cell.textLabel.text = @"Chroma key (green)"; break;
//            case GPUIMAGE_DISSOLVE: cell.textLabel.text = @"Dissolve blend";  = NO;break;
//            case GPUIMAGE_SCREENBLEND: cell.textLabel.text = @"Screen blend"; addToTable = NO;break;
//            case GPUIMAGE_COLORBURN: cell.textLabel.text = @"Color burn blend"; break;
//            case GPUIMAGE_COLORDODGE: cell.textLabel.text = @"Color dodge blend"; break;
//            case GPUIMAGE_ADD: cell.textLabel.text = @"Add blend"; addToTable = NO;break;
//            case GPUIMAGE_DIVIDE: cell.textLabel.text = @"Divide blend"; addToTable = NO;break;
//            case GPUIMAGE_MULTIPLY: cell.textLabel.text = @"Multiply blend"; addToTable = NO;break;
//            case GPUIMAGE_OVERLAY: cell.textLabel.text = @"Overlay blend"; addToTable = NO;break;
//            case GPUIMAGE_LIGHTEN: cell.textLabel.text = @"Lighten blend"; break;
//            case GPUIMAGE_DARKEN: cell.textLabel.text = @"Darken blend"; break;
//            case GPUIMAGE_EXCLUSIONBLEND: cell.textLabel.text = @"Exclusion blend"; addToTable = NO;break;
//            case GPUIMAGE_DIFFERENCEBLEND: cell.textLabel.text = @"Difference blend"; addToTable = NO;break;
//            case GPUIMAGE_SUBTRACTBLEND: cell.textLabel.text = @"Subtract blend"; addToTable = NO;break;
//            case GPUIMAGE_HARDLIGHTBLEND: cell.textLabel.text = @"Hard light blend"; addToTable = NO;break;
//            case GPUIMAGE_SOFTLIGHTBLEND: cell.textLabel.text = @"Soft light blend"; addToTable = NO;break;
            case GPUIMAGE_OPACITY: cell.textLabel.text = @"Opacity adjustment"; break;
//            case GPUIMAGE_KUWAHARA: cell.textLabel.text = @"Kuwahara"; addToTable = NO;break;
            case GPUIMAGE_VIGNETTE: cell.textLabel.text = @"Vignette"; break;
            case GPUIMAGE_GAUSSIAN: cell.textLabel.text = @"Gaussian blur"; break;
            case GPUIMAGE_FASTBLUR: cell.textLabel.text = @"Fast blur"; break;
//            case GPUIMAGE_MEDIAN: cell.textLabel.text = @"Median (3x3)"; addToTable = NO;break;
            case GPUIMAGE_BILATERAL: cell.textLabel.text = @"Bilateral blur"; break;
            case GPUIMAGE_BOXBLUR: cell.textLabel.text = @"Box blur"; break;
//            case GPUIMAGE_GAUSSIAN_SELECTIVE: cell.textLabel.text = @"Gaussian selective blur"; addToTable = NO;break;
//            case GPUIMAGE_UIELEMENT: cell.textLabel.text = @"UI element"; addToTable = NO;break;
//            case GPUIMAGE_CUSTOM: cell.textLabel.text = @"Custom"; addToTable = NO;break;
//            case GPUIMAGE_FILECONFIG: cell.textLabel.text = @"Filter Chain"; addToTable = NO;break;
//            case GPUIMAGE_FILTERGROUP: cell.textLabel.text = @"Filter Group"; addToTable = NO;break;
//            case GPUIMAGE_FACES: cell.textLabel.text = @"Face Detection"; addToTable = NO;break;
        }
        
        if(addToTable){
            cell.accessoryView = btn;
            [allCellArray addObject:cell];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Disable the last filter (Core Image face detection) if running on iOS 4.0
    return allCellArray.count
    ;
//    if ([GPUImageOpenGLESContext supportsFastTextureUpload])
//    {
//        return GPUIMAGE_NUMFILTERS;
//    }
//    else
//    {
//        return (GPUIMAGE_NUMFILTERS - 1);
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger index = [indexPath row];
	UITableViewCell *cell = [allCellArray objectAtIndex:index];
//	if (cell == nil)
//	{
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FilterCell"];
//		cell.textLabel.textColor = [UIColor blackColor];
//	}		
//	
//	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//	switch (index)
//	{
//		case GPUIMAGE_SATURATION: cell.textLabel.text = @"Saturation"; break;
//		case GPUIMAGE_CONTRAST: cell.textLabel.text = @"Contrast"; break;
//		case GPUIMAGE_BRIGHTNESS: cell.textLabel.text = @"Brightness"; break;
//		case GPUIMAGE_EXPOSURE: cell.textLabel.text = @"Exposure"; break;
//        case GPUIMAGE_RGB: cell.textLabel.text = @"RGB"; break;
//        case GPUIMAGE_HUE: cell.textLabel.text = @"Hue"; break;
//        case GPUIMAGE_MONOCHROME: cell.textLabel.text = @"Monochrome"; break;
//        case GPUIMAGE_FALSECOLOR: cell.textLabel.text = @"False color"; break;
//		case GPUIMAGE_SHARPEN: cell.textLabel.text = @"Sharpen"; break;
//		case GPUIMAGE_UNSHARPMASK: cell.textLabel.text = @"Unsharp mask"; break;
//		case GPUIMAGE_GAMMA: cell.textLabel.text = @"Gamma"; break;
//		case GPUIMAGE_TONECURVE: cell.textLabel.text = @"Tone curve"; break;
//		case GPUIMAGE_HIGHLIGHTSHADOW: cell.textLabel.text = @"Highlights and shadows"; break;
//		case GPUIMAGE_HAZE: cell.textLabel.text = @"Haze"; break;
//        case GPUIMAGE_HISTOGRAM: cell.textLabel.text = @"Histogram"; break;
//        case GPUIMAGE_AVERAGECOLOR: cell.textLabel.text = @"Average color"; break;
//        case GPUIMAGE_LUMINOSITY: cell.textLabel.text = @"Luminosity"; break;
//		case GPUIMAGE_THRESHOLD: cell.textLabel.text = @"Threshold"; break;
//		case GPUIMAGE_ADAPTIVETHRESHOLD: cell.textLabel.text = @"Adaptive threshold"; break;
//		case GPUIMAGE_AVERAGELUMINANCETHRESHOLD: cell.textLabel.text = @"Average luminance threshold"; break;
//        case GPUIMAGE_CROP: cell.textLabel.text = @"Crop"; break;
//        case GPUIMAGE_TRANSFORM: cell.textLabel.text = @"Transform (2-D)"; break;
//        case GPUIMAGE_TRANSFORM3D: cell.textLabel.text = @"Transform (3-D)"; break;
//		case GPUIMAGE_MASK: cell.textLabel.text = @"Mask"; break;
//        case GPUIMAGE_COLORINVERT: cell.textLabel.text = @"Color invert"; break;
//        case GPUIMAGE_GRAYSCALE: cell.textLabel.text = @"Grayscale"; break;
//		case GPUIMAGE_SEPIA: cell.textLabel.text = @"Sepia tone"; break;
//		case GPUIMAGE_MISSETIKATE: cell.textLabel.text = @"Miss Etikate (Lookup)"; break;
//		case GPUIMAGE_SOFTELEGANCE: cell.textLabel.text = @"Soft elegance (Lookup)"; break;
//		case GPUIMAGE_AMATORKA: cell.textLabel.text = @"Amatorka (Lookup)"; break;
//		case GPUIMAGE_PIXELLATE: cell.textLabel.text = @"Pixellate"; break;
//		case GPUIMAGE_POLARPIXELLATE: cell.textLabel.text = @"Polar pixellate"; break;
//		case GPUIMAGE_POLKADOT: cell.textLabel.text = @"Polka dot"; break;
//		case GPUIMAGE_CROSSHATCH: cell.textLabel.text = @"Crosshatch"; break;
//		case GPUIMAGE_SOBELEDGEDETECTION: cell.textLabel.text = @"Sobel edge detection"; break;
//		case GPUIMAGE_PREWITTEDGEDETECTION: cell.textLabel.text = @"Prewitt edge detection"; break;
//		case GPUIMAGE_CANNYEDGEDETECTION: cell.textLabel.text = @"Canny edge detection"; break;
//		case GPUIMAGE_XYGRADIENT: cell.textLabel.text = @"XY derivative"; break;
//		case GPUIMAGE_HARRISCORNERDETECTION: cell.textLabel.text = @"Harris corner detection"; break;
//		case GPUIMAGE_NOBLECORNERDETECTION: cell.textLabel.text = @"Noble corner detection"; break;
//		case GPUIMAGE_SHITOMASIFEATUREDETECTION: cell.textLabel.text = @"Shi-Tomasi feature detection"; break;
//		case GPUIMAGE_BUFFER: cell.textLabel.text = @"Image buffer"; break;
//		case GPUIMAGE_SKETCH: cell.textLabel.text = @"Sketch"; break;
//		case GPUIMAGE_TOON: cell.textLabel.text = @"Toon"; break;
//		case GPUIMAGE_SMOOTHTOON: cell.textLabel.text = @"Smooth toon"; break;
//		case GPUIMAGE_TILTSHIFT: cell.textLabel.text = @"Tilt shift"; break;
//		case GPUIMAGE_CGA: cell.textLabel.text = @"CGA colorspace"; break;
//		case GPUIMAGE_CONVOLUTION: cell.textLabel.text = @"3x3 convolution"; break;
//		case GPUIMAGE_EMBOSS: cell.textLabel.text = @"Emboss"; break;
//		case GPUIMAGE_POSTERIZE: cell.textLabel.text = @"Posterize"; break;
//		case GPUIMAGE_SWIRL: cell.textLabel.text = @"Swirl"; break;
//		case GPUIMAGE_BULGE: cell.textLabel.text = @"Bulge"; break;
//		case GPUIMAGE_SPHEREREFRACTION: cell.textLabel.text = @"Sphere refraction"; break;
//		case GPUIMAGE_GLASSSPHERE: cell.textLabel.text = @"Glass sphere"; break;
//		case GPUIMAGE_PINCH: cell.textLabel.text = @"Pinch"; break;
//		case GPUIMAGE_STRETCH: cell.textLabel.text = @"Stretch"; break;
//		case GPUIMAGE_DILATION: cell.textLabel.text = @"Dilation"; break;
//		case GPUIMAGE_EROSION: cell.textLabel.text = @"Erosion"; break;
//		case GPUIMAGE_OPENING: cell.textLabel.text = @"Opening"; break;
//		case GPUIMAGE_CLOSING: cell.textLabel.text = @"Closing"; break;
//        case GPUIMAGE_PERLINNOISE: cell.textLabel.text = @"Perlin noise"; break;
//        case GPUIMAGE_VORONI: cell.textLabel.text = @"Voroni"; break;
//        case GPUIMAGE_MOSAIC: cell.textLabel.text = @"Mosaic"; break;
//		case GPUIMAGE_LOCALBINARYPATTERN: cell.textLabel.text = @"Local binary pattern"; break;
//		case GPUIMAGE_CHROMAKEY: cell.textLabel.text = @"Chroma key (green)"; break;
//		case GPUIMAGE_DISSOLVE: cell.textLabel.text = @"Dissolve blend"; break;
//		case GPUIMAGE_SCREENBLEND: cell.textLabel.text = @"Screen blend"; break;
//		case GPUIMAGE_COLORBURN: cell.textLabel.text = @"Color burn blend"; break;
//		case GPUIMAGE_COLORDODGE: cell.textLabel.text = @"Color dodge blend"; break;
//		case GPUIMAGE_ADD: cell.textLabel.text = @"Add blend"; break;
//		case GPUIMAGE_DIVIDE: cell.textLabel.text = @"Divide blend"; break;
//		case GPUIMAGE_MULTIPLY: cell.textLabel.text = @"Multiply blend"; break;
//	    case GPUIMAGE_OVERLAY: cell.textLabel.text = @"Overlay blend"; break;
//	    case GPUIMAGE_LIGHTEN: cell.textLabel.text = @"Lighten blend"; break;
//	    case GPUIMAGE_DARKEN: cell.textLabel.text = @"Darken blend"; break;
//	    case GPUIMAGE_EXCLUSIONBLEND: cell.textLabel.text = @"Exclusion blend"; break;
//	    case GPUIMAGE_DIFFERENCEBLEND: cell.textLabel.text = @"Difference blend"; break;
//		case GPUIMAGE_SUBTRACTBLEND: cell.textLabel.text = @"Subtract blend"; break;
//	    case GPUIMAGE_HARDLIGHTBLEND: cell.textLabel.text = @"Hard light blend"; break;
//	    case GPUIMAGE_SOFTLIGHTBLEND: cell.textLabel.text = @"Soft light blend"; break;
//	    case GPUIMAGE_OPACITY: cell.textLabel.text = @"Opacity adjustment"; break;
//        case GPUIMAGE_KUWAHARA: cell.textLabel.text = @"Kuwahara"; break;
//        case GPUIMAGE_VIGNETTE: cell.textLabel.text = @"Vignette"; break;
//        case GPUIMAGE_GAUSSIAN: cell.textLabel.text = @"Gaussian blur"; break;
//        case GPUIMAGE_FASTBLUR: cell.textLabel.text = @"Fast blur"; break;
//        case GPUIMAGE_MEDIAN: cell.textLabel.text = @"Median (3x3)"; break;
//        case GPUIMAGE_BILATERAL: cell.textLabel.text = @"Bilateral blur"; break;
//        case GPUIMAGE_BOXBLUR: cell.textLabel.text = @"Box blur"; break;
//        case GPUIMAGE_GAUSSIAN_SELECTIVE: cell.textLabel.text = @"Gaussian selective blur"; break;
//        case GPUIMAGE_UIELEMENT: cell.textLabel.text = @"UI element"; break;
//		case GPUIMAGE_CUSTOM: cell.textLabel.text = @"Custom"; break;
//        case GPUIMAGE_FILECONFIG: cell.textLabel.text = @"Filter Chain"; break;
//        case GPUIMAGE_FILTERGROUP: cell.textLabel.text = @"Filter Group"; break;
//        case GPUIMAGE_FACES: cell.textLabel.text = @"Face Detection"; break;
//	}
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ShowcaseFilterViewController *filterViewController = [[ShowcaseFilterViewController alloc] initWithFilterType:indexPath.row];
//    [self.navigationController pushViewController:filterViewController animated:YES];
}

@end
