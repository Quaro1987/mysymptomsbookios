//
//  DataAndNetFunctions.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//
//  This class includes functions for a lot of data manipulation
//  and connectign to the web app functionalities of the ios app
//

#import "DataAndNetFunctions.h"
#import "User.h"

//website to get data
#define webServer @"http://mysymptomsbook.hol.es/index.php?r=user/user/"
@implementation DataAndNetFunctions

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
    
    //copy the id of the returned user in an nsinteger. If it's 0 no such user exists/wrong
    //password
    NSInteger userID = [(NSNumber *) [jsonReponseData objectForKey:@"id"] integerValue];
    NSLog(@"%d",userID);
    
    //check if log in was a success or failure
    if(userID==0)
    {
        //if fail, send error fail message
        NSString *fail = @"FAIL";
        return fail;
    }
    else
    {
        //if success, log in user
        User *user = [[User alloc] initWithId:[jsonReponseData objectForKey:@"id"] andUserName:[jsonReponseData objectForKey:@"username"] andUserType:[jsonReponseData objectForKey:@"userType"]];
        return user;
    }
}

-(UIAlertView *)alertStatus:(NSString *)alertBody andAlertTitle:(NSString *)alertTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                         message:alertBody
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    return alertView;
}


@end
