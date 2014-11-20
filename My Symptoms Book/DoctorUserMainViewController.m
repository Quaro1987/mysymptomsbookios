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

@interface DoctorUserMainViewController ()

@end

@implementation DoctorUserMainViewController

@synthesize currentUser, navigationBar, segueToPerform, loadingIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
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
    self.segueToPerform = @"manageSpecialtiesSegue";
    //start animating the activity indicator while the app fetches the data from the server
    [loadingIndicator startAnimating];
    //stop the indicator from animating once the segue has been performed with a 2 second delay
    [self performSelector:@selector(stopLoadingAnimationOfActivityIndicatorAndPerformSegue:) withObject:self.loadingIndicator afterDelay:2.0];
}


@end
