//
//  UserRequestViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/22/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User, Symptomhistory;

@interface UserRequestViewController : UIViewController

//properties
@property (nonatomic, strong) User *patientUser;
@property (nonatomic, strong) Symptomhistory *patientUsersSymptomHistoryEntry;


@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *symptomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateSeenLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAddedLabel;

//button functions
- (IBAction)relationAcceptPressed:(id)sender;
- (IBAction)relationRejectPressed:(id)sender;


@end
