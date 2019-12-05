//
//  GpUImageScaleFilter.m
//  LUTFilter
//
//  Created by zhuyongqing on 2017/12/21.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "GpUImageScaleFilter.h"

NSString *const kGPUImageScaleFragmentShaderString = SHADER_STRING
(

 precision highp float;
 varying highp vec2 textureCoordinate;
 uniform sampler2D inputImageTexture;
 uniform float scale;
 void main()
{
    
     vec2 newTextureCoordinate = vec2((scale - 1.0) *0.5 + textureCoordinate.x / scale ,(scale - 1.0) *0.5 + textureCoordinate.y /scale);
    
    vec4 textureColor = texture2D(inputImageTexture, newTextureCoordinate);
    
    vec4 shiftColor1 = texture2D(inputImageTexture, newTextureCoordinate+vec2(-0.05 * (scale - 1.0), - 0.05 *(scale - 1.0)));
    
    vec4 shiftColor2 = texture2D(inputImageTexture, newTextureCoordinate+vec2(-0.1 * (scale - 1.0), - 0.1 *(scale - 1.0)));
    
    vec3 blendFirstColor = vec3(textureColor.r , textureColor.g, shiftColor1.b);
    
    vec3 blend3DColor = vec3(shiftColor2.r, blendFirstColor.g, blendFirstColor.b);
    
    gl_FragColor = vec4(blend3DColor, textureColor.a);
    
}
 );

@implementation GpUImageScaleFilter

- (instancetype)init
{
    self = [super initWithFragmentShaderFromString:kGPUImageScaleFragmentShaderString];
    if (self) {
        
    }
    return self;
}

- (void)setupFilterForSize:(CGSize)filterFrameSize
{
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext setActiveShaderProgram:filterProgram];
        
        [self setFloat:self.scale forUniformName:@"scale"];
    });
}

@end
