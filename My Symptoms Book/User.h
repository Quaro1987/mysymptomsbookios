//
//  User.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

//properties variables
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

//encoding/decoding methods so the user object can be stored in nsuserdefaults
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

//encode the user's username so it can be posted to the server via HTTP
-(NSString *)getEncodedUsername;

//save / init user from nsuserdefaults
-(id)initWithSavedUser;

//save the user data after a successful log in to the iOS device
-(void)saveUserData:(User *) loggedUser;

#pragma mark log in / register user functions

//log out function
-(void)logoutUser;

//log in function
-(id)loginUserWithUsername:(NSString *) username andPassword:(NSString *) password;

//register new user function
-(NSString *)registerNewUserWithUsername:(NSString *) registerUsername andPassword:(NSString *) registerPassword andFirstName: (NSString *) registerFirstName
                             andLastName: (NSString *) registerLastName andEmail:(NSString *) registerEmail andBirthdate:(NSString *) registerBirthDate
                          andPhoneNumber: (NSString *) registerPhoneNumber andSpecialty:(NSString *) registerSpecialty andUserType:(NSNumber *) registerUserType;

//returns an array of user objects with all the users the current user has a relation with (realtionType == @"relations")
//or has requests from (relationType == @"requests")
-(NSMutableArray *)getUsersDoctorHasRelationOfType:(NSString *)relationType;

@end
