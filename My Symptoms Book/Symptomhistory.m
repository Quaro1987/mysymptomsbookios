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
-(NSString *)addForUserTheSymptom:(NSString *) symptomTitle withSymptomCode:(NSString *) symptomCode andDateFirstSeen:(NSString *) theDateSymptomFirstSeen
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //get user and password
    User *currentUser = [[User alloc] initWithSavedUser];
    NSString *password = [dataAndNetController getUserPassword];
    
    //if the phone has internet access
    if([dataAndNetController internetAccess])
    {
        //create post data string
        NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&symptomCode=%@&symptomTitle=%@&dateSymptomFirstSeen=%@", [currentUser getEncodedUsername], password, symptomCode, symptomTitle, theDateSymptomFirstSeen];
        
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
        
        //check if the app contacted with server
        if([urlData length] == 0)
        {
            //log the error and show error message
            NSLog(@"ERROR no contact with server");
            [dataAndNetController failedToContactServerShowAlertView];
            return @"FAILURE";
        }
        else
        {
            return @"SUCCESS";
        }
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
        [database executeUpdate:@"INSERT INTO tbl_tempSymptomhistory VALUES (?, ?, ?, ?, ?)" withArgumentsInArray:@[symptomCode, symptomTitle, theDateSymptomFirstSeen, dateToday, currentUser.username]];
        
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
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //open database
    FMDatabase *database = [FMDatabase databaseWithPath:[dataAndNetController getMySymptomsBookDatabasePath]];
    NSMutableArray *savedSymptoms = [self getSavedSymptomsForUser];
    
    int successes = 0;
    //loop through all saved symptoms for the user and post them to server
    for(int i=0;i<[savedSymptoms count];i++)
    {
        Symptomhistory *thisSymptomHistory = [savedSymptoms objectAtIndex:i];
        //save this symptom history entry
        NSString *result = [self addForUserTheSymptom:thisSymptomHistory.symptomTitle withSymptomCode:thisSymptomHistory.symptomCode andDateFirstSeen:thisSymptomHistory.dateSymptomFirstSeen];
        //if save succesfull increase by 1 successes int
        if([result isEqualToString:@"SUCCESS"])
        {
            //delete symptoms string
            NSString *deleteQueryString = [NSString stringWithFormat:@"DELETE FROM tbl_tempSymptomhistory WHERE username = \"%@\" AND title =  \"%@\" AND dateSymptomFirstSeen = \"%@\"", currentUser.username, thisSymptomHistory.symptomTitle, thisSymptomHistory.dateSymptomFirstSeen];
            [database executeUpdate:deleteQueryString];

            successes++;
        }
    }
    
    //check if all the symptoms have been posted to the server. if they have, empty the table from the user's saved symptoms
    if(successes==[savedSymptoms count])
    {
        //[self clearDatabaseOfSavedSymptomsForUser:currentUser.username];
        return @"Symptoms sent to server";
        
    }
    else
    {
        return @"Not all symptoms saved";
    }
}

//get saved symptoms array
-(NSMutableArray *)getSavedSymptomsForUser
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //get current user
    User *currentUser = [[User alloc] initWithSavedUser];
    
    //open database
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[dataAndNetController getMySymptomsBookDatabasePath]];
    
    //if database doesn't open, end function and return null
    if(![dataBase open])
    {
        return NULL;
    }
    
    //query string
    NSString *querySavedSymptoms = [NSString stringWithFormat:@"SELECT * FROM tbl_tempSymptomhistory WHERE username = \"%@\"", currentUser.username];
    
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
-(NSMutableArray *)getSymptomhistoryForUser: (User *)requestedUser
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
   
    //if the phone has internet access
    if([dataAndNetController internetAccess])
    {
        //creatue url
        NSString *serverString = [dataAndNetController serverUrlString];
        NSString *stringUrl = [serverString stringByAppendingString:@"userSymptomHistoryIOS"];
        //get username and password
        User *currentUser = [[User alloc] initWithSavedUser];
        NSString *password = [dataAndNetController getUserPassword];
        
        NSURL *url = [[NSURL alloc] initWithString:stringUrl];
        
        //create post data
        NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&userID=%@", [currentUser getEncodedUsername], password, requestedUser.userID];
        
        //create request
        NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
        
        //error attribute
        NSError *error = [[NSError alloc] init];
        
        //create response
        NSURLResponse *response;
        
        //json data
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        //create array that will keep the usert's personal symptom history
        NSMutableArray *userPersonalSymptomHistory = [[NSMutableArray alloc] init];
        
        if([responseData length] == 0)
        {
            //log the error and show error message
            NSLog(@"ERROR no contact with server");
            [dataAndNetController failedToContactServerShowAlertView];
            
            //create error symptom history
            Symptomhistory *symptomhistoryObject = [[Symptomhistory alloc] init];
            symptomhistoryObject.symptomTitle = @"ERROR";
            
            //add error object to array
            [userPersonalSymptomHistory addObject:symptomhistoryObject];
        }
        else
        {
            //pass symptom history objects into an array
            NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
            
            //loop through results, and add them to userSymptomHistoryArray
            for (NSDictionary *symptomhistoryObject in jsonReponseData)
            {
                NSInteger tempID = [(NSNumber *) [symptomhistoryObject objectForKey:@"id"] integerValue];
                int tempIDint = tempID;
                NSString *tempUsername = requestedUser.username;
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
        }
        
        //return user symptom history
        return userPersonalSymptomHistory;
    }
    else //if there is no internet access
    {
        NSMutableArray *userPersonalSymptomHistory = [[NSMutableArray alloc] init];
        //get the symptoms the user has saved on his device and hasn't synced them yet
        userPersonalSymptomHistory = [self getSavedSymptomsForUser];
        return userPersonalSymptomHistory;
    }
    
}

