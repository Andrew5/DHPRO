#import <UIKit/UIKit.h>

@interface ShowcaseFilterListController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *allCellArray,*segmentTextContent;
    
    UISegmentedControl *segmentedControl;

    BOOL    isStatic;
    UIImage * stillImage;
    UIImagePickerController * imagePicker;
    UIPopoverController *_accountBookPopSelectViewController;

}
@property(nonatomic, strong) NSMutableArray *allCellArray,*checkedArray,*checkedIndexArray,*segmentTextContent;
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIImagePickerController * imagePicker;
@property(nonatomic, strong) UIPopoverController *_accountBookPopSelectViewController;
@end
