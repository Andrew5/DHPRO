//
//  MySearchBar.m
//  publicZnaer
//
//  Created by Jeremy on 15/1/5.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "MySearchBar.h"

@implementation MySearchBar

- (void)layoutSubviews {
    
    //设置输入框样式
    UITextField *searchField;
 
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.1f) {
        
        for (UIView *subv in self.subviews) {
            
            for (UIView* view in subv.subviews) {
               
                if ([view isKindOfClass:[UITextField class]]) {
                    
                    searchField = (UITextField*)view;
                    
                    break;
                    
                }
                
            }
            
        }
        
    }else{
        
        for (UITextField *subv in self.subviews) {
            
            if ([subv isKindOfClass:[UITextField class]]) {
                
                searchField = (UITextField*)subv;
                
                break;
               
            }
            
        }
        
    }
 
    
    if(!(searchField == nil)) {
        
        searchField.textColor = [UIColor blackColor];
        
        [searchField setBorderStyle:UITextBorderStyleRoundedRect];
        
        UIImage *image = [UIImage imageNamed: @"search_bt_01.png"];
        
        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
        
        searchField.leftView = iView;
        
    }
    
    searchField.backgroundColor = [UIColor clearColor];
  


    [super layoutSubviews];
    
}




@end
