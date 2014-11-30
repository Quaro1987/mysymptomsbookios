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
#import "User.h"
#import "SSKeychain.h"
#import "Symptomhistory.h"

@interface PickDateSymptomSeenViewController ()

@end

@implementation PickDateSymptomSeenViewController

@synthesize datePicker, currentUser, password, selectedSymptom;

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
    Symptomhistory *symptomHistory = [[Symptomhistory alloc]init];
        
    //add symptom
    [symptomHistory addForUserTheSymptom:selectedSymptom.symptomTitle withSymptomCode:selectedSymptom.symptomCode andDateFirstSeen:[self getInputedDate]];
    
    
}

//return the inputed date in the appropriate format
-(NSString *)getInputedDate
{
    NSDate *selectedDate = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //set date format
    [dateFormatter setDateFormat:@"yyyy/MM/d"];
    //turnd ate into string
    NSString *inputedDateString = [dateFormatter stringFromDate:selectedDate];
    
    return inputedDateString;
}
@end
