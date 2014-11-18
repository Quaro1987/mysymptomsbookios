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
-(NSMutableArray *)getSymptomsWithCategory:(NSString *)symptomCategory
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
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM tbl_symptoms WHERE symptomCategory = \"%@\" ORDER by title ASC;", symptomCategory];
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

@end
