//
//  UIImage+Blur.m
//  XucgBlur
//
//  Created by xucg on 2017/1/12.
//  Copyright © 2017年 xucg. All rights reserved.
//  Welcome visiting https://github.com/gukemanbu

#import "UIImage+Blur.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Blur)

- (UIImage*)blurWithValue:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    CGImageRef srcImageRef = self.CGImage;
    
    vImage_Buffer inBuffer;
    inBuffer.width = CGImageGetWidth(srcImageRef);
    inBuffer.height = CGImageGetHeight(srcImageRef);
    inBuffer.rowBytes = CGImageGetBytesPerRow(srcImageRef);
    
    // 从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(srcImageRef);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    void *pixelBuffer = malloc(CGImageGetBytesPerRow(srcImageRef) * CGImageGetHeight(srcImageRef));
    if(!pixelBuffer) {
        NSLog(@"pixelBuffer is NULL");
    }
    
    vImage_Buffer outBuffer;
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(srcImageRef);
    outBuffer.height = CGImageGetHeight(srcImageRef);
    outBuffer.rowBytes = CGImageGetBytesPerRow(srcImageRef);
    
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    vImage_Error error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"vImage convolution error: %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef blurImageRef = CGBitmapContextCreateImage (ctx);
    UIImage *blurImage = [UIImage imageWithCGImage:blurImageRef];
    
    // clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(blurImageRef);
    
    return blurImage;
}

@end
