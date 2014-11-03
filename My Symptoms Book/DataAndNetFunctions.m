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

#pragma mark add symptom functions

//add symptoms function
-(NSString *)addSymptomForUser:(NSString *) username withPassword:(NSString *) password theSymptom:(NSString *) symptomTitle withSymptomCode:(NSString *) symptomCode andDateFirstSeen:(NSString *) dateSymptomFirstSeen
{
    if([self internetAccess])
    {
        //create post data string
        NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&symptomCode=%@&symptomTitle=%@&dateSymptomFirstSeen=%@", username, password, symptomCode, symptomTitle, dateSymptomFirstSeen];
        
        //log post data
        NSLog(@"Postdata: %@",postMessage);
        
        //create server url and append addSymptomIOS function
        NSURL *url = [[NSURL alloc] initWithString:[webServer stringByAppendingString:@"addSymptomIOS"]];
        
        //turn post string into nsdata
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
        
        //error attribute
        NSError *error = [[NSError alloc] init];
        
        //response
        NSURLResponse *response;
        
        //make post request to server
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        return @"SUCCESS";
    }
    else
    {
        //open the database
        
        //return the path of the database file
        NSString *dataBasePath = [self getMySymptomsBookDatabasePath];
        
        //create database
        FMDatabase *database = [FMDatabase databaseWithPath:dataBasePath];
        
        //open db
        if(![database open])
        {
            return @"FAIL";
        }
        
        //copy today's date into a string
        NSDate *selectedDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //set date format
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"yyyy/MM/d"];
        //turnd ate into string
        NSString *dateToday = [dateFormatter stringFromDate:selectedDate];
        
        
        //insert added symptom data into database
        [database executeUpdate:@"INSERT INTO tbl_tempSymptomhistory VALUES (?, ?, ?, ?, ?)" withArgumentsInArray:@[symptomCode, symptomTitle, dateSymptomFirstSeen, dateToday, username]];
        
        //close database once complete
        [database close];
        
        //init NSUserDefautls object
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //create string object that stores the information if a symptom was added while the app was offline
        NSString *offlineSymptomsAddedString = @"YES";
        //add object to nsuserdefaults and synchronize
        [defaults setObject:offlineSymptomsAddedString forKey:@"offlineSymptomsAdded"];
        [defaults synchronize];
        
        return @"SAVED";
    }
    
    
}

//return the string stored in nsuerdefaults to notify the app if the user has saved symptoms while offline
-(NSString *)getInfoOnSavedSymptomsWhileOffline
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *reply = [defaults objectForKey:@"offlineSymptomsAdded"];
    
    return reply;
}

//post to server all symptoms while the user was offline
-(NSString *)batchPostSavedSymptoms
{
    //get the user
    User *currentUser = [self getSavedUser];
    //get the users password
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    NSMutableArray *savedSymptoms = [self getSavedSymptomsForUser:currentUser.username];
    
    int successes = 0;
    //loop through all saved symptoms for the user and post them to server
    for(int i=0;i<[savedSymptoms count];i++)
    {
        Symptomhistory *thisSymptomHistory = [savedSymptoms objectAtIndex:i];
        NSString *result = [self addSymptomForUser:currentUser.username withPassword:password theSymptom:thisSymptomHistory.symptomTitle withSymptomCode:thisSymptomHistory.symptomCode andDateFirstSeen:thisSymptomHistory.dateSymptomFirstSeen];
        //if save succesfull increase by 1 successes int
        if([result isEqualToString:@"SUCCESS"])
        {
            successes++;
        }
    }
    
    //check if all the symptoms have been posted to the server. if they have, empty the table from the user's saved symptoms
    if(successes==[savedSymptoms count])
    {
        [self clearDatabaseOfSavedSymptomsForUser:currentUser.username];
        return @"Symptoms sent to server";
        
    }
    else
    {
        return @"Not all symptoms saved";
    }
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

//get saved symptoms array
-(NSMutableArray *)getSavedSymptomsForUser:(NSString *)userName
{
    //open database
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[self getMySymptomsBookDatabasePath]];
    
    //if database doesn't open, end function and return null
    if(![dataBase open])
    {
        return NULL;
    }
    
    //query string
    NSString *querySavedSymptoms = [NSString stringWithFormat:@"SELECT * FROM tbl_tempSymptomhistory WHERE username = \"%@\"", userName];
    
    //get saved symptoms
    FMResultSet *savedSymptoms = [dataBase executeQuery:querySavedSymptoms];
    
    NSMutableArray *savedSymptomsArray = [[NSMutableArray alloc] init];
    
    while([savedSymptoms next])
    {
        NSString *tempCode = [savedSymptoms objectForColumnName:@"symptomCode"];
        NSString *tempTitle = [savedSymptoms objectForColumnName:@"title"];
        NSString *tempDateSeen = [savedSymptoms objectForColumnName:@"dateSymptomFirstSeen"];
        NSString *tempDateAdded = [savedSymptoms objectForColumnName:@"dateSymptomAdded"];
        NSString *tempUsername = [savedSymptoms objectForColumnName:@"username"];
        
        Symptomhistory *symHistoryObject = [[Symptomhistory alloc] initWithUserame:tempUsername andSymptomCode:tempCode andSymptomTitle:tempTitle andDateSymptomFirstSeen:tempDateSeen andDateSymptomAdded:tempDateAdded];
        
        [savedSymptomsArray addObject:symHistoryObject];
    }
    
    return savedSymptomsArray;
}

//clear all the user's symptoms
-(void)clearDatabaseOfSavedSymptomsForUser:(NSString *)username
{
    //open database
    FMDatabase *database = [FMDatabase databaseWithPath:[self getMySymptomsBookDatabasePath]];
    
    //if database doesn't open, end function and return null
    if(![database open])
    {
        return;
    }
    
    //delete symptoms string
    NSString *deleteQueryString = [NSString stringWithFormat:@"DELETE FROM tbl_tempSymptomhistory WHERE username = \"%@\"", username];
    [database executeUpdate:deleteQueryString];
}

#pragma mark network functions

//check if there is internet access
-(BOOL)internetAccess
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
         NSLog(@"There is no internet connection");
        return NO;
    } else {
        NSLog(@"There IS internet connection");
        return YES;
    }
}




@end
