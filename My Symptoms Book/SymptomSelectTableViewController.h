//
//  SymptomSelectTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/31/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SymptomSelectTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) IBOutlet UISearchBar *symptomSearchBar;

@property (nonatomic, strong) NSString *selectedCategory;

@property (nonatomic, strong) NSMutableArray *filteredSymptomsArray;
@property (nonatomic, strong) NSMutableArray *queryResultSymptomsArray;

//functions
-(NSMutableArray *)getSymptomsWithCategory:(NSString *)symptomCategory;

-(void)filterSymptomsForText:(NSString *) searchText andScope:(NSString *) scope;

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString;

@end
