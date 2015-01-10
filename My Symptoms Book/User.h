//
//  User.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

//properties
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *userType;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;


//init method
-(id)initWithId: (NSNumber *) usrID andUserName: (NSString *) usrName
    andUserType: (NSNumber *) usrType andEmail: (NSString *) usrEmail
      andStatus: (NSNumber *) usrStatus andFirstName: (NSString *)fName andLastName:(NSString *)lname;

//encoding/decoding methods
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

-(NSString *)getEncodedUsername;

//save / init user from nsuserdefaults
-(id)initWithSavedUser;

-(void)saveUserData:(User *) loggedUser;

//log in / register user functions

-(void)logoutUser;

-(id)loginUserWithUsername:(NSString *) username andPassword:(NSString *) password;

-(NSString *)registerNewUserWithUsername:(NSString *) registerUsername andPassword:(NSString *) registerPassword andFirstName: (NSString *) registerFirstName
                             andLastName: (NSString *) registerLastName andEmail:(NSString *) registerEmail andBirthdate:(NSString *) registerBirthDate
                          andPhoneNumber: (NSString *) registerPhoneNumber andSpecialty:(NSString *) registerSpecialty andUserType:(NSNumber *) registerUserType;

//user requests data
-(NSMutableArray *)getUsersDoctorHasRelationOfType:(NSString *)relationType;

@end
