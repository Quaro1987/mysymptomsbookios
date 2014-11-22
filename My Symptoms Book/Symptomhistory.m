//
//  Symptomhistory.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/3/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "Symptomhistory.h"
#import "Symptom.h"
#import "DataAndNetFunctions.h"
#import "FMDB.h"
#import "User.h"
#import "SSKeychain.h"


@implementation Symptomhistory

@synthesize symptomTitle,symptomCode,symptomUsername,dateSymptomFirstSeen,dateSymptomAdded, symptomFlag, datedAddedInNSDateFormat;

#pragma mark init functions

//init without flag
-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded
{
    self = [super init];
    
    self.symptomUsername = userName;
    self.symptomTitle = title;
    self.symptomCode = code;
    self.dateSymptomAdded = dateAdded;
    self.dateSymptomFirstSeen = dateSeen;
    
    //set date formatter and convert datesymptomadded string into nsdate object
    NSDateFormatter *symHistoryDateFormatter = [[NSDateFormatter alloc] init];
    [symHistoryDateFormatter setDateFormat:@"yyyy/MM/d"];
    self.datedAddedInNSDateFormat = [symHistoryDateFormatter dateFromString:dateAdded];
    
    return self;
}

//init with flat

//init without flag
-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded andSymptomFlag: (NSString *) flag andSymptomHistoryID:(int)symHistoryID
{
    self = [super init];
    
    self.symptomHistoryID = symHistoryID;
    self.symptomUsername = userName;
    self.symptomTitle = title;
    self.symptomCode = code;
    self.dateSymptomAdded = dateAdded;
    self.dateSymptomFirstSeen = dateSeen;
    self.symptomFlag = flag;
    
    //set date formatter and convert datesymptomadded string into nsdate object
    NSDateFormatter *symHistoryDateFormatter = [[NSDateFormatter alloc] init];
    [symHistoryDateFormatter setDateFormat:@"yyyy/MM/d"];
    self.datedAddedInNSDateFormat = [symHistoryDateFormatter dateFromString:dateAdded];
    
    return self;
}

//add symptoms function
-(NSString *)addSymptomForUser:(NSString *) username withPassword:(NSString *) password theSymptom:(NSString *) symptomTitle withSymptomCode:(NSString *) symptomCode andDateFirstSeen:(NSString *) theDateSymptomFirstSeen
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //if the phone has internet access
    if([dataAndNetController internetAccess])
    {
        //create post data string
        NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&symptomCode=%@&symptomTitle=%@&dateSymptomFirstSeen=%@", username, password, symptomCode, symptomTitle, theDateSymptomFirstSeen];
        
        //log post data
        NSLog(@"Postdata: %@",postMessage);
        
        //create server url and append addSymptomIOS function
        NSString *serverString = [dataAndNetController serverUrlString];
        NSURL *url = [[NSURL alloc] initWithString:[serverString stringByAppendingString:@"addSymptomIOS"]];

        //url request
        NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
        
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
        NSString *dataBasePath = [dataAndNetController getMySymptomsBookDatabasePath];
        
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
    User *currentUser = [[User alloc] initWithSavedUser];
    
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

//get saved symptoms array
-(NSMutableArray *)getSavedSymptomsForUser:(NSString *)userName
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //open database
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[dataAndNetController getMySymptomsBookDatabasePath]];
    
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
        
        Symptomhistory *symHistoryObject = [[Symptomhistory alloc] initWithUserame:tempUsername andSymptomCode:tempCode andSymptomTitle:tempTitle andDateSymptomFirstSeen:tempDateSeen andDateSymptomAdded:tempDateAdded andSymptomFlag:NULL andSymptomHistoryID:NULL];
        
        [savedSymptomsArray addObject:symHistoryObject];
    }
    
    return savedSymptomsArray;
}

//clear all the user's symptoms
-(void)clearDatabaseOfSavedSymptomsForUser:(NSString *)username
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //open database
    FMDatabase *database = [FMDatabase databaseWithPath:[dataAndNetController getMySymptomsBookDatabasePath]];
    
    //if database doesn't open, end function and return null
    if(![database open])
    {
        return;
    }
    
    //delete symptoms string
    NSString *deleteQueryString = [NSString stringWithFormat:@"DELETE FROM tbl_tempSymptomhistory WHERE username = \"%@\"", username];
    [database executeUpdate:deleteQueryString];
}

