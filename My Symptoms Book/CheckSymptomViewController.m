//
//  CheckSymptomViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/16/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "CheckSymptomViewController.h"
#import "Symptom.h"

@interface CheckSymptomViewController ()

@end

@implementation CheckSymptomViewController

@synthesize selectedSymptom, selectedSymptomCode, symptomTitleLabel, symptomCodeLabel, symptomInclusionsLabel, symptomExclusionsLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set selectedSymptom
    [self setSymmptomOfSelfForSymptomWithCode:selectedSymptomCode];
    
    //set labels with symptomdetails
    symptomTitleLabel.text = selectedSymptom.symptomTitle;
    symptomCodeLabel.text = selectedSymptom.symptomCode;
    symptomInclusionsLabel.text = selectedSymptom.symptomInclusions;
    symptomExclusionsLabel.text = selectedSymptom.symptomExclusions;
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

//set the symptom for the inputed symptom code
-(void)setSymmptomOfSelfForSymptomWithCode: (NSString *) symptomCode
{
    Symptom *newSymptom = [[Symptom alloc] init];
    //get the selected symptom
    selectedSymptom = [newSymptom getSymptomWithSymptomCode:symptomCode];
}

//force view on portrait
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
