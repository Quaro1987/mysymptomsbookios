//
//  DoctorUser.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/16/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "User.h"

@interface DoctorUser : User

//properties
@property (nonatomic, strong) NSString *doctorSpecialty;
@property (nonatomic, strong) NSString *aboutDoctor;

-(id)initWithId: (NSNumber *) usrID andUserName: (NSString *) usrName
    andUserType: (NSNumber *) usrType andEmail: (NSString *) usrEmail andStatus: (NSNumber *) usrStatus andFirstName:(NSString *) frName
    andLastName: (NSString *) lsName andDoctorSpecialty: (NSString *) drSpecialty andAboutDoctor: (NSString *) aboutDr;


//functions
-(NSMutableArray *)getDoctorsForUser:(NSString *) userName andPassword:(NSString *) password forSymptomWithSymptomCode:(NSString *) symptomCode;
@end
