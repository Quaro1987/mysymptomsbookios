//
//  DoctorSymptomSpecialty.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/20/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "DoctorSymptomSpecialty.h"
#import "User.h"
#import "DataAndNetFunctions.h"

@implementation DoctorSymptomSpecialty

#pragma mark functions

//function to delete symptom specialty for doctor user
-(NSString *)deleteDoctorSymptomSpecialtyWithSymptomCode:(NSString *) symptomCode
{
    //get current user and his password
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *password = [dataAndNetController getUserPassword];
    User *currentUser = [[User alloc] initWithSavedUser];
    
    
    //get server url
    NSString *urlString = [[dataAndNetController serverUrlString] stringByAppendingString:@"deleteSymptomSpecialtyIOS"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    //build post message
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&symptomCode=%@", currentUser.username, password, symptomCode];
    
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //json data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //pass result into dictionary
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    
    return @"SUCCESS";
}

//function for when the user wants to add a new symptom specialty
-(NSString *)addDoctorSymptomSpecialtyWithSymptomCode:(NSString *) symptomCode
{
    //get current user and his password
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    NSString *password = [dataAndNetController getUserPassword];
    User *currentUser = [[User alloc] initWithSavedUser];
    
    
    //get server url
    NSString *urlString = [[dataAndNetController serverUrlString] stringByAppendingString:@"addSymptomSpecialtyIOS"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    //build post message
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&symptomCode=%@", currentUser.username, password, symptomCode];
  
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //json data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //pass result into dictionary
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    
    return @"SUCCESS";

}

@end
