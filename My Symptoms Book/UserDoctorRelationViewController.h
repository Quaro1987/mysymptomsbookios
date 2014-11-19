//
//  UserDoctorRelationViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/19/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoctorUser;

@interface UserDoctorRelationViewController : UIViewController

//properties
@property (strong, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *specialtyLabel;

@property (strong, nonatomic) DoctorUser *thisDoctor;
//functions
- (IBAction)removeDoctorPressed:(id)sender;


@end
