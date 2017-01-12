//
//  UIImage+Blur.h
//  XucgBlur
//  Accelerate.framework is required，iOS >= 8.0
//  Created by xucg on 2017/1/12.
//  Copyright © 2017年 xucg. All rights reserved.
//  Welcome visiting https://github.com/gukemanbu

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

// 高斯模糊，值为0.0~1.0, 默认为0.5，值越大越模糊
- (UIImage*)blurWithValue:(CGFloat)blur;

@end
