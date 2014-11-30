//
//  DoctorRequest.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/19/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorRequest : NSObject

//properties
@property (nonatomic, assign) int doctorRequestID;
@property (nonatomic, assign) int doctorID;
@property (nonatomic, assign) int userID;
@property (nonatomic, assign) int doctorAccepted;
@property (nonatomic, assign) int symptomHistoryID;
@property (nonatomic, assign) int newSymptomAdded;

//functions
-(id)initWithDoctorRequestID: (int) docRequestID andUserID: (int) usID andDoctorID: (int) docID andDoctorAcceptedFlag: (int) docAccepted
         andSymptomhistoryID: (int) symHistoryID andNewSymptomAddedFlag: (int) newSymAdded;

-(NSString *)sendDoctorRequestToDoctorWithID: (NSNumber *) docID forSymptomhistoryWithID: (int) symHisID;

-(NSString *)deleteRelationBetweenUserAndUserWithUserID:(NSNumber *) usrID;

-(NSString *)replyToRequestFromUserWithID:(NSNumber *) usrID withReply:(NSString *)reply;

-(NSMutableArray *)getIDsOfPatientUsersWithNewSymptomsAdded;

@end
