//
//  RegisterViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "RegisterViewController.h"

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

- (IBAction)registerPressed:(id)sender {
}
@end
