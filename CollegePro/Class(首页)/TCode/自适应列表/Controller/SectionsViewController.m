
#import "SectionsViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation SectionsViewController
@synthesize names;
@synthesize keys;

- (void)viewDidLoad {
	[super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"sound"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    
    self.names = dict;
    
    NSArray *array = [[names allKeys] sortedArrayUsingSelector:
                      @selector(compare:)];
    self.keys = array;
	
	myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight) style:(UITableViewStylePlain)];
	myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	[self.view addSubview:myTableView];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.names = nil;
    self.keys = nil;
    [super viewDidUnload];
}


#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
	
    NSString *key = [keys objectAtIndex:row];
    NSString*nameSection = [names objectForKey:key];
	
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 SectionsTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:SectionsTableIdentifier];
    }
	
    cell.textLabel.text = nameSection;
    return cell;
}
/**
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    NSString *key = [keys objectAtIndex:section];
    return key;
}
*/
/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return keys;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
	
    NSString *key = [keys objectAtIndex:row];
    NSString *title = [[NSString alloc] initWithFormat:@"%@",[names objectForKey:key]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"welcome to listen" otherButtonTitles: nil];
    [AppDelegate playSound:[key intValue]];
    [alert show];
}
@end
