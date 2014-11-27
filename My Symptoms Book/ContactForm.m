//
//  ContactForm.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "ContactForm.h"
#import "DataAndNetFunctions.h"
#import "User.h"
#import "SSKeychain.h"

@implementation ContactForm

-(NSString *)sendMessage:(NSString *)message toUserWithID:(NSNumber *)patientID andAlsoeSendAsSMS:(BOOL)smsBoolean andAlsoSendRecordedMessage:(BOOL)recordedMessageBoolean
{
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    NSString *serverString = [dataAndNetController serverUrlString];
    //creatue url
    NSString *stringUrl = [serverString stringByAppendingString:@"contactPatientIOS"];
    
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    //get curent user username and password
    User *currentUser = [[User alloc]initWithSavedUser];
    
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    
    //get also send as sms string
    NSString *sms = [[NSString alloc] init];
    if(smsBoolean)
    {
        sms = @"YES";
    }
    else
    {
        sms = @"NO";
    }
    
    //get an array with the files path
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //copy documents path into an nstring
    NSString *documentsPath = [pathsArray objectAtIndex:0];
    //get path for recorded message
    NSString *soundFilePath = [documentsPath stringByAppendingPathComponent:@"sound.caf"];

    
    NSData *recordedMessageData = [[NSFileManager defaultManager] contentsAtPath:soundFilePath];
    //build post message
    //NSString *postMessage = [[NSString alloc] init];
    //postMessage = [NSString stringWithFormat:@"username=%@&password=%@&sendSMS=%@", currentUser.username, password, sms];
    NSLog(@"size of file: %d", [recordedMessageData length]);
    //create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:url];
    
    NSString *boundary = @"14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //-- Append data into posr url using following method
    NSMutableData *body = [NSMutableData data];
    
    
    //-- For Sending text
    
    //-- "firstname" is keyword form service
    //-- "first_name" is the text which we have to send
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"username"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",currentUser.username] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"password"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",password] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"sendSMS"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",sms] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //-- For sending image into service if needed (send image as imagedata)
    
    //-- "image_name" is file name of the image (we can set custom name)
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"file\"; filename=\"%@\"\r\n", @"sound.caf"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:recordedMessageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Sending data into server through URL
    [request setHTTPBody:body];
    
    //-- Getting response form server
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    return @"SUCCESS";
}

@end
