//
//  Symptomhistory.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/3/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Symptom, User, UIColor;

@interface Symptomhistory : NSObject

@property (nonatomic, assign) int symptomHistoryID;
@property (nonatomic, strong) NSString *symptomUsername;
@property (nonatomic, strong) NSString *symptomCode;
@property (nonatomic, strong) NSString *symptomTitle;
@property (nonatomic, strong) NSString *dateSymptomFirstSeen;
@property (nonatomic, strong) NSString *dateSymptomAdded;
@property (nonatomic, strong) NSString *symptomFlag;
@property (nonatomic, strong) NSDate *datedAddedInNSDateFormat;

//init functions
-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded andSymptomFlag: (NSString *) flag andSymptomHistoryID: (int) symHistoryID;

-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded;

//manage locally stored symptom history objects
-(NSMutableArray *)getSavedSymptomsForUser;

-(void)clearDatabaseOfSavedSymptomsForUser:(NSString *)username;

-(NSString *)batchPostSavedSymptoms;

-(NSString *)getInfoOnSavedSymptomsWhileOffline;

//add symptom functions
-(NSString *)addForUserTheSymptom:(NSString *) symptomTitle withSymptomCode:(NSString *) symptomCode andDateFirstSeen:(NSString *) theDateSymptomFirstSeen;

//get the user's symptom history
-(NSMutableArray *) getSymptomhistoryForUser: (User *)requestedUser;

//get specific symptom history from server for doctor
-(id)getSymptomhistoryTheDoctorWasAddedForByUserWithID:(NSNumber *)usrID;

//characterization label functions
-(UIColor *)getCharacterizationLabelColor;

-(NSString *)getCharacterizationLabelText;

//update characterization data
-(void)updateCharacterizationByDoctor;

@end
