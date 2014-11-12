//
//  User.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "User.h"
#import "SSKeychain.h"

//website to get data
#define webServer @"http://mysymptomsbook.hol.es/index.php?r=user/user/"

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

#pragma mark save/get user from NSUserDefaults functions

//store user object in NSUserDefaults
-(void)saveUserData:(User *) loggedUser
{
    //encode object
    NSData *encodedUserObject = [NSKeyedArchiver archivedDataWithRootObject:loggedUser];
    //init NSUserDefautls object
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //add object to nsuserdefaults and synchronize
    [defaults setObject:encodedUserObject forKey:@"user"];
    [defaults synchronize];
}

//get stored user from NSUserDefaults
-(id)initWithSavedUser
{
    self = [super init];
    
    if(self)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //get the saved user's encoded data
        NSData *encodedUserData = [defaults objectForKey:@"user"];
        //crate user object
        User *currentUser = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedUserData];
        self = currentUser;
        
    }
    return self;
}

#pragma mark log in/out functions

//logout user
-(void)logoutUser:(User *) currentUser
{
    //delete password from keychain
    [SSKeychain deletePasswordForService:@"MySymptomsBook" account:currentUser.username];
    
    //delete user object form nsuser defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user"];
}

//funciton to log in the user and return an error or success message
-(id)loginUserWithUsername:(NSString *) username andPassword:(NSString *) password
{
    //create post data string
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@",
                             username, password];
    //log message
    NSLog(@"Postdata: %@",postMessage);
    
    //create url post request will be made to
    NSURL *url =[[NSURL alloc] initWithString:[webServer stringByAppendingString:@"loginIOS"]];
    
    //turn post string into data object
    NSData *postData = [postMessage dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //post data legnth
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    //url request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //set up request properties
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //set up NSerror
    NSError *error = [[NSError alloc] init];
    
    // create url response
    NSURLResponse *response;
    
    //send post request to server
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //creaet NS dictionary and store result
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:nil];
    
    
    //init number formatter
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //set so the formatter doesn't reutrn decimals
    [numberFormatter setGeneratesDecimalNumbers:FALSE];
    
    //copy the id of the returned user in an nsnumber. If it's 0 no such user exists/wrong
    //password
       
    NSInteger usID = [(NSNumber *) [jsonReponseData objectForKey:@"id"] integerValue];
    //check if log in was a success or failure
    if(usID==0)
    {
        //if fail, send error fail message
        NSString *fail = @"NOUSER";
        return fail;
    }
    else
    {
        //if success, log in user
        //create temp attributes
        NSString *tempUserame = [jsonReponseData objectForKey:@"username"];
        NSString *tempEmail = [jsonReponseData objectForKey:@"email"];
        NSNumber *tempUserType = [numberFormatter numberFromString:[jsonReponseData objectForKey:@"userType"]];
        NSNumber *userID = [numberFormatter numberFromString:[jsonReponseData objectForKey:@"id"]];
        NSNumber *userStatus = [numberFormatter numberFromString:[jsonReponseData objectForKey:@"status"]];
        
        User *user = [[User alloc] initWithId:userID andUserName:tempUserame andUserType:tempUserType andEmail:tempEmail andStatus:userStatus];
        
        return user;
    }
}


@end
