//  CLSpotCircle
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import "CLSpotCircle.h"

@implementation CLSpotCircle

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGRect rct = self.bounds;
//    rct.origin.x += 1;
//    rct.origin.y += 1;
//    rct.size.width -= 2;
//    rct.size.height -= 2;
//    
//    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
//    CGContextStrokeEllipseInRect(context, rct);
    
    CGRect rct = self.bounds;
    rct.origin.x = 0.3*rct.size.width;
    rct.origin.y = 0.3*rct.size.height;
    rct.size.width *= 0.3;
    rct.size.height *= 0.3;
    
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextSetLineWidth(context, 5);
    CGContextStrokeEllipseInRect(context, rct);

    
    self.alpha = 1;
    [UIView animateWithDuration:kCLEffectToolAnimationDuration
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

@end
