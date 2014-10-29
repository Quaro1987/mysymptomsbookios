//
//  LogInViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "LogInViewController.h"
#import "DataAndNetFunctions.h"
#import "User.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)loginButtonPressed:(id)sender {
    DataAndNetFunctions *dataNetController = [[DataAndNetFunctions alloc] init];
    //check if the user has inputed a username and password
    if([_usernameField.text isEqualToString:@""]||[_passwordField.text isEqualToString:@""])
    {
        [[dataNetController alertStatus:@"Please insert a username and password." andAlertTitle:@"Input Error"] show];
    }
    else //if user has inputed a username and password atempt to log in
    {
        id userLogInEffort = [dataNetController loginUserWithUsername:_usernameField.text andPassword:_passwordField.text];
        if([userLogInEffort isKindOfClass:[NSString class]])
        {
            NSString *errorMessage = [NSString stringWithFormat:@"%@",userLogInEffort];
            if([errorMessage isEqualToString:@"NOUSER"])
            {
                //if the username or password is wrong, inform the user with an alert message
                [[dataNetController alertStatus:@"Failed to log in, check username, password and if you have activated your account." andAlertTitle:@"Log in Failure"] show];
            }
        }
        else
        {
            User *currentUser = userLogInEffort;
            //save user data in a file
            [dataNetController saveUserData:currentUser];
            [[dataNetController alertStatus:@"Welcome to My Symptoms Book" andAlertTitle:currentUser.username] show];
        }
    }
}
//hide keyboard when user clicks on the background
- (IBAction)backgroundClick:(id)sender
{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}
@end
