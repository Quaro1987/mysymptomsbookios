//
//  SymptomhistoryViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/13/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Symptomhistory;

@interface SymptomhistoryViewController : UIViewController

@property (nonatomic, strong) Symptomhistory *selectedSymptomhistoryEntry;

//label properties
@property (strong, nonatomic) IBOutlet UILabel *dateSymptomAddedLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateSymptomFirstSeenLabel;

@property (strong, nonatomic) IBOutlet UILabel *characterizationLabel;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *findingDoctorViewLoadingIndicator;

//button property
@property (strong, nonatomic) IBOutlet UIButton *symptomButton;

//button function

- (IBAction)findDoctorPressed:(id)sender;

//other functions

- (void)stopLoadingAnimationOfActivityIndicatorAndPerformSegue: (UIActivityIndicatorView *)spinner;

@end
