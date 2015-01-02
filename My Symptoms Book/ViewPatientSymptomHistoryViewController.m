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
#import "ContactPatientViewController.h"
#import "DataAndNetFunctions.h"

@interface ViewPatientSymptomHistoryViewController ()

@end

@implementation ViewPatientSymptomHistoryViewController

@synthesize symptomTitleLabel, dateSymptomAddedLabel, dateSymptomSeenLabel, characterizationLabel, thisSymptomHistory, thisUser, dataController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if segue contactPatientSegue
    if([[segue identifier] isEqualToString:@"contactPatientSegue"])
    {
        //create destination controller
        ContactPatientViewController *destinationController = [segue destinationViewController];
        //copy user
        destinationController.patientUser = thisUser;
    }
}


//show action sheet with diagnosis options when select d iagnosis is pressed
- (IBAction)selectDiagnosisPressed:(id)sender {
    //if there is no internet access go to initial menu
    if(![dataController internetAccess])
    {
        //take to main menu
        [dataController takeToMainMenuForNavicationController:self.navigationController];
    }
    //else if([dataController internetAccess]) //perform action
    //{
        //create action sheet
        UIActionSheet *diagnosisActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Diagnosis" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"Low Danger", @"Mild Danger", @"High Danger", nil];
        //show aciton sheet
        [diagnosisActionSheet showInView:self.view];
    //}
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
    
    //if there is no internet access go to initial menu
    /*if(![dataController internetAccess])
    {
        //take to main menu
        [dataController takeToMainMenuForNavicationController:self.navigationController];
    }
    else //perform action
    { */
        //update label color and text
        characterizationLabel.textColor = [thisSymptomHistory getCharacterizationLabelColor];
        characterizationLabel.text = [thisSymptomHistory getCharacterizationLabelText];
        //send update to server
        [thisSymptomHistory updateCharacterizationByDoctor];
    //}
}

@end
