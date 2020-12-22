#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
	TZOscillatoryAnimationToBigger,
	TZOscillatoryAnimationToSmaller,
} TZOscillatoryAnimationType;

@interface UIView (Layout)
@property (nonatomic) CGFloat hb_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat hb_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat hb_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat hb_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat hb_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat hb_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat hb_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat hb_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGSize  hb_size;        ///< Shortcut for frame.size.
@property   CGPoint hb_bottomLeft;		      ///< Shortcut for frame.bottomLeft.
@property   CGPoint hb_bottomRight;			  ///< Shortcut for frame.bottomRight.
@property   CGPoint hb_origin;				  ///< Shortcut for frame.origin.
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic,assign) CGFloat max_X;
@property (nonatomic,assign) CGFloat max_Y;
@end
