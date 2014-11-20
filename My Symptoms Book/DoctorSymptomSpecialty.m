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
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    NSString *password = [dataController getUserPassword];
    User *currentUser = [[User alloc] initWithSavedUser];
    
    
    //get server url
    NSString *urlString = [[dataController serverUrlString] stringByAppendingString:@"deleteSymptomSpecialtyIOS"];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    //build post message
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&symptomCode=%@", currentUser.username, password, symptomCode];
    
    //turn post message to nsdata
    NSData *postData = [postMessage dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //get post legnth
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    //create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //set up request attributes
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Legnth"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
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
