//
//  CheckSymptomViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/16/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Symptom;

@interface CheckSymptomViewController : UIViewController

//properties
@property (nonatomic, strong) Symptom *selectedSymptom;
@property (nonatomic, strong) NSString *selectedSymptomCode;

//label properties
@property (strong, nonatomic) IBOutlet UILabel *symptomTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *symptomCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *symptomInclusionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *symptomExclusionsLabel;


//function
-(void)setSymmptomOfSelfForSymptomWithCode: (NSString *) symptomCode;

@end
