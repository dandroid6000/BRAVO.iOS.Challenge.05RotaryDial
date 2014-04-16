//
//  NRDRotaryDialViewController.m
//  RotaryDial
//
//  Created by Dan Kane on 3/20/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDRotaryDialViewController.h"
#import "NRDRotaryDial.h"
#import "UIColor+Adjustable.h"
#import "NRDMath.h"

@interface NRDRotaryDialViewController () <NRDRotaryDialDelegate>

@property (strong, nonatomic) NRDRotaryDial *dial;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation NRDRotaryDialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.dial = [[NRDRotaryDial alloc] initWithRadius:120 thickness:40];
//    self.dial.ringColor = [UIColor yellowColor];
//    self.dial.handleColor = [UIColor orangeColor];
    self.dial.minimumValue = 0;
    self.dial.maximumValue = 100;
    [self.dial addTarget:self action:@selector(dialValueDidChange:) forControlEvents:UIControlEventValueChanged];
    self.dial.delegate = self;
    [self.view addSubview:self.dial];
    self.dial.center = self.view.center;
    
    self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)self.dial.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Handlers

- (void)dialValueDidChange:(id)sender
{
    self.valueLabel.text = [NSString stringWithFormat:@"%d", (int)self.dial.value];
//    self.dial.ringColor = [[UIColor yellowColor] darkenedByAmount:self.dial.value/100.0];
}

#pragma mark NRDRotaryDialDelegate Methods

- (void)leftSegmentTapped
{
    self.dial.value = [self nextTwelfthClockwise:NO];
}

- (void)rightSegmentTapped
{
    self.dial.value = [self nextTwelfthClockwise:YES];
}

#pragma mark - Helper Methods

- (CGFloat)nextTwelfthClockwise:(BOOL)clockwise
{
    // Safety catch!
    if (self.dial.maximumValue == self.dial.minimumValue) {
        return 0.0;
    }
    
    CGFloat percent = (self.dial.value - self.dial.minimumValue)/(self.dial.maximumValue - self.dial.minimumValue);
    // Using 3 decimal precision due to fuzziness
    CGFloat ofTwelve = round_to_precision(percent * 12, 3);
    NSInteger nextTwelfth = (NSInteger)ofTwelve;
    if (clockwise || nextTwelfth == ofTwelve) {
        if (clockwise) {
            // Go to the next one
            nextTwelfth += 1;
            if (nextTwelfth >= 12) {
                nextTwelfth -= 12;
            }
        } else {
            // Go to the previous one
            nextTwelfth -= 1;
            if (nextTwelfth < 0) {
                nextTwelfth += 12;
            }
        }
    }
    percent = nextTwelfth/12.0;
    return self.dial.minimumValue + percent * (self.dial.maximumValue - self.dial.minimumValue);
}

@end
