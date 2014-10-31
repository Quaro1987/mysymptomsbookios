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
    
    
    //init number formatter
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //set so the formatter doesn't reutrn decimals
    [numberFormatter setGeneratesDecimalNumbers:FALSE];
    
    //copy the id of the returned user in an nsnumber. If it's 0 no such user exists/wrong
    //password
    //NSNumber *userID = [numberFormatter numberFromString:[jsonReponseData objectForKey:@"id"]];
    //NSLog(@"%@",userID);
    
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
            
        User *user = [[User alloc] initWithId:userID andUserName:tempUserame andUserType:tempUserType andEmail:tempEmail andStatus:userStatus];
        
        return user;
    }
}

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

#pragma mark log in/out functions

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
-(User *)getSavedUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //get the saved user's encoded data
    NSData *encodedUserData = [defaults objectForKey:@"user"];
    //crate user object
    User *currentUser = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedUserData];
    
    return currentUser;
}

//logout user
-(void)logoutUser:(User *) currentUser
{
    //delete password from keychain
    [SSKeychain deletePasswordForService:@"MySymptomsBook" account:currentUser.username];
    
    //delete user object form nsuser defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user"];
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
    NSInteger resultValue;
    
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






@end
