//
//  AddDoctorViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/18/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoctorUser;

@interface AddDoctorViewController : UIViewController

@property (nonatomic, strong) DoctorUser *selectedDoctor;

@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *doctorSpecialtyLabel;

//function
- (IBAction)addDoctorPressed:(id)sender;

@end
