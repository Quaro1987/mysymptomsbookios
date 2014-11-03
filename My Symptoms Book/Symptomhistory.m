//
//  Symptomhistory.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/3/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "Symptomhistory.h"

@implementation Symptomhistory

@synthesize symptomTitle,symptomCode,symptomUsername,dateSymptomFirstSeen,dateSymptomAdded;

//init function
-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded
{
    self = [super init];
    
    self.symptomUsername = userName;
    self. symptomTitle = title;
    self.symptomCode = code;
    self.dateSymptomAdded = dateAdded;
    self.dateSymptomFirstSeen = dateSeen;
    
    return self;
}

@end
