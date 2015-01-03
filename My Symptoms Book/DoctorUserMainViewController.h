//
//  DoctorUserMainViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User, DataAndNetFunctions;

@interface DoctorUserMainViewController : UIViewController

//properties
@property (nonatomic, strong) User *currentUser;

@property (nonatomic, strong) DataAndNetFunctions *dataController;

@property (nonatomic, strong) NSString *segueToPerform;

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (weak, nonatomic) IBOutlet UIButton *managePatientSymptomHistoryButton;

//functions

//butons pressed
- (IBAction)logOutPressed:(id)sender;

- (IBAction)manageSymptomSpecialtiesPressed:(id)sender;

- (IBAction)managePatientSymptomHistoryPressed:(id)sender;

- (IBAction)manageUserRelationsPressed:(id)sender;
@end
