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

@interface SymptomhistoryViewController ()

@end

@implementation SymptomhistoryViewController

@synthesize dateSymptomAddedLabel, dateSymptomFirstSeenLabel, characterizationLabel, symptomButton, selectedSymptomhistoryEntry;

- (void)viewDidLoad {
    
    dateSymptomAddedLabel.text = selectedSymptomhistoryEntry.dateSymptomAdded;
    dateSymptomFirstSeenLabel.text = selectedSymptomhistoryEntry.dateSymptomFirstSeen;
    //fix this
    if([selectedSymptomhistoryEntry.symptomFlag isEqual:(id) [NSNull null]] || selectedSymptomhistoryEntry.symptomFlag.length == 0)
    {
        characterizationLabel.text = @"No Characterization";
    }
    else
    {
    characterizationLabel.text = selectedSymptomhistoryEntry.symptomFlag;
    
    }
    [symptomButton setTitle:selectedSymptomhistoryEntry.symptomTitle forState:UIControlStateNormal];
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



- (IBAction)findDoctorPressed:(id)sender {
}
@end
