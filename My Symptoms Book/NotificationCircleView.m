//
//  NotificationCircleView.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 1/4/15.
//  Copyright (c) 2015 Ioannis Pasmatzis. All rights reserved.
//

#import "NotificationCircleView.h"

@implementation NotificationCircleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // Set the circle fill color to red
    
    CGContextSetRGBFillColor(contextRef, 255, 0, 0, 1.0);
    
    // Fill the circle with the fill color
    CGContextFillEllipseInRect(contextRef, rect);
}



@end
