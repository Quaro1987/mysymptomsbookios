//
//  DoctorRequest.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/19/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "DoctorRequest.h"
#import "DataAndNetFunctions.h"

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

    
    return @"SUCCESS";
}

//function to delete doctorrequest relation between users
-(NSString *)deleteRelationForUser:(NSString *)username withPassword:(NSString *)password withUserWithUserID:(NSNumber *)userID
{
    //create post data string
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&relationID=%@", username, password, userID];
    //log message
    NSLog(@"Postdata: %@",postMessage);
    
    //create url post request will be made to
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *serverString = [dataAndNetController serverUrlString];
    NSURL *url =[[NSURL alloc] initWithString:[serverString stringByAppendingString:@"removeContactIOS"]];
    
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
    

    
    return @"SUCCESS";
}

@end
