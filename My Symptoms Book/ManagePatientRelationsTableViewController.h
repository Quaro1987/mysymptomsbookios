//
//  ManagePatientRelationsTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/21/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagePatientRelationsTableViewController : UITableViewController

//properties
@property (nonatomic, strong) NSMutableArray *patientRequestsArray;

@property (nonatomic, strong) NSMutableArray *patientRelationsArray;

@end
