//
//  RegisterViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextfield;

@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *lastnameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextfield;

@property (weak, nonatomic) IBOutlet UITextField *specialtyTextfield;

@property (weak, nonatomic) IBOutlet UILabel *specialtyLabel;

//usertype property
@property (nonatomic) int userType;

//functions
- (IBAction)registerPressed:(id)sender;

- (IBAction)backgroundClick:(id)sender;

@end
