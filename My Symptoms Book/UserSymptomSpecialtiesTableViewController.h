//
//  UserSymptomSpecialtiesTableViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/20/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User, Symptom;

@interface UserSymptomSpecialtiesTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

//properties
@property (nonatomic, strong) NSMutableArray *userSymptomSpecialtiesArray;
@property (nonatomic, strong) NSMutableArray *filteredUserSymptomSpecialtiesArray;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, assign) Symptom *symptomSpecialtyForDelete;

@property (strong, nonatomic) IBOutlet UISearchBar *symptomSearchBar;

//filtering functions
-(void)filterSymptomsForText:(NSString *)searchText;

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString;

//delete specialty functions

-(UIAlertView *)alertStatus:(NSString *)alertBody andAlertTitle:(NSString *)alertTitle;

-(void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex;


@end
