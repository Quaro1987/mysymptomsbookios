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
#import <MobileCoreServices/MobileCoreServices.h>

@implementation ContactForm

-(NSString *)sendMessage:(NSString *)message toUserWithID:(NSNumber *)patientID andAlsoeSendAsSMS:(BOOL)smsBoolean andAlsoSendRecordedMessage:(BOOL)recordedMessageBoolean
            withFileName:(NSString *) fileNameString
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
    NSString *sendSMS = [[NSString alloc] init];
    if(smsBoolean)
    {
        sendSMS = @"YES";
    }
    else
    {
        sendSMS = @"NO";
    }
    //get file attached string
    NSString *recordedMessageExists = [[NSString alloc] init];
    if(recordedMessageBoolean)
    {
        recordedMessageExists = @"YES";
    }
    else
    {
        recordedMessageExists = @"NO";
    }
    
    NSDictionary *params = @{@"username" : currentUser.username,
                             @"password" : password,
                             @"patientID" : patientID,
                             @"sendSMS" : sendSMS,
                             @"message" : message,
                             @"attachFile" : recordedMessageExists};
    
    //get an array with the files path
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //copy documents path into an nstring
    NSString *documentsPath = [pathsArray objectAtIndex:0];
    //get path for recorded message
    NSString *soundFilePath = [documentsPath stringByAppendingPathComponent:fileNameString];
    
    //create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *boundary = [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //set request http method and url
    [request setHTTPMethod:@"POST"];
    [request setURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Append parameters data into post url
    NSMutableData *body = [NSMutableData data];
    
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // attach file if user has added one
    if(recordedMessageBoolean)
    {
        //get filename
        NSString *filename  = [soundFilePath lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:soundFilePath];
        NSString *mimetype  = [self mimeTypeForPath:soundFilePath];
        //append file to post body
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"messageFile", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
   //set request's body
    [request setHTTPBody:body];
    //post data legnth
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    // create url response
    NSURLResponse *response;
    //set up NSerror
    NSError *error = [[NSError alloc] init];
    
    //-- Getting response form server
    //send update to server
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //pass reply into an NSDictionary
    NSDictionary *jsonReponseData = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    
    NSString *stringReply =  (NSString *)[jsonReponseData objectForKey:@"thisReply"];
    
    
    return @"SUCCESS";
}

- (NSString *)mimeTypeForPath:(NSString *)path
{
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
   
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
   
    
    CFRelease(UTI);
    
    return mimetype;
}

@end
