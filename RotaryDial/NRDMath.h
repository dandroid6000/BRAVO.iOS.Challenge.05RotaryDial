//
//  NRDMath.h
//  RotaryDial
//
//  Created by Dan Kane on 4/16/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#ifndef RotaryDial_NRDMath_h
#define RotaryDial_NRDMath_h

/**
 * Normalizes an angle to the interval [0,2π)
 *
 * @param angle The angle in radians
 * 
 * @return An equivalent angle in radians, on the interval [0,2π)
 */
static inline CGFloat normalize_angle(CGFloat angle)
{
    // Ensure [0,2π)
    while (angle < 0) {
        angle += 2*M_PI;
    }
    while (angle >= 2*M_PI) {
        angle -= 2*M_PI;
    }
    return angle;
}

/**
 * Returns the angle to the given point using the given center as its origin
 * 
 * @param point The point in view coordinates
 * @param center The origin to base the angle on, in view coordinates
 * 
 * @return An angle in radians, on the interval [0,2π)
 */
static inline CGFloat angle_for_point(CGPoint point, CGPoint center)
{
    CGPoint point_to_center = CGPointMake(point.x - center.x, point.y - center.y);
    CGFloat angle = atan2f(point_to_center.y, point_to_center.x);
    return normalize_angle(angle);
}

/**
 * Returns the rotation angle for a given CGAffineTransform matrix
 *
 * @param transform A CGAffineTransform matrix
 *
 * @return An angle in radians, on the interval [0,2π)
 */
static inline CGFloat angle_from_transform(CGAffineTransform transform)
{
    CGFloat angle = atan2(transform.b, transform.a);
    return normalize_angle(angle);
}

/**
 * Rounds a value to a given precision (e.g. 3.1415926 -> 3.1416)
 *
 * @param value The CGFloat to be rounded
 * @param precision The number of decimal places to include
 * 
 * @return CGFloat
 */
static inline CGFloat round_to_precision(CGFloat value, NSUInteger precision)
{
    CGFloat factor = pow(10, precision);
    return floor(value * factor + 0.5) / factor;
}

#endif