//get specific symptom history from server for doctor
-(id)getSymptomhistoryTheDoctorWasAddedForByUserWithID:(NSNumber *)usrID
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //get logged in user's username and password
    User *currentUser = [[User alloc] initWithSavedUser];
    NSString *password = [dataAndNetController getUserPassword];
    
    //creatue url
    NSString *serverString = [dataAndNetController serverUrlString];
    NSString *stringUrl = [serverString stringByAppendingString:@"getSymptomHistoryUserAddedDoctorForIOS"];
    
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    //create post data
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&userID=%@", [currentUser getEncodedUsername], password, usrID];
    
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //json data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if([responseData length] == 0)
    {
        //log the error and show error message
        NSLog(@"ERROR no contact with server");
        [dataAndNetController failedToContactServerShowAlertView];
        
        Symptomhistory *thisSymptomHistory =  [[Symptomhistory alloc] init];
        thisSymptomHistory.symptomTitle = @"FAILURE";
        return thisSymptomHistory;
    }
    else
    {
    //pass symptom history object into an NSDictionary
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
    //copy returned attributes
    NSInteger tempID = [(NSNumber *) [jsonReponseData objectForKey:@"id"] integerValue];
    int tempIDint = tempID;
    NSString *tempUsername = currentUser.username;
    NSString *tempSymptomCode = [jsonReponseData objectForKey:@"symptomCode"];
    NSString *tempSymptomTitle = [jsonReponseData objectForKey:@"symptomTitle"];
    NSString *tempDateSymptomAdded = [jsonReponseData objectForKey:@"dateSearched"];
    NSString *tempDateSymptomFirstSeen = [jsonReponseData objectForKey:@"dateSymptomFirstSeen"];
    NSString *tempSymptomFlag = [jsonReponseData objectForKey:@"symptomFlag"];
    //create symptom history object
    Symptomhistory *thisSymptomHistory = [[Symptomhistory alloc] initWithUserame:tempUsername andSymptomCode:tempSymptomCode andSymptomTitle:tempSymptomTitle andDateSymptomFirstSeen:tempDateSymptomFirstSeen andDateSymptomAdded:tempDateSymptomAdded andSymptomFlag:tempSymptomFlag andSymptomHistoryID:tempIDint];
    
    return thisSymptomHistory;
    }
}

#pragma mark characterization label functions

//get characterization label color for this symptom history
-(UIColor *)getCharacterizationLabelColor
{
    //get this symptoms characterization string
    NSString *theSymptomCharacterization = self.symptomFlag;
    UIColor *characterizationLabelColor = [[UIColor alloc] init];
    //set label color and text
    if([theSymptomCharacterization isEqualToString:@"1"])
    {
        characterizationLabelColor = [UIColor colorWithRed:0.631 green:0.922 blue:0.525 alpha:1];
    }
    else if([theSymptomCharacterization isEqualToString:@"2"])
    {
        characterizationLabelColor = [UIColor colorWithRed:0.8 green:0.792 blue:0.322 alpha:1];
    }
    else if([theSymptomCharacterization isEqualToString:@"3"])
    {
        characterizationLabelColor = [UIColor colorWithRed:0.949 green:0.318 blue:0.22 alpha:1];
    }
    else
    {
        characterizationLabelColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1];
    }
    
    return characterizationLabelColor;
}

