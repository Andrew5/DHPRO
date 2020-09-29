//
//  GameScene.m
//  OCLint Shared
//
//  Created by jabraknight on 2020/9/24.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}

+ (GameScene *)newGameScene {
    // Load 'GameScene.sks' as an SKScene.
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    if (!scene) {
        NSLog(@"Failed to load GameScene.sks");
        abort();
    }

    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;

    return scene;
}

- (void)setUpScene {
    // Get label node from scene and store it for use later
    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
    _label.alpha = 0.0;
    [_label runAction:[SKAction fadeInWithDuration:2.0]];

    // Create shape node to use during mouse interaction
    CGFloat w = (self.size.width + self.size.height) * 0.05;
    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];

    _spinnyNode.lineWidth = 4.0;
    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
    [_spinnyNode runAction:[SKAction sequence:@[
        [SKAction waitForDuration:0.5],
        [SKAction fadeOutWithDuration:0.5],
        [SKAction removeFromParent],
    ]]];

#if TARGET_OS_WATCH
    // For watch we just periodically create one of these and let it spin
    // For other platforms we let user touch/mouse events create these
    _spinnyNode.position = CGPointMake(0.0, 0.0);
    _spinnyNode.strokeColor = [SKColor redColor];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[
        [SKAction waitForDuration:2.0],
        [SKAction runBlock:^{
            [self addChild:[self->_spinnyNode copy]];
        }]
    ]]]];
#endif
}

#if TARGET_OS_WATCH
- (void)sceneDidLoad {
    [self setUpScene];
}
#else
- (void)didMoveToView:(SKView *)view {
    [self setUpScene];
}
#endif

- (void)makeSpinnyAtPoint:(CGPoint)pos color:(SKColor *)color {
    SKShapeNode *spinny = [_spinnyNode copy];
    spinny.position = pos;
    spinny.strokeColor = color;
    [self addChild:spinny];
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

#if TARGET_OS_IOS || TARGET_OS_TV
// Touch-based event handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];

    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor greenColor]];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor blueColor]];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor redColor]];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self makeSpinnyAtPoint:[t locationInNode:self] color:[SKColor redColor]];
    }
}
#endif

#if TARGET_OS_OSX
// Mouse-based event handling

- (void)mouseDown:(NSEvent *)event {
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];

    [self makeSpinnyAtPoint:[event locationInNode:self] color:[SKColor greenColor]];
}

- (void)mouseDragged:(NSEvent *)event {
    [self makeSpinnyAtPoint:[event locationInNode:self] color:[SKColor blueColor]];
}

- (void)mouseUp:(NSEvent *)event {
    [self makeSpinnyAtPoint:[event locationInNode:self] color:[SKColor redColor]];
}

#endif

@end
