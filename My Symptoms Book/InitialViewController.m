//
//  ViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "InitialViewController.h"
#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "DataAndNetFunctions.h"
#import "NormalUserMainViewController.h"
#import "User.h"
@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    
    //check if a user is saved
    DataAndNetFunctions *dataController =[[DataAndNetFunctions alloc] init];
    User *currentUser = [[User alloc] initWithSavedUser];
    //if there exists a logged user take him to the appropriate first view page
    if(currentUser!=nil)
    {
        //create window story board objects to change the rootview controller
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //log user details
        NSLog(@"User exists %@ %@ %@ %@ %@", currentUser.username, currentUser.email, currentUser.userID.stringValue, currentUser.userType.stringValue, currentUser.status.stringValue);
        
        //check user type, if 0 take him to normal user main view
        if([currentUser.userType.stringValue isEqualToString:@"0"])
        {
            NSLog(@"This user is a normal type user");
            NormalUserMainViewController *destinationController = [storyBoard instantiateViewControllerWithIdentifier:@"normalUserMainView"];
            destinationController.currentUser = currentUser;
            
            [self.navigationController pushViewController:destinationController animated:NO];
        }
        else
        {
            NSLog(@"This user is a Doctor type user");
            NormalUserMainViewController *destinationController = [storyBoard instantiateViewControllerWithIdentifier:@"doctorUserMainView"];
            destinationController.currentUser = currentUser;
            
            [self.navigationController pushViewController:destinationController animated:NO];
        }
    }
    
    //set title to my symptoms book when the inital view loads
    self.navigationBar.title = @"My Symptoms Book";
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark navigation functions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //check which button was pressed
    if([[segue identifier] isEqualToString:@"loginSegue"])
    {
        //if it was log in button, go to log in view
        LogInViewController *destinationController = [segue destinationViewController];
    }
    else if([[segue identifier] isEqualToString:@"registerSegue"])
    {
        //if register button got to register view
        RegisterViewController *destinationController = [segue destinationViewController];
    }
}
@end
