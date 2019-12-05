//
//  ViewController.m
//  saoSeven
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize zView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    array=[[NSMutableArray alloc]initWithObjects:@"1000",@"700",@"900",@"1200",@"1500",@"800",@"1000",@"2000",@"2000",@"3000",@"2345",@"3456",@"1234",@"567",@"4500",@"3500",@"2500",@"1212",@"777",@"2457",@"222",@"100",@"0",@"0", nil];
    
    zView.layer.masksToBounds=YES;
    zView.layer.cornerRadius=6.0;
    zView.layer.borderWidth=1.0;
    zView.layer.borderColor=[[UIColor orangeColor]CGColor];
    
     [self performSelector:@selector(mmqm) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)mmqm{
    sView=[[saoSeven alloc]initWithFrame:CGRectMake(0, 0, self.zView.frame.size.width, self.zView.frame.size.height)];
    sView.backgroundColor=[UIColor orangeColor];
    sView.array=array;
    sView.number=@"5000";
    sView.count=@"24";
    [zView  addSubview:sView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
