//
//  UserRequestViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/22/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "UserRequestViewController.h"
#import "User.h"
#import "Symptomhistory.h"
#import "DoctorRequest.h"
#import "DataAndNetFunctions.h"
#import "DoctorUserMainViewController.h"

@interface UserRequestViewController ()

@end

@implementation UserRequestViewController

@synthesize patientUser, patientUsersSymptomHistoryEntry, lastNameLabel, firstNameLabel, symptomTitleLabel, dateAddedLabel, dateSeenLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //get the symptom history entry for this user
    Symptomhistory *aSymptomHistoryObject = [[Symptomhistory alloc] init];
    patientUsersSymptomHistoryEntry = [aSymptomHistoryObject getSymptomhistoryTheDoctorWasAddedForByUserWithID:patientUser.userID];
    
    lastNameLabel.text = patientUser.lastName;
    firstNameLabel.text = patientUser.firstName;
    symptomTitleLabel.text = patientUsersSymptomHistoryEntry.symptomTitle;
    dateSeenLabel.text = patientUsersSymptomHistoryEntry.dateSymptomFirstSeen;
    dateAddedLabel.text = patientUsersSymptomHistoryEntry.dateSymptomAdded;
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

- (IBAction)relationAcceptPressed:(id)sender {
    DoctorRequest *replyToRequest = [[DoctorRequest alloc] init];
    [replyToRequest replyToRequestFromUserWithID:patientUser.userID withReply:@"ACCEPT"];
    
    //get success alert view
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    UIAlertView *successAlert = [dataController alertStatus:@"Patient Accepted" andAlertTitle:@"Patient Accepted"];
    //show alert view
    [successAlert show];
    
    //redirect to main menu
    DoctorUserMainViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorUserMainView"];
    [self.navigationController pushViewController:destinationController animated:NO];

}

- (IBAction)relationRejectPressed:(id)sender {
    DoctorRequest *replyToRequest = [[DoctorRequest alloc] init];
    [replyToRequest replyToRequestFromUserWithID:patientUser.userID withReply:@"REJECT"];
    
    //get success alert view
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    UIAlertView *successAlert = [dataController alertStatus:@"Patient Rejected" andAlertTitle:@"Patient Rejected"];
    //show alert view
    [successAlert show];
    
    //redirect to main menu
    DoctorUserMainViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorUserMainView"];
    [self.navigationController pushViewController:destinationController animated:NO];

}
@end
