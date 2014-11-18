//
//  SymptomViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/1/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "SymptomViewController.h"
#import "Symptom.h"
#import "PickDateSymptomSeenViewController.h"
@interface SymptomViewController ()

@end

@implementation SymptomViewController

@synthesize navigationBar, thisSymptom, titleLabel, inclusionsLabel, exclusionsLabel, codeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navigationBar.title = thisSymptom.symptomTitle;
    
   //copy thisSymptom attributes into labels
    titleLabel.text = thisSymptom.symptomTitle;
    codeLabel.text = thisSymptom.symptomCode;
    inclusionsLabel.text = thisSymptom.symptomInclusions;
    exclusionsLabel.text = thisSymptom.symptomExclusions;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"addSymptomSegue"])
    {
        PickDateSymptomSeenViewController *destinationController = [segue destinationViewController];
        destinationController.selectedSymptom = thisSymptom;
    }
}


@end