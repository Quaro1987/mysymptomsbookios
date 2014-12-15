//
//  UserDoctorRelationViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/19/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "UserDoctorRelationViewController.h"
#import "DoctorRequest.h"
#import "DoctorUser.h"
#import "User.h"
#import "SSKeychain.h"
#import "DataAndNetFunctions.h"
#import "NormalUserMainViewController.h"
#import "DoctorUserMainViewController.h"

@interface UserDoctorRelationViewController ()

@end

@implementation UserDoctorRelationViewController

@synthesize thisUser, firstNameLabel, lastNameLabel, specialtyLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // set up labels
    firstNameLabel.text = thisUser.firstName;
    lastNameLabel.text = thisUser.lastName;
    specialtyLabel.text = thisUser.doctorSpecialty;
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

- (IBAction)removeUserRelationPressed:(id)sender {
    DoctorRequest *docRequest = [[DoctorRequest alloc] init];
    
    //get current user
    User *currentUser = [thisUser initWithSavedUser];
    
    //delete user relation
    NSString *queryResultString = [docRequest deleteRelationBetweenUserAndUserWithUserID:thisUser.userID];
    
    NSLog(queryResultString);
    
    if([currentUser.userType isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        //get success alert view
        DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
        UIAlertView *successAlert = [dataController alertStatus:@"Patient Successfully Removed" andAlertTitle:@"Patient Removed"];
        //show alert view
        [successAlert show];
        
        //redirect to main menu
        DoctorUserMainViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorUserMainView"];
        [self.navigationController pushViewController:destinationController animated:NO];
    }
    else
    {
        //get success alert view
        DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
        UIAlertView *successAlert = [dataController alertStatus:@"Doctor Successfully Removed" andAlertTitle:@"Doctor Removed"];
        //show alert view
        [successAlert show];
        
        //redirect to main menu
        NormalUserMainViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"normalUserMainView"];
        [self.navigationController pushViewController:destinationController animated:NO];

    }
}
@end