//return  user's symptom history
-(NSMutableArray *)getSymptomhistoryForUser: (NSString *) username andWithPassword: (NSString *) password
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
   
    //if the phone has internet access
    if([dataAndNetController internetAccess])
    {
        //creatue url
        NSString *serverString = [dataAndNetController serverUrlString];
        NSString *stringUrl = [serverString stringByAppendingString:@"userSymptomHistoryIOS"];
        NSLog(stringUrl);
        NSURL *url = [[NSURL alloc] initWithString:stringUrl];
        
        //create post data
        NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@", username, password];
        
        //create request
        NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
        
        //error attribute
        NSError *error = [[NSError alloc] init];
        
        //create response
        NSURLResponse *response;
        
        //json data
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        //pass symptom history objects into an array
        NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        
        //create array that will keep the usert's personal symptom history
        NSMutableArray *userPersonalSymptomHistory = [[NSMutableArray alloc] init];
        
        
        //loop through results, and add them to userSymptomHistoryArray
        for (NSDictionary *symptomhistoryObject in jsonReponseData)
        {
            NSInteger tempID = [(NSNumber *) [symptomhistoryObject objectForKey:@"id"] integerValue];
            int tempIDint = tempID;
            NSString *tempUsername = username;
            NSString *tempSymptomCode = [symptomhistoryObject objectForKey:@"symptomCode"];
            NSString *tempSymptomTitle = [symptomhistoryObject objectForKey:@"symptomTitle"];
            NSString *tempDateSymptomAdded = [symptomhistoryObject objectForKey:@"dateSearched"];
            NSString *tempDateSymptomFirstSeen = [symptomhistoryObject objectForKey:@"dateSymptomFirstSeen"];
            NSString *tempSymptomFlag = [symptomhistoryObject objectForKey:@"symptomFlag"];
            
            //create symptom history object
            Symptomhistory *symptomhistoryObject = [[Symptomhistory alloc] initWithUserame:tempUsername andSymptomCode:tempSymptomCode andSymptomTitle:tempSymptomTitle andDateSymptomFirstSeen:tempDateSymptomFirstSeen andDateSymptomAdded:tempDateSymptomAdded andSymptomFlag:tempSymptomFlag andSymptomHistoryID:tempIDint];
           
            //add object to array
            [userPersonalSymptomHistory addObject:symptomhistoryObject];
        }
                
        //return user symptom history
        return userPersonalSymptomHistory;
    }
    else //if there is no internet access
    {
        NSMutableArray *userPersonalSymptomHistory = [[NSMutableArray alloc] init];
        //get the symptoms the user has saved on his device and hasn't synced them yet
        userPersonalSymptomHistory = [self getSavedSymptomsForUser:username];
        return userPersonalSymptomHistory;
    }
    
}

//get specific symptom history from server for doctor
-(id)getSymptomhistoryTheDoctorWasAddedForByUserWithID:(NSNumber *)usrID
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //get logged in user's username and password
    NSString *username = [[User alloc] initWithSavedUser].username;
    NSString *password = [dataAndNetController getUserPassword];
    
    //creatue url
    NSString *serverString = [dataAndNetController serverUrlString];
    NSString *stringUrl = [serverString stringByAppendingString:@"getSymptomHistoryUserAddedDoctorForIOS"];
    
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    //create post data
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&userID=%@", username, password, usrID];
    
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //json data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //pass symptom history object into an NSDictionary
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    //copy returned attributes
    NSInteger tempID = [(NSNumber *) [jsonReponseData objectForKey:@"id"] integerValue];
    int tempIDint = tempID;
    NSString *tempUsername = username;
    NSString *tempSymptomCode = [jsonReponseData objectForKey:@"symptomCode"];
    NSString *tempSymptomTitle = [jsonReponseData objectForKey:@"symptomTitle"];
    NSString *tempDateSymptomAdded = [jsonReponseData objectForKey:@"dateSearched"];
    NSString *tempDateSymptomFirstSeen = [jsonReponseData objectForKey:@"dateSymptomFirstSeen"];
    NSString *tempSymptomFlag = [jsonReponseData objectForKey:@"symptomFlag"];
    //create symptom history object
    Symptomhistory *thisSymptomHistory = [[Symptomhistory alloc] initWithUserame:tempUsername andSymptomCode:tempSymptomCode andSymptomTitle:tempSymptomTitle andDateSymptomFirstSeen:tempDateSymptomFirstSeen andDateSymptomAdded:tempDateSymptomAdded andSymptomFlag:tempSymptomFlag andSymptomHistoryID:tempIDint];
    
    return thisSymptomHistory;
}

@end
