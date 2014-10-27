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
    id userLogInEffort = [dataNetController loginUserWithUsername:_usernameField.text andPassword:_passwordField.text];
    
    if([userLogInEffort isKindOfClass:[NSString class]])
    {
        [[dataNetController alertStatus:@"Failed to log in, no such user" andAlertTitle:@"LOG IN FAILURE"] show];
    }
    else
    {
        User *currentUser = userLogInEffort;
        [[dataNetController alertStatus:@"Welcome to My Symptoms Book" andAlertTitle:currentUser.username] show];
    }
    
}
//hide keyboard when user clicks on the background
- (IBAction)backgroundClick:(id)sender
{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}
@end
