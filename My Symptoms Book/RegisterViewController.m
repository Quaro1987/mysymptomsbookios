//
//  RegisterViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "RegisterViewController.h"
#import "DataAndNetFunctions.h"
#import "User.h"
#import "InitialViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize usernameTextfield, passwordTextfield, repeatPasswordTextfield, emailTextfield, phoneNumberTextfield, firstnameTextfield, lastnameTextfield, dateOfBirthTextfield, specialtyTextfield, specialtyLabel, userType, datePicker, dateSelectView, specialtiesArray, specialtySelectView, specialtyPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    //if the user is registering as a normal user
    if(userType==0)
    {
        //hide specialty input and label
        specialtyLabel.hidden = YES;
        specialtyTextfield.hidden = YES;
    }
    else
    {
        specialtiesArray = @[@"Cardiologist", @"Dentist", @"Dermatologist", @"Pathologist"];
    }
    //set the maximum date the user can input to today's date
    [datePicker setMaximumDate:[NSDate date]];
    
    
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
        [dataController alertStatus:@"Password must be at least 4 characters long." andAlertTitle:@"Password error"];

    }
    else if (![passwordTextfield.text isEqualToString:repeatPasswordTextfield.text])
    {
        [dataController alertStatus:@"Password fields must match." andAlertTitle:@"Password error"];

    }
    else if (![self validateEmail:emailTextfield.text])
    {
        [dataController alertStatus:@"Email field must contain a valid email." andAlertTitle:@"Email error"];

    }
    else if (![self validatePhoneNumber:phoneNumberTextfield.text])
    {
        [dataController alertStatus:@"Phone number field can only contain digits." andAlertTitle:@"Phone Number error"];

    }
    else if ([firstnameTextfield.text length] == 0)
    {
        [dataController alertStatus:@"First name field can't be empty." andAlertTitle:@"First Name error"];

    }
    else if ([lastnameTextfield.text length] == 0)
    {
        [dataController alertStatus:@"Last name field can't be empty." andAlertTitle:@"Last Name error"];

    }
    else if (userType==1 && [specialtyTextfield.text length]==0)
    {
        [dataController alertStatus:@"Specialty field can't be empty." andAlertTitle:@"Specialty error"];
    }
    else
    {
        //create temp string for specialty
        NSString *tempSpecialty = [[NSString alloc] init];
        //create an nsnumber for usertype
        NSNumber *userTypeNumber = [[NSNumber alloc] initWithInt:userType];
        
        //if it's a user registering as a normal user then input a space as specialty
        if(userType==0)
        {
            tempSpecialty = @" ";
        }
        else
        {
            tempSpecialty = specialtyTextfield.text;
        }
        
        //create temp user
        User *tempUser = [[User alloc] init];
        NSString *aString = [tempUser registerNewUserWithUsername:usernameTextfield.text andPassword:passwordTextfield.text andFirstName:firstnameTextfield.text andLastName:lastnameTextfield.text andEmail:emailTextfield.text andBirthdate:dateOfBirthTextfield.text andPhoneNumber:phoneNumberTextfield.text andSpecialty:tempSpecialty andUserType:userTypeNumber];
        NSLog(aString);
        if([aString isEqualToString:@"SUCCESS"])
        {
            //get success alert view
            DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
            [dataController alertStatus:@"Check your Email for the Activation Link" andAlertTitle:@"Registration Successful"];
            
            //redirect to doctor main menu
            InitialViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"initialView"];
            [self.navigationController pushViewController:destinationController animated:NO];
        }

    }
}

#pragma mark UI press functions

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

- (IBAction)clickingOnBirthDateTextField:(id)sender {
    dateSelectView.hidden = NO;
    [dateOfBirthTextfield resignFirstResponder];
}

- (IBAction)clickingOnSpecialtyTextField:(id)sender {
    specialtySelectView.hidden = NO;
    [specialtyTextfield resignFirstResponder];
    self.specialtyPicker.dataSource = self;
    self.specialtyPicker.delegate = self;
}

- (IBAction)specialtyPickDonePressed:(id)sender {
    //copy the selection to the textfield
    NSInteger selectionInt = [specialtyPicker selectedRowInComponent:0];
    specialtyTextfield.text = [specialtiesArray objectAtIndex:selectionInt];
    [specialtyTextfield resignFirstResponder];
    specialtySelectView.hidden = YES;

}

- (IBAction)datePickDonePressed:(id)sender {
    //copy the inputed date in the correct format to the textfield
    dateOfBirthTextfield.text = [self getInputedDate];
    [dateOfBirthTextfield resignFirstResponder];
    dateSelectView.hidden = YES;
}

#pragma mark picker delegate functions

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return specialtiesArray.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return specialtiesArray[row];
}


#pragma mark validator and format functions
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

//return the inputed date in the appropriate format
-(NSString *)getInputedDate
{
    NSDate *selectedDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //set date format
    [dateFormatter setDateFormat:@"yyyy/MM/d"];
    //turnd ate into string
    NSString *inputedDateString = [dateFormatter stringFromDate:selectedDate];
    
    return inputedDateString;
}

//force view on portrait
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
