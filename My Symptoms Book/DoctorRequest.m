//
//  DoctorRequest.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/19/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "DoctorRequest.h"
#import "DataAndNetFunctions.h"
#import "User.h"
#import "SSKeychain.h"

@implementation DoctorRequest

@synthesize doctorRequestID, userID, doctorID, doctorAccepted, symptomHistoryID, newSymptomAdded;

//init functions
-(id)initWithDoctorRequestID:(int)docRequestID andUserID:(int)usID andDoctorID:(int)docID andDoctorAcceptedFlag:(int)docAccepted andSymptomhistoryID:(int)symHistoryID andNewSymptomAddedFlag:(int)newSymAdded
{
    self = [super init];
    
    if(self)
    {
        self.doctorRequestID = docRequestID;
        self.userID = usID;
        self.doctorID = docID;
        self.doctorAccepted = docAccepted;
        self.symptomHistoryID = symHistoryID;
        self.newSymptomAdded = newSymAdded;
    }
    
    return self;
}

//function to send a doctor request for the current user
-(NSString *)sendDoctorRequestToDoctorWithID:(NSNumber *)docID forSymptomhistoryWithID:(int)symHisID
{
    //create url post request will be made to
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *serverString = [dataAndNetController serverUrlString];
    NSURL *url =[[NSURL alloc] initWithString:[serverString stringByAppendingString:@"sendDoctorRequestIOS"]];
    
    //get username and password encoded
    User *currentUser = [[User alloc] initWithSavedUser];
    NSString *password = [dataAndNetController getUserPassword];
    
    //create post data string
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&doctorID=%@&symptomHistoryID=%d",
                             [currentUser getEncodedUsername], password, docID, symHisID];
    //log message
    NSLog(@"Postdata: %@",postMessage);
    
    //url request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //set up NSerror
    NSError *error = [[NSError alloc] init];
    
    // create url response
    NSURLResponse *response;
    
    //send post request to server
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //check if the app contacted with server
    if([urlData length] == 0)
    {
        //log the error and show error message
        NSLog(@"ERROR no contact with server");
        [dataAndNetController failedToContactServerShowAlertView];
        return @"FAILURE";
    }
    else
    {
        return @"SUCCESS";
    }

}

//function to delete doctorrequest relation between users
-(NSString *)deleteRelationBetweenUserAndUserWithUserID:(NSNumber *)usrID
{
    //create url post request will be made to
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *serverString = [dataAndNetController serverUrlString];
    NSURL *url =[[NSURL alloc] initWithString:[serverString stringByAppendingString:@"removeContactIOS"]];
    
    //get username and password encoded
    User *currentUser = [[User alloc] initWithSavedUser];
    NSString *password = [dataAndNetController getUserPassword];
    
    //create post data string
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&relationID=%@", [currentUser getEncodedUsername], password, usrID];
    //log message
    NSLog(@"Postdata: %@",postMessage);
    
    //url request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //set up NSerror
    NSError *error = [[NSError alloc] init];
    
    // create url response
    NSURLResponse *response;
    
    //send post request to server
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //check if the app contacted with server
    if([urlData length] == 0)
    {
        //log the error and show error message
        NSLog(@"ERROR no contact with server");
        [dataAndNetController failedToContactServerShowAlertView];
        return @"FAILURE";
    }
    else
    {
        return @"SUCCESS";
    }

}

//reply to request function
-(NSString *)replyToRequestFromUserWithID:(NSNumber *) usrID withReply:(NSString *)reply
{
    //create url post request will be made to
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *serverString = [dataAndNetController serverUrlString];
    NSURL *url =[[NSURL alloc] initWithString:[serverString stringByAppendingString:@"replyToRequestIOS"]];
    
    //get user and password
    User *currentUser = [[User alloc] initWithSavedUser];
    NSString *password = [dataAndNetController getUserPassword];
    
    //create post data string
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&userID=%@&reply=%@", [currentUser getEncodedUsername], password, usrID, reply];
    //log message

    //url request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //set up NSerror
    NSError *error = [[NSError alloc] init];
    
    // create url response
    NSURLResponse *response;
    
    //send post request to server
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //check if the app contacted with server
    if([urlData length] == 0)
    {
        //log the error and show error message
        NSLog(@"ERROR no contact with server");
        [dataAndNetController failedToContactServerShowAlertView];
        return @"FAILURE";
    }
    else
    {
        return @"SUCCESS";
    }

}

//function to get the ids of the users with new symptoms
-(NSMutableArray *)getIDsOfPatientUsersWithNewSymptomsAdded
{
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    NSString *serverString = [dataAndNetController serverUrlString];
    //creatue url
    NSString *stringUrl = [serverString stringByAppendingString:@"getPatientIDsWithNewSymptomsIOS"];
    
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    //get curent user username and password
    User *currentUser = [[User alloc]initWithSavedUser];
    
    NSString *password = [dataAndNetController getUserPassword];
    
    //build post message
    NSString *postMessage = [[NSString alloc] init];
    postMessage = [NSString stringWithFormat:@"username=%@&password=%@", [currentUser getEncodedUsername], password];
    
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //json data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //create array that will keep the doctor patient users objects
    NSMutableArray *patientUsersIDsArray = [[NSMutableArray alloc] init];
    
    //check if the app contacted with server
    if([responseData length] == 0)
    {
        //log the error and show error message
        NSLog(@"ERROR no contact with server to check which users have new symptoms");
        //[dataAndNetController failedToContactServerShowAlertView];
    }
    else
    {
        //get json response
        NSMutableArray *jsonReponseData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //set so the formatter doesn't reutrn decimals
        [numberFormatter setGeneratesDecimalNumbers:FALSE];
        
        //loop through result ids, turn them into a number and add them in the array
        for(NSString *patientID in jsonReponseData)
        {
            [patientUsersIDsArray addObject:[numberFormatter numberFromString:patientID]];
        }
    }
    
    return patientUsersIDsArray;
}

@end
