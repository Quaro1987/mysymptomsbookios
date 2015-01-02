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
#import "SSKeychain.h"
#import "FMDB.h"
#import "Reachability.h"
#import "Symptomhistory.h"
#import "DoctorUserMainViewController.h"
//website to get data
#define webServer @"http://mysymptomsbook.hol.es/index.php?r=user/user/"
@implementation DataAndNetFunctions


//alert message
-(UIAlertView *)alertStatus:(NSString *)alertBody andAlertTitle:(NSString *)alertTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                         message:alertBody
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    return alertView;
}

//return number formatter to change strings into ints
-(NSNumberFormatter *)getNumberFormatter
{
    //init number formatter
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //set so the formatter doesn't reutrn decimals
    [numberFormatter setGeneratesDecimalNumbers:FALSE];
    
    return numberFormatter;
}

#pragma mark database/file manipulation functions

//function to get the path of the file with all the symptom categories
-(NSString *)getSymptomCategoriesFilePath
{
    //get an array with the files path
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //copy documents path into an nstring
    NSString *documentsPath = [pathsArray objectAtIndex:0];
    //return the path of the plist file with the symptomc ategories
    return [documentsPath stringByAppendingPathComponent:@"symptomCategories.plist"];
}

//function to get the database path
-(NSString *)getMySymptomsBookDatabasePath
{
    //get an array with the files path
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //copy documents path into an nstring
    NSString *documentsPath = [pathsArray objectAtIndex:0];
    //return the path of the plist file with the symptomc ategories
    NSString *thisDatabasePath = [documentsPath stringByAppendingPathComponent:@"mySymptomsBook.sqlite"];
    return thisDatabasePath;
}

//function to populate the sql database with symptoms
-(void)populateSymptomsDatabaseOnFirstLoad
{

    //get the path of the symptomsList.rtf file
    NSString *symptomsListFile = @"symptomsList";
    NSString *symptomsListPath = [[NSBundle mainBundle] pathForResource:symptomsListFile ofType:@"txt"];
    

    //copy the symptomsdata into a string
    NSString *symptomsDataString = [NSString stringWithContentsOfFile:symptomsListPath encoding:NSUTF8StringEncoding error:NULL];
    
    //copy symptom values intoa na rary
    NSArray *symptomsValuesArray = [symptomsDataString componentsSeparatedByString:@"),"];
    
    
    //return the path of the database file
    NSString *dataBasePath = [self getMySymptomsBookDatabasePath];

    //create database
    FMDatabase *database = [FMDatabase databaseWithPath:dataBasePath];
    
    //open db
    if(![database open])
    {
        return;
    }
    
    //create table
    NSString *createSymptomsTableQuery = @"CREATE TABLE IF NOT EXISTS tbl_symptoms (symptomCode varchar(15) NOT NULL PRIMARY KEY,title varchar(255) NOT NULL,shortTitle varchar(255) NOT NULL,inclusions varchar(255) NOT NULL,exclusions varchar(255) NOT NULL,symptomCategory varchar(255) NOT NULL);";
    if(![database executeUpdate:createSymptomsTableQuery])
    {
        return;
    }
    
    //create temporary symptoms history table
    NSString *createTempSymptomsHistoryTableQuery = @"CREATE TABLE IF NOT EXISTS tbl_tempSymptomhistory (symptomCode varchar(15) NOT NULL ,title varchar(255) NOT NULL,dateSymptomFirstSeen varchar(255) NOT NULL, dateSymptomAdded varchar(255) NOT NULL, username varchar(255) NOT NULL);";
    if(![database executeUpdate:createTempSymptomsHistoryTableQuery])
    {
        return;
    }
    
    //insert symptoms into table
    NSString *symptomsInsertQuery = @"INSERT INTO tbl_symptoms (symptomCode, title, shortTitle, inclusions, exclusions, symptomCategory) VALUES ";
    
    //for loop through symptomsValuesArray
    for (int i=0; i<[symptomsValuesArray count]; i++)
    {
        //create query string with insert command
        NSMutableString *insertString = [[NSMutableString alloc] initWithString:symptomsInsertQuery];
        //append the specific symptoms data
        [insertString appendString:[symptomsValuesArray objectAtIndex:i]];
        [insertString appendString:@");"];
        //insert row into database tbl_symptoms table
        [database executeUpdate:insertString];
    }
    
    //close database once complete
    [database close];
}

