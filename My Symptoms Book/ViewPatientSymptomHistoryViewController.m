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
    
    //set up labels
    symptomTitleLabel.text = thisSymptomHistory.symptomTitle;
    dateSymptomSeenLabel.text = thisSymptomHistory.dateSymptomFirstSeen;
    dateSymptomAddedLabel.text = thisSymptomHistory.dateSymptomAdded;
    //get label color and text
    characterizationLabel.textColor = [thisSymptomHistory getCharacterizationLabelColor];
    characterizationLabel.text = [thisSymptomHistory getCharacterizationLabelText];
    
    
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

//show action sheet with diagnosis options when select d iagnosis is pressed
- (IBAction)selectDiagnosisPressed:(id)sender {
    //create action sheet
    UIActionSheet *diagnosisActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Diagnosis" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"Low Danger", @"Mild Danger", @"High Danger", nil];
    //show aciton sheet
    [diagnosisActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheetMenu clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        thisSymptomHistory.symptomFlag = @"1";
    }
    else if(buttonIndex==1)
    {
        thisSymptomHistory.symptomFlag = @"2";
    }
    else if (buttonIndex==2)
    {
        thisSymptomHistory.symptomFlag = @"3";
    }
    //update label color and text
    characterizationLabel.textColor = [thisSymptomHistory getCharacterizationLabelColor];
    characterizationLabel.text = [thisSymptomHistory getCharacterizationLabelText];
    //send update to server
    [thisSymptomHistory updateCharacterizationByDoctor];
}

@end
