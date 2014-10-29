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

//init method
-(id)initWithId: (NSNumber *) usrID andUserName: (NSString *) usrName
    andUserType: (NSNumber *) usrType andEmail: (NSString *) usrEmail andStatus: (NSNumber *) usrStatus;

//encoding/decoding methods
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

//save / get object from nsuserdefaults

@end
