//
//  UIColor+Adjustable.h
//  RotaryDial
//
//  Created by Dan Kane on 4/16/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Adjustable)

- (UIColor *)darkerColor;
- (UIColor *)darkenedByAmount:(CGFloat)amount;

@end
