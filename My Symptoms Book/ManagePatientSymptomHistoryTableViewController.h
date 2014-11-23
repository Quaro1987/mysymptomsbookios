//
//  ManagePatientSymptomHistoryTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/23/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagePatientSymptomHistoryTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *patientUsersArray;
@property (nonatomic, strong) NSMutableArray *patientUsersWithNewSymptomsAddedIDsArray;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end
