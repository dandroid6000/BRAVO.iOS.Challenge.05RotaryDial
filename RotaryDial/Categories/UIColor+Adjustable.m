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
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        CGFloat rAdj = MAX(0.0, MIN(r, amount));
        CGFloat gAdj = MAX(0.0, MIN(g, amount));
        CGFloat bAdj = MAX(0.0, MIN(b, amount));
        return [UIColor colorWithRed:MAX(r-rAdj, 0.0)
                               green:MAX(g-gAdj, 0.0)
                                blue:MAX(b-bAdj, 0.0)
                               alpha:a];
    }
    return nil;
}

- (UIColor *)adjustedByMultiplier:(CGFloat)multiplier
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) {
        return [UIColor colorWithRed:MAX(r*multiplier, 0.0)
                               green:MAX(g*multiplier, 0.0)
                                blue:MAX(b*multiplier, 0.0)
                               alpha:a];
    }
    return nil;
}

@end