//get characterization label for this symptom history
-(NSString *)getCharacterizationLabelText
{
    //get this symptoms characterization string
    NSString *theSymptomCharacterization = self.symptomFlag;
    NSString *characterizationLabelText = [[NSString alloc] init];
    //set label color and text
    if([theSymptomCharacterization isEqualToString:@"1"])
    {
        characterizationLabelText = @"Low Danger";
    }
    else if([theSymptomCharacterization isEqualToString:@"2"])
    {
        characterizationLabelText = @"Mild Danger";
    }
    else if([theSymptomCharacterization isEqualToString:@"3"])
    {
        characterizationLabelText = @"High Danger";
    }
    else
    {
        characterizationLabelText = @"No Characterization";
    }
    
    return characterizationLabelText;
}

//update the symptom characterization by the doctor
-(BOOL)updateCharacterizationByDoctor
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //get logged in user's username and password
    User *currentUser = [[User alloc] initWithSavedUser];
    NSString *password = [dataAndNetController getUserPassword];
    
    //creatue url
    NSString *serverString = [dataAndNetController serverUrlString];
    NSString *stringUrl = [serverString stringByAppendingString:@"updateSymptomhistoryCharacterizationIOS"];
    
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    //create post data
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@&symptomHistoryID=%d&symptomFlag=%@", [currentUser getEncodedUsername], password, self.symptomHistoryID, self.symptomFlag];
    
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //send update to server
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if([responseData length] == 0)
    {
        //log the error and show error message
        NSLog(@"ERROR no contact with server");
        [dataAndNetController failedToContactServerShowAlertView];
        return FALSE;
    }
    else
    {
        /*
        NSLog(@"responseData = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        //pass reply into an NSDictionary
        NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        NSString *stringReply =  (NSString *)[jsonReponseData objectForKey:@"thisReply"];
         */
        return TRUE;
    }
}

//filtering method
-(NSMutableArray *) filterArray:(NSMutableArray *)symptomHistoryArray forCategory:(NSString *)categoryShortString
{
    //creaet empty array
    NSMutableArray *filteredSymptomHistoryArray = [[NSMutableArray alloc] init];
    //create selected category code string
    NSString *selectedCategoryCode = [[NSString alloc] init];
    
    //if check for the selected category to get the symptom code letter
    if([categoryShortString isEqualToString:@"Bl"])
    {
            selectedCategoryCode = @"B";
    }
    else if([categoryShortString isEqualToString:@"Ci"])
    {
        selectedCategoryCode = @"K";
    }
    else if([categoryShortString isEqualToString:@"Di"])
    {
        selectedCategoryCode = @"D";
    }
    else if([categoryShortString isEqualToString:@"Ea"])
    {
        selectedCategoryCode = @"H";
    }
    else if([categoryShortString isEqualToString:@"Ey"])
    {
        selectedCategoryCode = @"F";
    }
    else if([categoryShortString isEqualToString:@"Fe"])
    {
        selectedCategoryCode = @"X";
    }
    else if([categoryShortString isEqualToString:@"Ge"])
    {
        selectedCategoryCode = @"A";
    }
    else if([categoryShortString isEqualToString:@"Ma"])
    {
        selectedCategoryCode = @"Y";
    }
    else if([categoryShortString isEqualToString:@"Me"])
    {
        selectedCategoryCode = @"T";
    }
    else if([categoryShortString isEqualToString:@"Mu"])
    {
        selectedCategoryCode = @"L";
    }
    else if([categoryShortString isEqualToString:@"Ne"])
    {
        selectedCategoryCode = @"N";
    }
    else if([categoryShortString isEqualToString:@"Ps"])
    {
        selectedCategoryCode = @"P";
    }
    else if([categoryShortString isEqualToString:@"Re"])
    {
        selectedCategoryCode = @"R";
    }
    else if([categoryShortString isEqualToString:@"Sk"])
    {
        selectedCategoryCode = @"S";
    }
    else if([categoryShortString isEqualToString:@"So"])
    {
        selectedCategoryCode = @"Z";
    }
    else if([categoryShortString isEqualToString:@"Ur"])
    {
        selectedCategoryCode = @"U";
    }
    else if([categoryShortString isEqualToString:@"Wo"])
    {
        selectedCategoryCode = @"W";
    }

    //loop through all the symptom history entries and add the ones with the selected category
    //to the array to be returned
    for (int i=0; i<[symptomHistoryArray count]; i++)
    {
        //get the first letter of the symptom code
        Symptomhistory *thisSymptomHistoryEntry = [symptomHistoryArray objectAtIndex:i];
        NSString *symptomCodeFirstLetter = [thisSymptomHistoryEntry.symptomCode substringToIndex:1];
        //if the symptoms belongs in the selected category, add it to the filtered array
        if([symptomCodeFirstLetter isEqualToString:selectedCategoryCode])
        {
            [filteredSymptomHistoryArray addObject:thisSymptomHistoryEntry];
        }
    }
    //return filtering results
    return filteredSymptomHistoryArray;
}

@end
