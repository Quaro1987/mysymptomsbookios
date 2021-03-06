//
//  ViewPatientSymptomHistoryViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/23/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User, Symptomhistory, DataAndNetFunctions;

@interface ViewPatientSymptomHistoryViewController : UIViewController

//properties
@property (nonatomic, strong) User *thisUser;
@property (nonatomic, strong) Symptomhistory *thisSymptomHistory;
@property (nonatomic, strong) DataAndNetFunctions *dataAndNetController;

//label properties
@property (weak, nonatomic) IBOutlet UILabel *symptomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateSymptomSeenLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateSymptomAddedLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterizationLabel;

//butons pressed functions
- (IBAction)selectDiagnosisPressed:(id)sender;
- (IBAction)contactPatientPressed:(id)sender;

-(void)actionSheet:(UIActionSheet *)actionSheetMenu clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
