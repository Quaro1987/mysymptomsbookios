//
//  PickDateSymptomSeenViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/2/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Symptom, User;

@interface PickDateSymptomSeenViewController : UIViewController

@property (nonatomic, strong) Symptom *selectedSymptom;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSString *password;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

//functions
- (IBAction)saveSymptomButtonPressed:(id)sender;
-(NSString *)getInputedDate;

@end
