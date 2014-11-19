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

@interface UserDoctorRelationViewController ()

@end

@implementation UserDoctorRelationViewController

@synthesize thisDoctor, firstNameLabel, lastNameLabel, specialtyLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // set up labels
    firstNameLabel.text = thisDoctor.firstName;
    lastNameLabel.text = thisDoctor.lastName;
    specialtyLabel.text = thisDoctor.doctorSpecialty;
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

- (IBAction)removeDoctorPressed:(id)sender {
    DoctorRequest *docRequest = [[DoctorRequest alloc] init];
    
    //get current user name and password
    User *currentUser = [thisDoctor initWithSavedUser];
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    //delete user relation
    NSString *queryResultString = [docRequest deleteRelationForUser:currentUser.username withPassword:password withUserWithUserID:thisDoctor.userID];
    
    NSLog(queryResultString);
}
@end
