//
//  User.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userID, username, userType;

//init function
-(id)initWithId:(NSString *)usrID andUserName:(NSString *)usrName andUserType:(NSString *)usrType
{
    self = [super init];
    
    //if succesful init copy attributes and return self
    if(self)
    {
        userID = usrID;
        username = usrName;
        userType = usrType;
    }
    
    return self;
}

@end
