//
//  ManageRelationsTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/19/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DoctorUser;

@interface ManageRelationsTableViewController : UITableViewController

//properties
@property (nonatomic, strong) NSMutableArray *userDoctorsArray;

@end
