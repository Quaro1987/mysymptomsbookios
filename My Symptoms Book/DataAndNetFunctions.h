//
//  DataAndNetFunctions.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class User, Reachability;

@interface DataAndNetFunctions : NSObject

//functions

-(UIAlertView *)alertStatus: (NSString *) alertBody andAlertTitle: (NSString *) alertTitle;

//data functions
-(NSString *)getSymptomCategoriesFilePath;

-(void)populateSymptomsDatabaseOnFirstLoad;

-(NSString *)getMySymptomsBookDatabasePath;

-(NSString *)getUserPassword;
//network functions
-(BOOL)internetAccess;

-(NSString *)serverUrlString;

-(NSNumberFormatter *) getNumberFormatter;

-(NSMutableURLRequest *) getURLRequestForURL:(NSURL *)requestURL andPostMessage:(NSString *)requestPostMessage;

-(void) takeToMainMenuForNavicationController:(UINavigationController *)thisNavigationController;

//return audio recorder
-(AVAudioRecorder *)getAudioRecorderForMessageFile:(NSString *)audioFileName;

//get the file name for the audio recorder
-(NSString *)getContactMessageFileNameForUser:(NSString *)patientUsername;

@end
