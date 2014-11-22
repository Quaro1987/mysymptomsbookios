//
//  User.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "User.h"
#import "SSKeychain.h"
#import "DataAndNetFunctions.h"


@implementation User

@synthesize userID, username, userType, status, email, firstName, lastName;

//init function
-(id)initWithId:(NSNumber *)usrID andUserName:(NSString *)usrName andUserType:(NSNumber *)usrType andEmail: (NSString *) usrEmail andStatus: (NSNumber *) usrStatus
 andFirstName: (NSString *)fName andLastName:(NSString *)lname;
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
        firstName = fName;
        lastName = lname;
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
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
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
        self.firstName = [decoder decodeObjectForKey:@"firstName"];
        self.lastName = [decoder decodeObjectForKey:@"lastName"];
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
-(void)logoutUser
{
    //delete password from keychain
    [SSKeychain deletePasswordForService:@"MySymptomsBook" account:self.username];
    
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
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *serverString = [dataAndNetController serverUrlString];
    NSURL *url =[[NSURL alloc] initWithString:[serverString stringByAppendingString:@"loginIOS"]];
    
    //url request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //set up NSerror
    NSError *error = [[NSError alloc] init];
    
    // create url response
    NSURLResponse *response;
    
    //send post request to server
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //creaet NS dictionary and store result
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:nil];
    
    
    //init number formatter
    NSNumberFormatter *numberFormatter = [dataAndNetController getNumberFormatter];
        
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
        
        User *user = [[User alloc] initWithId:userID andUserName:tempUserame andUserType:tempUserType andEmail:tempEmail andStatus:userStatus andFirstName:NULL andLastName:NULL];
        
        return user;
    }
}

-(NSMutableArray *)getUsersDoctorHasRelationsWith
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    NSString *serverString = [dataAndNetController serverUrlString];
    //creatue url
    NSString *stringUrl = [serverString stringByAppendingString:@"getDoctorRelationsIOS"];
    
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    //get curent user username and password
    User *currentUser = [[User alloc]initWithSavedUser];
    
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    
    //build post message
    NSString *postMessage = [[NSString alloc] init];
    postMessage = [NSString stringWithFormat:@"username=%@&password=%@", currentUser.username, password];
    
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //json data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //pass doctor user objects into an array
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    //create array that will keep the doctor patient users objects
    NSMutableArray *patientsArray = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //set so the formatter doesn't reutrn decimals
    [numberFormatter setGeneratesDecimalNumbers:FALSE];
    
    for (NSDictionary *userObject in jsonReponseData)
    {
        NSString *tempFirstName = [userObject valueForKeyPath:@"jsonDataSource.relations.profile.firstname"];
        NSString *tempLastName = [userObject valueForKeyPath:@"jsonDataSource.relations.profile.lastname"];
        NSString *tempUsername = [userObject valueForKeyPath:@"jsonDataSource.attributes.username"];
        NSString *tempEmail = [userObject valueForKeyPath:@"jsonDataSource.attributes.email"];
        NSNumber *tempUserID = [numberFormatter numberFromString:[userObject valueForKeyPath:@"jsonDataSource.attributes.id"]];
        NSNumber *tempUserStatus = [numberFormatter numberFromString:[userObject valueForKeyPath:@"jsonDataSource.attributes.status"]];
        NSNumber *tempUserType = [numberFormatter numberFromString:[userObject valueForKeyPath:@"jsonDataSource.attributes.userType"]];
        //create temp doctor user
        User *aPatient = [[User alloc] initWithId:tempUserID andUserName:tempUsername andUserType:tempUserType andEmail:tempEmail andStatus:tempUserStatus andFirstName:tempFirstName andLastName:tempLastName];
        //add doctor to aray
        [patientsArray addObject:aPatient];
    }
    
    return patientsArray;
}

@end
