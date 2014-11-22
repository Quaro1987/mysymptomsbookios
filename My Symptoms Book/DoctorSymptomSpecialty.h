//
//  DoctorSymptomSpecialty.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/20/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorSymptomSpecialty : NSObject

//functions
-(NSString *)deleteDoctorSymptomSpecialtyWithSymptomCode:(NSString *) symptomCode;

-(NSString *)addDoctorSymptomSpecialtyWithSymptomCode:(NSString *) symptomCode;
@end
