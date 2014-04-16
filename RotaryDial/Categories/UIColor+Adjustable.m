//
//  UIColor+Adjustable.m
//  RotaryDial
//
//  Created by Dan Kane on 4/16/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "UIColor+Adjustable.h"

@implementation UIColor (Adjustable)

- (UIColor *)darkerColor
{
    return [self darkenedByAmount:0.2];
}

- (UIColor *)darkenedByAmount:(CGFloat)amount
{
    CGFloat adjustment = MAX(0.0, MIN(1.0, amount));
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MAX(r-adjustment, 0.0)
                               green:MAX(g-adjustment, 0.0)
                                blue:MAX(b-adjustment, 0.0)
                               alpha:a];
    }
    return nil;
}

@end
