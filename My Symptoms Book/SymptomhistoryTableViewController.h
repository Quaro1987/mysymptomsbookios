//
//  SymptomhistoryTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/11/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface SymptomhistoryTableViewController : UITableViewController

//properties
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableArray *userSymptomhistoryArray;
//functions

@end
