//
//  DataAndNetFunctions.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class User, Reachability;

@interface DataAndNetFunctions : NSObject

//functions

-(UIAlertView *)alertStatus: (NSString *) alertBody andAlertTitle: (NSString *) alertTitle;

//data functions
-(NSString *)getSymptomCategoriesFilePath;

-(void)populateSymptomsDatabaseOnFirstLoad;

-(NSString *)getMySymptomsBookDatabasePath;


//network functions
-(BOOL)internetAccess;


@end
