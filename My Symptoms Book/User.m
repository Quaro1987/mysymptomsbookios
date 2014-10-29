//
//  User.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userID, username, userType, status, email;

//init function
-(id)initWithId:(NSNumber *)usrID andUserName:(NSString *)usrName andUserType:(NSNumber *)usrType andEmail: (NSString *) usrEmail andStatus: (NSNumber *) usrStatus;
{
    self = [super init];
    
    //if succesful init copy attributes and return self
    if(self)
    {
        userID = usrID;
        username = usrName;
        userType = usrType;
        status = usrStatus;
        email = usrEmail;
    }
    
    return self;
}

#pragma mark encoding/decoding functions

//encode object method

-(void)encodeWithCoder:(NSCoder *)encoder
{
    //encode object properties
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.userType forKey:@"userType"];
    [encoder encodeObject:self.status forKey:@"status"];
    [encoder encodeObject:self.email forKey:@"email"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    //decode attributes
    self = [super init];
    
    if(self)
    {
        self.userID = [decoder decodeObjectForKey:@"userID"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.userType = [decoder decodeObjectForKey:@"userType"];
        self.status = [decoder decodeObjectForKey:@"status"];
        self.email = [decoder decodeObjectForKey:@"email"];
    }
    
    return self;
}
@end
