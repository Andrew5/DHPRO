#import "GoodsDetailRateViewCell.h"
#import "AMRatingControl.h"

@implementation GoodsDetailRateViewCell {
    AMRatingControl *coloredRatingControl;
}

- (void)awakeFromNib {
    CGPoint point = self.hSplitView.frame.origin;
    point.x = point.x + 40;
    point.y = point.y-10;

    coloredRatingControl = [[AMRatingControl alloc]
            initWithLocation:point
                  emptyColor:[UIColor orangeColor]
                  solidColor:[UIColor orangeColor]
                andMaxRating:5];
    [coloredRatingControl setDisable];

    [self addSubview:coloredRatingControl];
}
@end
