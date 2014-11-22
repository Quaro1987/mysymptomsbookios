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
-(NSString *)sendDoctorRequestForUser:(NSString *)usrName withPassword:(NSString *)pssWord ToDoctor:(NSNumber *)docID forSymptomhistoryWithID:(int)symHisID
{
    //create post data string
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&doctorID=%@&symptomHistoryID=%d",
                             usrName, pssWord, docID, symHisID];
    //log message
    NSLog(@"Postdata: %@",postMessage);
    
    //create url post request will be made to
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *serverString = [dataAndNetController serverUrlString];
    NSURL *url =[[NSURL alloc] initWithString:[serverString stringByAppendingString:@"sendDoctorRequestIOS"]];
    
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

    
    return @"SUCCESS";
}

//function to delete doctorrequest relation between users
-(NSString *)deleteRelationForUser:(NSString *)username withPassword:(NSString *)password withUserWithUserID:(NSNumber *)usrID
{
    //create post data string
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&relationID=%@", username, password, usrID];
    //log message
    NSLog(@"Postdata: %@",postMessage);
    
    //create url post request will be made to
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *serverString = [dataAndNetController serverUrlString];
    NSURL *url =[[NSURL alloc] initWithString:[serverString stringByAppendingString:@"removeContactIOS"]];
    
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
    

    
    return @"SUCCESS";
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
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&userID=%@&reply=%@", currentUser.username, password, usrID, reply];
    //log message

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
    
    return @"SUCCESS";
}

@end
