//
//  GPUImageSoulFilter.m
//  LUTFilter
//
//  Created by zhuyongqing on 2017/12/21.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "GPUImageSoulFilter.h"

@implementation GPUImageSoulFilter

NSString *const kGPUImageSoulVertexShaderString = SHADER_STRING(

    attribute vec4 position;
    attribute vec4 inputTextureCoordinate;
    attribute vec4 inputTextureCoordinate2;
    varying vec2 textureCoordinate;
    varying vec2 textureCoordinate2;
    void main()
{
    gl_Position = position;
    textureCoordinate = inputTextureCoordinate.xy;
    textureCoordinate2 = inputTextureCoordinate2.xy;
}
);

NSString *const kGPUImageSoulFragmentShaderString = SHADER_STRING
(
varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform lowp float mixturePercent;
 uniform highp float scalePercent;
 void main()
{
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    highp vec2 textureCoordinateToUse = textureCoordinate;
    highp vec2 center = vec2(0.5, 0.5);
    textureCoordinateToUse -= center;
    textureCoordinateToUse = textureCoordinateToUse / scalePercent;
    textureCoordinateToUse += center;
    lowp vec4 textureColor2 = texture2D(inputImageTexture2, textureCoordinateToUse );
    gl_FragColor = mix(textureColor, textureColor2, mixturePercent);
}
 );

- (instancetype)init
{
    self = [super initWithVertexShaderFromString:kGPUImageSoulVertexShaderString fragmentShaderFromString:kGPUImageSoulFragmentShaderString];
    if (self) {
        //    r2 = @"precision highp float; varying highp vec2 textureCoordinate; uniform sampler2D inputImageTexture; uniform float scale; void main() { vec2 newTextureCoordinate = vec2((scale - 1.0) * 0.5 + textureCoordinate.x / scale, (scale - 1.0) * 0.5 + textureCoordinate…";
    }
    return self;
}

- (void)setupFilterForSize:(CGSize)filterFrameSize
{
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext setActiveShaderProgram:filterProgram];
        [self setFloat:self.mix forUniformName:@"mixturePercent"];
        [self setFloat:self.scale forUniformName:@"scalePercent"];
    });
}

@end
