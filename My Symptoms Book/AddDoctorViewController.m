//
//  AddDoctorViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/18/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "AddDoctorViewController.h"
#import "DoctorUser.h"
#import "Symptomhistory.h"
#import "DoctorRequest.h"
#import "User.h"
#import "SSKeychain.h"

@interface AddDoctorViewController ()

@end

@implementation AddDoctorViewController

@synthesize doctorSpecialtyLabel, firstNameLabel, lastNameLabel, selectedDoctor, thisSymptomhistoryEntry;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up labels on load
    firstNameLabel.text = selectedDoctor.firstName;
    lastNameLabel.text = selectedDoctor.lastName;
    doctorSpecialtyLabel.text = selectedDoctor.doctorSpecialty;
    
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

- (IBAction)addDoctorPressed:(id)sender {
    
    //get the current user
    User *currentUser = [selectedDoctor initWithSavedUser];
    //get user password
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    //send doctor request
    DoctorRequest *doctorRequestToSend = [[DoctorRequest alloc] init];
    NSString *reply = [doctorRequestToSend sendDoctorRequestForUser:currentUser.username withPassword:password ToDoctor:selectedDoctor.userID forSymptomhistoryWithID: thisSymptomhistoryEntry.symptomHistoryID];
    NSLog(reply);
}
@end
