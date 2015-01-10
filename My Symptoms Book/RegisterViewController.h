
//  RegisterViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

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

//variable properties
@property (nonatomic) int userType;

@property (nonatomic, strong) NSArray *specialtiesArray;

//date and specialty picker properties
@property (strong, nonatomic) IBOutlet UIView *dateSelectView;
@property (weak, nonatomic) IBOutlet UIView *specialtySelectView;

@property (weak, nonatomic) IBOutlet UIPickerView *specialtyPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

//functions
- (IBAction)registerPressed:(id)sender;

- (IBAction)backgroundClick:(id)sender;

- (IBAction)clickingOnBirthDateTextField:(id)sender;

- (IBAction)clickingOnSpecialtyTextField:(id)sender;

- (IBAction)specialtyPickDonePressed:(id)sender;

- (IBAction)datePickDonePressed:(id)sender;
@end
