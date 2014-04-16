//
//  NRDRotaryDial.h
//  RotaryDial
//
//  Created by Dan Kane on 4/16/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NRDRotaryDialDelegate <NSObject>

@optional
- (void)leftSegmentTapped;
- (void)rightSegmentTapped;

@end

@interface NRDRotaryDial : UIControl

@property (nonatomic, assign) NSUInteger thickness;
@property (nonatomic, strong) UIColor *ringColor;
@property (nonatomic, strong) UIColor *handleColor;

@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat value;

@property (nonatomic, weak) id<NRDRotaryDialDelegate> delegate;

- (id)initWithRadius:(NSUInteger)radius
           thickness:(NSUInteger)thickness;

@end
