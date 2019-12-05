//
//  FeedbackViewController.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"意见反馈";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    
    backend=[UserBackend shared];
    self.textEditor.delegate=self;
    self.textEditor.placeholder=@"请填写您的修改意见";
    self.submitButton.layer.cornerRadius=5;
    [self.submitButton setBackgroundColor:MAIN_COLOR];
    
    self.view.backgroundColor=BG_COLOR;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitBtn:(id)sender {
    [[backend requestUpdateUserSetting:4 withValue:self.textEditor.text]
     subscribeNext:[self didUpdate:@"反馈成功，我们会尽快处理。"]];
    
}
- (void(^)(RACTuple *))didUpdate:(NSString *)text
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            if ([self.delegate respondsToSelector:@selector(didSubmitFeedback:)]) {
                [self.delegate didSubmitFeedback:self];
            }
        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        
    };
}

//隐藏键盘，实现UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text

{
    
    if ([text isEqualToString:@"\n"]) {
        
        [self.textEditor resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;  
    
}
@end
