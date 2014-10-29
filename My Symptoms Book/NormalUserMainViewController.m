//
//  NormalUserMainViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "NormalUserMainViewController.h"
#import "User.h"
#import "DataAndNetFunctions.h"
#import "SSKeychain.h"
#import "InitialViewController.h"

@interface NormalUserMainViewController ()

@end

@implementation NormalUserMainViewController

@synthesize currentUser;

- (void)viewDidLoad {
    
    self.navigationBar.title = @"My Symptoms Book";
    //hide back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"logoutSegue"])
    {
        
        
        InitialViewController *destinationController = [segue destinationViewController];
    }
}
*/


- (IBAction)addSymptomPressed:(id)sender {
}

- (IBAction)checkSymptomsHistoryPressed:(UIButton *)sender {
}

- (IBAction)manageDoctorsPressed:(UIButton *)sender {
}
//if the user selects to log out, delete his details and take him to the initial page
- (IBAction)logoutPressed:(UIButton *)sender
{
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    
    //log out user function
    [dataController logoutUser:currentUser];
    
    //notify user
    [[dataController alertStatus:@"You have been logged out from My Symptoms Book" andAlertTitle:@"Log Out Succesful"] show];
 
    //change controller view
    InitialViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"initialView"];
    [self.navigationController pushViewController:destinationController animated:NO];
}
@end
