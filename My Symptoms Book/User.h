//
//  User.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

//properties
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userType;


//init method
-(id)initWithId: (NSString *) usrID andUserName: (NSString *) usrName
    andUserType: (NSString *) usrType;

@end
