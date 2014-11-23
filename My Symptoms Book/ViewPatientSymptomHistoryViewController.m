//
//  ViewPatientSymptomHistoryViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/23/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "ViewPatientSymptomHistoryViewController.h"
#import "User.h"
#import "Symptomhistory.h"

@interface ViewPatientSymptomHistoryViewController ()

@end

@implementation ViewPatientSymptomHistoryViewController

@synthesize symptomTitleLabel, dateSymptomAddedLabel, dateSymptomSeenLabel, characterizationLabel, thisSymptomHistory, thisUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    symptomTitleLabel.text = thisSymptomHistory.symptomTitle;
    dateSymptomSeenLabel.text = thisSymptomHistory.dateSymptomFirstSeen;
    dateSymptomAddedLabel.text = thisSymptomHistory.dateSymptomAdded;
    characterizationLabel.text = thisSymptomHistory.symptomFlag;
    
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

- (IBAction)selectDiagnosisPressed:(id)sender {
}
@end
