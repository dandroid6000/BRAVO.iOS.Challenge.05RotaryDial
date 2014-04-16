//
//  UIColor+Adjustable.h
//  RotaryDial
//
//  Created by Dan Kane on 4/16/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Adjustable)

/**
 * @return A slightly darker color than the receiver
 */
- (UIColor *)darkerColor;

/**
 * @param amount The amount by which to darken the receiver, on the interval [0,1]
 *
 * @return A UIColor based to the receiver that's been darkened by the given amount
 */
- (UIColor *)darkenedByAmount:(CGFloat)amount;

/**
 * @param multiplier The amount by which to multiply the RGB values
 *
 * @return A UIColor based on the receiver, adjusted by multiplying the RGB values by the given multiplier
 */
- (UIColor *)adjustedByMultiplier:(CGFloat)multiplier;

@end