//gets saved user's password
-(NSString *)getUserPassword
{
    //get current user
    User *currentUser = [[User alloc] initWithSavedUser];
    //copy his password into a string
    NSString *passwordString = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    //encode password
    NSString *encodedPasswordString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                           NULL,
                                                                                           (CFStringRef)passwordString,
                                                                                           NULL,
                                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                           kCFStringEncodingUTF8 );
    
    //return password
    return encodedPasswordString;
}

#pragma mark network functions

//check if there is internet access
-(BOOL)internetAccess
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus *networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
         NSLog(@"There is no internet connection");
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
}

//return server string
-(NSString *)serverUrlString
{
    return webServer;
}

//return server request
-(NSMutableURLRequest *)getURLRequestForURL:(NSURL *)requestURL andPostMessage:(NSString *)requestPostMessage
{
    //turn post string into data object
    NSData *postData = [requestPostMessage dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //post data legnth
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    //url request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //set up request properties
    [request setURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //return request
    return request;
}

//function to take the user to the main menu if there is no internet access during an operation that requires it
-(void) takeToMainMenuForNavicationController:(UINavigationController *)thisNavigationController
{
    UIViewController *doctorMainMenuController = [thisNavigationController.viewControllers objectAtIndex:1];
    //take to main menu
    [thisNavigationController popToViewController:doctorMainMenuController animated:YES];
    //create and show alert message
    UIAlertView *failureAlert = [self alertStatus:@"Check Network Status and Try Again Later" andAlertTitle:@"Internet Access Lost"];
    //show alert view
    [failureAlert show];
}

//if there is no internet access show an error message
-(void) showInternetRequiredErrorMessage
{
    //create and show alert message
    UIAlertView *failureAlert = [self alertStatus:@"You Need Internet Access to Perform that Action" andAlertTitle:@"No Internet Access"];
    //show alert view
    [failureAlert show];
}

//function to show error message if the app can't contact the server
-(void) failedToContactServerShowAlertView
{
    //create and show alert message
    UIAlertView *failureAlert = [self alertStatus:@"Please Try Again" andAlertTitle:@"Failed to Contact Server"];
    //show alert view
    [failureAlert show];
}
#pragma mark Audio Recording functions

//get audio recorder
-(AVAudioRecorder *)getAudioRecorderForMessageFile:(NSString *)audioFileName
{
    //get an array with the files path
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //copy documents path into an nstring
    NSString *documentsPath = [pathsArray objectAtIndex:0];
    //get path for recorded message
    NSString *soundFilePath = [documentsPath stringByAppendingPathComponent:audioFileName];
    //create sound file url
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    //set recording settings
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    //init audio recorder
    AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];

    return audioRecorder;
}

//create the name for the audio file
-(NSString *)getContactMessageFileNameForUser:(NSString *)patientUsername
{
    //get current user
    User *doctorUser = [[User alloc] initWithSavedUser];
    
    //create the file name by appending the doctor's username and the patient's
    NSString *audioFileName = @"MessageFrom";
    audioFileName = [audioFileName stringByAppendingString:doctorUser.username];
    audioFileName = [audioFileName stringByAppendingString:@"To"];
    audioFileName = [audioFileName stringByAppendingString:patientUsername];
    audioFileName = [audioFileName stringByAppendingString:@".caf"];
    
    return audioFileName;
}
@end
