//
//  Symptom.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/1/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Symptom : NSObject

//properties
@property (nonatomic, strong) NSString *symptomCode;
@property (nonatomic, strong) NSString *symptomTitle;
@property (nonatomic, strong) NSString *symptomInclusions;
@property (nonatomic, strong) NSString *symptomExclusions;
@property (nonatomic, strong) NSString *symptomCategory;

//functions

-(id)initWithSymptomCode: (NSString *) symCode andSymptomTitle: (NSString *) symTitle andSymptomInclusions: (NSString *) symInclusions andSymptomExclusions: (NSString *)
symExclusions andSymptomCategory: (NSString *) symCategory;

-(NSMutableArray *)getSymptomsWithCategory:(NSString *)symptomCat;

-(id)getSymptomWithSymptomCode:(NSString *)sympCode;

-(NSMutableArray *)getSymptomSpecialtiesForDoctorUser:(User *)docUser;
@end
