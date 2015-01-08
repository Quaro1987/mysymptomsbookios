//
//  RegisterViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "RegisterViewController.h"
#import "DataAndNetFunctions.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize usernameTextfield, passwordTextfield, repeatPasswordTextfield, emailTextfield, phoneNumberTextfield, firstnameTextfield, lastnameTextfield, dateOfBirthTextfield, specialtyTextfield, specialtyLabel, userType;

- (void)viewDidLoad {
    [super viewDidLoad];
    //if the user is registering as a normal user
    if(userType==0)
    {
        //hide specialty input and label
        specialtyLabel.hidden = YES;
        specialtyTextfield.hidden = YES;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//check if all the fields have been filled correctly
- (IBAction)registerPressed:(id)sender {
    //creaet object to show alert warnings
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    if([usernameTextfield.text length] < 3)
    {
        [dataController alertStatus:@"Username must be at least 3 characters long." andAlertTitle:@"Username error"];
    }
    else if ([passwordTextfield.text length] < 4)
    {
        [dataController alertStatus:@"Password must be at least 4 characters long." andAlertTitle:@"Username error"];

    }
    else if (![passwordTextfield.text isEqualToString:repeatPasswordTextfield.text])
    {
        [dataController alertStatus:@"Password fields must match." andAlertTitle:@"Username error"];

    }
    else if (![self validateEmail:emailTextfield.text])
    {
        [dataController alertStatus:@"Email field must contain a valid email." andAlertTitle:@"Username error"];

    }
    else if (![self validatePhoneNumber:phoneNumberTextfield.text])
    {
        [dataController alertStatus:@"Phone number field can only contain digits." andAlertTitle:@"Username error"];

    }
    else if ([firstnameTextfield.text length] == 0)
    {
        [dataController alertStatus:@"First name field can't be empty." andAlertTitle:@"Username error"];

    }
    else if ([lastnameTextfield.text length] == 0)
    {
        [dataController alertStatus:@"Last name field can't be empty." andAlertTitle:@"Username error"];

    }
}

//resign keyboard when clicking on the background
- (IBAction)backgroundClick:(id)sender {
    //resign keyboard
    [usernameTextfield resignFirstResponder];
    [passwordTextfield resignFirstResponder];
    [repeatPasswordTextfield resignFirstResponder];
    [emailTextfield resignFirstResponder];
    [phoneNumberTextfield resignFirstResponder];
    [firstnameTextfield resignFirstResponder];
    [lastnameTextfield resignFirstResponder];
    [dateOfBirthTextfield resignFirstResponder];
    [specialtyTextfield resignFirstResponder];
}
    
//validate if inputed text is an email
- (BOOL)validateEmail:(NSString *)emailString
{
    //create email evaluation
     NSString *emailRegularExpressionString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegularExpressionString];
     //return result of evaluation
     return [emailTest evaluateWithObject:emailString];
}

//validate that the inputed number string containts only numbers
-(BOOL)validatePhoneNumber:(NSString *)numberString
{
    //create numbers regular expressions
    NSString *phoneNumberRegularExpresisonString = @"[0-9]*";
    NSPredicate *phoneNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegularExpresisonString];
    //return result of evaluation
    return [phoneNumberTest evaluateWithObject:numberString];
}

@end
