//
//  Symptom.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/1/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "Symptom.h"

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



@end
