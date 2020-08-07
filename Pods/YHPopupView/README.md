YHPopupView
=============
[![CocoaPods](https://img.shields.io/cocoapods/v/YHPopupView.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/p/YHPopupView.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/YHPopupView.svg)]()

[中文介绍](http://www.jianshu.com/p/4555d04d1a22)

A pubilic popup view, **YHPopupView**, is provided on iOS. And it can be used and customized convieniencely. Then you can focus on the view with the context that you want to show. 

![demo](Images/0.png)

![demo](Images/0.gif)


Installation
============

The preferred way of installation is via [CocoaPods](http://cocoapods.org). Just add

```ruby
pod 'YHPopupView'
```

and run `pod install`. It will install the most recent version of YHPopupView.

If you would like to use the latest code of YHPopupView use:

```ruby
pod 'YHPopupView', :head
```

Usage
===============

###YHPopupView

```objc
#import "ViewController.h"
#import "YHPopupView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YHPopupView *popupView = [[YHPopupView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    popupView.clickBlankSpaceDismiss = YES;
    // You can add subview in need
    popupView.backgroundColor = [UIColor blueColor];
    [self presentPopupView:popupView];
}

@end
```

###YHMessageView
```objc
- (IBAction)showMessageView:(id)sender {
    YHMessageView *messageView = [[YHMessageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    messageView.showTime = 3;
    messageView.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0.5];
    messageView.delegate = self;
    [messageView addSubview:label];
    [self presentMessageView:messageView];
}

#pragma mark - YHMessageView Delegate
- (void)tapMessageView:(YHMessageView *)messageView {
    NSLog(@"tap messageView");
}

@end
```


Changelog
===============

v0.2.0  add YHMessageView

v0.1.0  first version
