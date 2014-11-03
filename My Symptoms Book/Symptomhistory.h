//
//  Symptomhistory.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/3/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Symptomhistory : NSObject

@property (nonatomic, strong) NSString *symptomUsername;
@property (nonatomic, strong) NSString *symptomCode;
@property (nonatomic, strong) NSString *symptomTitle;
@property (nonatomic, strong) NSString *dateSymptomFirstSeen;
@property (nonatomic, strong) NSString *dateSymptomAdded;

//init function
-(id)initWithUserame:(NSString *)userName andSymptomCode:(NSString *)code andSymptomTitle:(NSString *)title andDateSymptomFirstSeen:(NSString *)dateSeen andDateSymptomAdded:(NSString *)dateAdded;

@end
