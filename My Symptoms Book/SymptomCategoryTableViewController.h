//
//  SymptomCategoryTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/31/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SymptomCategoryTableViewController : UITableViewController

-(NSArray *)getSymptomsCategoryArray;

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@end
