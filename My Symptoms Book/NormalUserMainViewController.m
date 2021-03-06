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
#import "SymptomCategoryTableViewController.h"
#import "Symptomhistory.h"
#import "SymptomhistoryTableViewController.h"
#import "ManageRelationsTableViewController.h"

@interface NormalUserMainViewController ()

@end

@implementation NormalUserMainViewController

@synthesize currentUser, userSymptomhistoryActivityIndicator, segueToPerform;

- (void)viewDidLoad {
    currentUser = [[User alloc] initWithSavedUser];
    
    self.navigationBar.title = @"My Symptoms Book";
    //hide back button
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    if([dataController internetAccess])
    {
        Symptomhistory *symptomHistory = [[Symptomhistory alloc] init];
        //get the saved symptoms
        NSMutableArray *savedSymptoms = [symptomHistory getSavedSymptomsForUser];
        //if there are saved symptoms then send them to the server
        if([savedSymptoms count]!=0)
        {
            NSString *result = [symptomHistory batchPostSavedSymptoms];
            NSLog(result);
        }
    }
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if add symptom selected go to symptom category pick table view controller
    if([[segue identifier] isEqualToString:@"addSymptomSegue"])
    {
        SymptomCategoryTableViewController *destinationController = [segue destinationViewController];
    }
    else if([[segue identifier] isEqualToString:@"userSymptomHistorySegue"])
    {
        
        SymptomhistoryTableViewController *destinationController = [segue destinationViewController];
       // destinationController.thisUser = currentUser;
    }
    else if ([[segue identifier] isEqualToString:@"manageDoctorsSegue"])
    {
        ManageRelationsTableViewController *destinationController = [segue destinationViewController];
    }
}

//functions for when the user presses the symptom history button
- (IBAction)symptomHistoryPressed:(UIButton *)sender {
    self.segueToPerform = @"userSymptomHistorySegue";
    //start animating the activity indicator while the app fetches the data from the server
    [userSymptomhistoryActivityIndicator startAnimating];
    //stop the indicator from animating once the segue has been performed with a 2 second delay
    [self performSelector:@selector(stopLoadingAnimationOfActivityIndicatorAndPerformSegue:) withObject:self.userSymptomhistoryActivityIndicator afterDelay:2.0];
}

-(IBAction)manageDoctorsPressed:(UIButton *)sender
{
    self.segueToPerform = @"manageDoctorsSegue";
    //start animating the activity indicator while the app fetches the data from the server
    [userSymptomhistoryActivityIndicator startAnimating];
    //stop the indicator from animating once the segue has been performed with a 2 second delay
    [self performSelector:@selector(stopLoadingAnimationOfActivityIndicatorAndPerformSegue:) withObject:self.userSymptomhistoryActivityIndicator afterDelay:2.0];
}

//stop loading animation and perform segue
- (void)stopLoadingAnimationOfActivityIndicatorAndPerformSegue: (UIActivityIndicatorView *)spinner {
    //stop loading animation
    [spinner stopAnimating];
    //perform usersymptomhistorysegue
    [self performSegueWithIdentifier:self.segueToPerform sender:nil];
}

//if the user selects to log out, delete his details and take him to the initial page
- (IBAction)logoutPressed:(UIButton *)sender
{
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    //log out user function
    [currentUser logoutUser];
     
    //change controller view
    InitialViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"initialView"];
    [self.navigationController pushViewController:destinationController animated:NO];
    
    //notify user
    [dataController alertStatus:@"You have been logged out from My Symptoms Book" andAlertTitle:@"Log Out Succesful"];
}

//force view on portrait
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
