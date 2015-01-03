//
//  DoctorUserMainViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "DoctorUserMainViewController.h"
#import "UserSymptomSpecialtiesTableViewController.h"
#import "DataAndNetFunctions.h"
#import "InitialViewController.h"
#import "User.h"
#import "DoctorRequest.h"

@interface DoctorUserMainViewController ()

@end

@implementation DoctorUserMainViewController

@synthesize currentUser, navigationBar, segueToPerform, loadingIndicator, dataController, managePatientSymptomHistoryButton, manageUserRelationsButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    dataController = [[DataAndNetFunctions alloc] init];
    
    //if there is internet access  and change the text color of the manage patient symptom
    if([dataController internetAccess])
    {
        //get the patients with new symptoms added and any requests for the doctor
        DoctorRequest *aRequest = [[DoctorRequest alloc] init];
        User *aUser = [[User alloc] init];
        
        NSMutableArray *patientRequestsArray = [aUser getUsersDoctorHasRelationOfType:@"requests"];
        if([patientRequestsArray count]!=0)
        {
            UIColor *redColor = [UIColor colorWithRed:0.89 green:0.70 blue:0.70 alpha:1.0];
            [manageUserRelationsButton setTitleColor:redColor forState:UIControlStateNormal];
        }
        
        NSMutableArray *patientUsersWithNewSymptomsAddedIDsArray = [aRequest getIDsOfPatientUsersWithNewSymptomsAdded];
        if([patientUsersWithNewSymptomsAddedIDsArray count]!=0)
        {
            UIColor *redColor = [UIColor colorWithRed:0.89 green:0.70 blue:0.70 alpha:1.0];
            [managePatientSymptomHistoryButton setTitleColor:redColor forState:UIControlStateNormal];
        }
        
    }
    
    //get saved user
    User *currentUser = [[User alloc] initWithSavedUser];
    // Do any additional setup after loading the view.
    navigationBar.title = @"My Symptoms Book";
    //hide back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//stop loading animation and perform segue
- (void)stopLoadingAnimationOfActivityIndicatorAndPerformSegue: (UIActivityIndicatorView *)spinner {
    //stop loading animation
    [spinner stopAnimating];
    //perform usersymptomhistorysegue
    [self performSegueWithIdentifier:self.segueToPerform sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //check which segue is performed and pass revelant data
    if([[segue identifier] isEqualToString:@"manageSpecialtiesSegue"])
    {
        UserSymptomSpecialtiesTableViewController *destinationController = [segue destinationViewController];
        //pass current user
        destinationController.currentUser = self.currentUser;
    }
}

#pragma mark buttons pressed functions

//if the user selects to log out, delete his details and take him to the initial page
- (IBAction)logOutPressed:(id)sender {
    
    //log out user function
    [currentUser logoutUser];
    
    //notify user
    [[dataController alertStatus:@"You have been logged out from My Symptoms Book" andAlertTitle:@"Log Out Succesful"] show];
    
    //change controller view
    InitialViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"initialView"];
    [self.navigationController pushViewController:destinationController animated:NO];
}

//perform segue to go to the user's symptom specialties table view
- (IBAction)manageSymptomSpecialtiesPressed:(id)sender {
    if([dataController internetAccess])
    {
        self.segueToPerform = @"manageSpecialtiesSegue";
        //start animating the activity indicator while the app fetches the data from the server
        [loadingIndicator startAnimating];
        //stop the indicator from animating once the segue has been performed with a 2 second delay
        [self performSelector:@selector(stopLoadingAnimationOfActivityIndicatorAndPerformSegue:) withObject:self.loadingIndicator afterDelay:2.0];
    }
    else //if no internet access
    {
        //show error message
        [dataController showInternetRequiredErrorMessage];
    }
}

- (IBAction)managePatientSymptomHistoryPressed:(id)sender {
    if([dataController internetAccess])
    {
        self.segueToPerform = @"managePatientSymptomHistorySegue";
        //start animating the activity indicator while the app fetches the data from the server
        [loadingIndicator startAnimating];
        //stop the indicator from animating once the segue has been performed with a 2 second delay
        [self performSelector:@selector(stopLoadingAnimationOfActivityIndicatorAndPerformSegue:) withObject:self.loadingIndicator afterDelay:2.0];
    }
    else //if no internet access
    {
        //show error message
        [dataController showInternetRequiredErrorMessage];
    }
    
}

- (IBAction)manageUserRelationsPressed:(id)sender {
    if([dataController internetAccess])
    {
        self.segueToPerform = @"manageUserRelationsSegue";
        //start animating the activity indicator while the app fetches the data from the server
        [loadingIndicator startAnimating];
        //stop the indicator from animating once the segue has been performed with a 2 second delay
        [self performSelector:@selector(stopLoadingAnimationOfActivityIndicatorAndPerformSegue:) withObject:self.loadingIndicator afterDelay:2.0];
        
    }
    else //if no internet access
    {
        //show error message
        [dataController showInternetRequiredErrorMessage];
    }
}


@end
