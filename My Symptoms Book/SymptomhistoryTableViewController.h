//
//  SymptomhistoryTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/11/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface SymptomhistoryTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>


//properties
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) IBOutlet UISearchBar *symptomHistorySearchBar;

@property (nonatomic, strong) User *currentUser;

@property (nonatomic, strong) NSMutableArray *userSymptomhistoryArray;
@property (nonatomic, strong) NSMutableArray *filteredSymptomhistoryArray;
//functions

-(void)filterSymptomhistoryForText:(NSString *) searchText;

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString;

@end
