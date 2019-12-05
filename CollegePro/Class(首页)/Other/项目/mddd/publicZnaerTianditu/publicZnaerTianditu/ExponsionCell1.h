//
//  ExponsionCell1.h
//  Znaer
//
//  Created by Jeremy on 14-6-24.
//  Copyright (c) 2014年 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExponsionCell1 : UITableViewCell

@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UILabel *sizeLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;
@end
