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
//@property (nonatomic, strong) NS

//init method
-(id)initWithId: (NSNumber *) usrID andUserName: (NSString *) usrName
    andUserType: (NSNumber *) usrType andEmail: (NSString *) usrEmail andStatus: (NSNumber *) usrStatus;

//encoding/decoding methods
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

//save / init user from nsuserdefaults
-(id)initWithSavedUser;

-(void)saveUserData:(User *) loggedUser;

//log in user functions

-(void)logoutUser:(User *) currentUser;

-(id)loginUserWithUsername:(NSString *) username andPassword:(NSString *) password;

@end
