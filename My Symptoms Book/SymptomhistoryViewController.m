//
//  SymptomhistoryViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/13/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "SymptomhistoryViewController.h"
#import "Symptomhistory.h"
#import "CheckSymptomViewController.h"
#import "SSKeychain.h"
#import "FindDoctorTableViewController.h"
#import "DataAndNetFunctions.h"
@interface SymptomhistoryViewController ()

@end

@implementation SymptomhistoryViewController

@synthesize dateSymptomAddedLabel, dateSymptomFirstSeenLabel, characterizationLabel, symptomButton, selectedSymptomhistoryEntry,
findingDoctorViewLoadingIndicator, findDoctorButton;

- (void)viewDidLoad {
    
    dateSymptomAddedLabel.text = selectedSymptomhistoryEntry.dateSymptomAdded;
    dateSymptomFirstSeenLabel.text = selectedSymptomhistoryEntry.dateSymptomFirstSeen;
#warning finish implementing this
    
    //update label color and text
    characterizationLabel.textColor = [selectedSymptomhistoryEntry getCharacterizationLabelColor];
    characterizationLabel.text = [selectedSymptomhistoryEntry getCharacterizationLabelText];

    [symptomButton setTitle:selectedSymptomhistoryEntry.symptomTitle forState:UIControlStateNormal];
    
    //check if there is internet access and hide the find doctor button if there isn't
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    
    if(![dataController internetAccess])
    {
        findDoctorButton.hidden = true;
    }
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"symptomDetailsSegue"])
    {
        CheckSymptomViewController *destinationController = [segue destinationViewController];
        destinationController.selectedSymptomCode = selectedSymptomhistoryEntry.symptomCode;
    }
    else if([[segue identifier] isEqualToString:@"findDoctorSegue"])
    {
        FindDoctorTableViewController *destinationController = [segue destinationViewController];
        destinationController.thisSymptomhistoryRecord = selectedSymptomhistoryEntry;
    }
    
}

//function for when the user presses the find doctor button
- (IBAction)findDoctorPressed:(id)sender {
    //start animating the activity indicator while the app fetches the data from the server
    [findingDoctorViewLoadingIndicator startAnimating];
    //stop the indicator from animating once the segue has been performed with a 2 second delay
    [self performSelector:@selector(stopLoadingAnimationOfActivityIndicatorAndPerformSegue:) withObject:self.findingDoctorViewLoadingIndicator afterDelay:2.0];
}

//stop loading animation and perform segue
- (void)stopLoadingAnimationOfActivityIndicatorAndPerformSegue: (UIActivityIndicatorView *)spinner {
    //stop loading animation
    [spinner stopAnimating];
    //perform findDoctorSegue
    [self performSegueWithIdentifier:@"findDoctorSegue" sender:nil];
}
@end
