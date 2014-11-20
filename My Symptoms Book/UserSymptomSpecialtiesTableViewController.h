//
//  UserSymptomSpecialtiesTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/20/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface UserSymptomSpecialtiesTableViewController : UITableViewController

//properties
@property (nonatomic, strong) NSMutableArray *userSymptomSpecialtiesArray;

@property (nonatomic, strong) User *currentUser;
@end
