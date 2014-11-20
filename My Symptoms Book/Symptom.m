//
//  Symptom.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/1/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "Symptom.h"
#import "DataAndNetFunctions.h"
#import "FMDB.h"
#import "SSKeychain.h"
#import "User.h"

@implementation Symptom

//properties
@synthesize symptomCode, symptomTitle, symptomInclusions, symptomExclusions, symptomCategory;

#pragma mark functions

//init function

-(id)initWithSymptomCode:(NSString *)symCode andSymptomTitle:(NSString *)symTitle andSymptomInclusions:(NSString *)symInclusions andSymptomExclusions:(NSString *)symExclusions andSymptomCategory:(NSString *)symCategory
{
    //init self
    self = [super init];
    
    //copy properties
    self.symptomCode = symCode;
    self.symptomTitle = symTitle;
    self.symptomInclusions = symInclusions;
    self.symptomExclusions = symExclusions;
    self.symptomCategory = symCategory;
    
    //return self
    return self;
}

//get the symptoms with the selected category
-(NSMutableArray *)getSymptomsWithCategory:(NSString *)symptomCat
{
    //create datacontroller
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    
    //get database
    FMDatabase *database = [FMDatabase databaseWithPath:[dataController getMySymptomsBookDatabasePath]];
    
    //if database doesn't open, end function and reutnr null
    if(![database open])
    {
        return NULL;
    }
    
    //query for symptoms
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM tbl_symptoms WHERE symptomCategory = \"%@\" ORDER by title ASC;", symptomCat];
    FMResultSet *symptomsResult = [database executeQuery: queryString];
    //init symptoms array
    NSMutableArray *symptomsWithSelectedCategoryArray = [[NSMutableArray alloc] init];
    
    //loop through results, create symptom object for each, and push into array
    while([symptomsResult next])
    {
        //copy string values for row into temporary strings
        NSString *tempSymCode = [symptomsResult stringForColumn:@"symptomCode"];
        NSString *tempSymTitle = [symptomsResult stringForColumn:@"title"];
        NSString *tempSymInclusions = [symptomsResult stringForColumn:@"inclusions"];
        NSString *tempSymExclusions = [symptomsResult stringForColumn:@"exclusions"];
        NSString *tempSymCategory = [symptomsResult stringForColumn:@"symptomCategory"];
        //init symptoms object
        Symptom *thisSymptom = [[Symptom alloc] initWithSymptomCode:tempSymCode andSymptomTitle:tempSymTitle andSymptomInclusions:tempSymInclusions andSymptomExclusions:tempSymExclusions andSymptomCategory:tempSymCategory];
        //add symptom to results array
        [symptomsWithSelectedCategoryArray addObject:thisSymptom];
    }
    
    //return result
    return symptomsWithSelectedCategoryArray;
}

//return the symptom with the same symptom code as the inputed string
-(id)getSymptomWithSymptomCode:(NSString *)sympCode
{
    //create datacontroller
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    
    //get database
    FMDatabase *database = [FMDatabase databaseWithPath:[dataController getMySymptomsBookDatabasePath]];
    
    //if database doesn't open, end function and reutnr null
    if(![database open])
    {
        return NULL;
    }
    
    //query for symptoms
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM tbl_symptoms WHERE symptomCode = \"%@\";", sympCode];
    
    FMResultSet *symptomsResult = [database executeQuery: queryString];
    
    Symptom *thisSymptom;
    //loop through results, create symptom object for each, and push into array
    while([symptomsResult next])
    {
        //copy string values for row into temporary strings
        NSString *tempSymCode = [symptomsResult stringForColumn:@"symptomCode"];
        NSString *tempSymTitle = [symptomsResult stringForColumn:@"title"];
        NSString *tempSymInclusions = [symptomsResult stringForColumn:@"inclusions"];
        NSString *tempSymExclusions = [symptomsResult stringForColumn:@"exclusions"];
        NSString *tempSymCategory = [symptomsResult stringForColumn:@"symptomCategory"];
        //init symptoms object
        thisSymptom = [[Symptom alloc] initWithSymptomCode:tempSymCode andSymptomTitle:tempSymTitle andSymptomInclusions:tempSymInclusions andSymptomExclusions:tempSymExclusions andSymptomCategory:tempSymCategory];
    }
    
    //return the symptom with symptom code == symCode
    return thisSymptom;
}

//return the symptoms that the current doctor user has a specialty in
-(NSMutableArray *)getSymptomSpecialtiesForDoctorUser:(User *)docUser
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //creatue url
    NSString *serverString = [dataAndNetController serverUrlString];
    NSString *stringUrl = [serverString stringByAppendingString:@"getDoctorSymptomSpecialtiesIOS"];
    NSLog(stringUrl);
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    //get user password
    NSString *password = [dataAndNetController getUserPassword];
    
    //create post data
    NSString *postMessage = [[NSString alloc] initWithFormat:@"username=%@&password=%@", docUser.username, password];
    NSLog(@"Get Doctor Symptom Specialties data for: %@", postMessage);
    NSData *postData = [postMessage dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    //get post length
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
    
    //pass symptom history objects into an array
    NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    
    //create array that will keep the usert's personal symptom history
    NSMutableArray *doctorSymptomSpecialtiesArray = [[NSMutableArray alloc] init];
    
    
    //loop through results, and add them to userSymptomHistoryArray
    for (NSDictionary *symptomSpecialtyObject in jsonReponseData)
    {
        //copy symptom code
        NSString *thisSymptomCode = [symptomSpecialtyObject objectForKey:@"symptomCode"];
        //find the symptom with this symptom code
        Symptom *thisSymptom = [[Symptom alloc] init];
        thisSymptom = [thisSymptom getSymptomWithSymptomCode:thisSymptomCode];
        //add symptom to array
        [doctorSymptomSpecialtiesArray addObject:thisSymptom];
    }

    //sort array
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"symptomTitle"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [doctorSymptomSpecialtiesArray sortedArrayUsingDescriptors:sortDescriptors];
    
    doctorSymptomSpecialtiesArray = [NSMutableArray arrayWithArray:sortedArray];
    
    return doctorSymptomSpecialtiesArray;
}

@end
