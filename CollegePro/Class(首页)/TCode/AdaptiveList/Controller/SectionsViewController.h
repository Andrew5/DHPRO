

#import <UIKit/UIKit.h>

@interface SectionsViewController : BaseViewController
<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *names;
    NSArray      *keys;
	UITableView *myTableView;
}
@property (nonatomic, retain) NSDictionary *names;
@property (nonatomic, retain) NSArray *keys;
@end
