//
//  Symptomhistory.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/3/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Symptom;

@interface Symptomhistory : NSObject

@property (nonatomic, strong) NSString *symptomUsername;
@property (nonatomic, strong) NSString *symptomCode;
@property (nonatomic, strong) NSString *symptomTitle;
@property (nonatomic, strong) NSString *dateSymptomFirstSeen;
@property (nonatomic, strong) NSString *dateSymptomAdded;
@property (nonatomic, strong) NSString *symptomFlag;
@property (nonatomic, strong) NSMutableArray *userSymptomhistory;

//init functions
-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded andSymptomFlag: (NSString *) flag;

-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded;

//manage locally stored symptom history objects
-(NSMutableArray *)getSavedSymptomsForUser:(NSString *)userName;

-(void)clearDatabaseOfSavedSymptomsForUser:(NSString *)username;

-(NSString *)batchPostSavedSymptoms;

-(NSString *)getInfoOnSavedSymptomsWhileOffline;

//add symptom functions
-(NSString *)addSymptomForUser:(NSString *) username withPassword:(NSString *) password theSymptom:(NSString *) symptomTitle withSymptomCode:(NSString *) symptomCode andDateFirstSeen:(NSString *) dateSymptomFirstSeen;

//get the user's symptom history
-(NSMutableArray *)getSymptomhistoryForUser: (NSString *) username andWithPassword: (NSString *) password;

@end
