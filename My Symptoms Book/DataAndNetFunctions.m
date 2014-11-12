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
