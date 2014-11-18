//
//  FindDoctorTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/18/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User, Symptomhistory;

@interface FindDoctorTableViewController : UITableViewController

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) Symptomhistory *thisSymptomhistoryRecord;
@property (nonatomic, strong) NSMutableArray *doctorsArray;

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end
