//
//  PickDateSymptomSeenViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/2/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "PickDateSymptomSeenViewController.h"
#import "Symptom.h"
#import "DataAndNetFunctions.h"

@interface PickDateSymptomSeenViewController ()

@end

@implementation PickDateSymptomSeenViewController

@synthesize datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    //set the maximum date the user can input to today's date
    [datePicker setMaximumDate:[NSDate date]];
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

- (IBAction)saveSymptomButtonPressed:(id)sender {
}
@end
