//
//  DataAndNetFunctions.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DataAndNetFunctions : NSObject

//functions
-(id)loginUserWithUsername:(NSString *) username andPassword:(NSString *) password;

-(UIAlertView *)alertStatus: (NSString *) alertBody andAlertTitle: (NSString *) alertTitle;
@end
