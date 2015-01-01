//
//  SymptomhistoryCategorySelectTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 12/31/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "SymptomhistoryCategorySelectTableViewController.h"
#import "DataAndNetFunctions.h"
#import "SymptomhistoryTableViewController.h"
#import "Symptomhistory.h"
#import "User.h"

@interface SymptomhistoryCategorySelectTableViewController ()

@end

@implementation SymptomhistoryCategorySelectTableViewController

@synthesize symptomHistoryCategoriesArray, userSymptomhistoryArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create datacontroller
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    
    //populate categories array with all categories
    NSArray *tempSymptomHistoryCategoriesArray = [[NSArray alloc] initWithContentsOfFile:[dataController getSymptomCategoriesFilePath]];
    NSMutableArray *anArray = [[NSMutableArray alloc] init];
   
        //get the user's symptom history
    Symptomhistory *symptomHistoryObject = [[Symptomhistory alloc] init];
    
    //populate array with user's symptom history
    User *currentUser = [[User alloc] initWithSavedUser];
    userSymptomhistoryArray = [symptomHistoryObject getSymptomhistoryForUser:currentUser];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self getSymptomsCategoryArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"symptomCategoryCell" forIndexPath:indexPath];
    
    //copy the category's title into the text of the cell
    cell.textLabel.text = [[self getSymptomsCategoryArray] objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //get selected table cell
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    
    //create empty array to copy selected symptom history
    NSMutableArray *userSymptomHistoryArray = [[NSMutableArray alloc] init];
    //check if the user has selected all symptoms or a category
    if([selectedCell.textLabel.text isEqualToString:@"All"])
    {
        SymptomhistoryTableViewController *destinationController = [segue destinationViewController];
        //display all the symptom history for the selected user
        destinationController.userSymptomhistoryArray = self.userSymptomhistoryArray;
    }
    else
    {
        //get selected category first 2 characters
        NSString *selectedCategoryString = [selectedCell.textLabel.text substringToIndex:2];
        SymptomhistoryTableViewController *destinationController = [segue destinationViewController];
        //display all the symptom history for the selected user for the selected category
        Symptomhistory *aSymptomHistoryEntry = [[Symptomhistory alloc] init];
        destinationController.userSymptomhistoryArray = [aSymptomHistoryEntry filterArray:self.userSymptomhistoryArray forCategory:selectedCategoryString];

    }
}


#pragma mark functions

//return an array with all symptom categories
-(NSArray *)getSymptomsCategoryArray
{
    //create controller to get data file path
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    //copy the contents of the file into an array
    NSArray *tempArray = [[NSArray alloc] initWithContentsOfFile:[dataController getSymptomCategoriesFilePath]];
    //create the array that will be returned
    NSMutableArray *symptomsCategoryArray = [[NSMutableArray alloc] init];
    //create the all string and add it to the array
    NSString *allString = @"All";
    [symptomsCategoryArray addObject:allString];
    //add the rest of the categories into the array
    [symptomsCategoryArray addObjectsFromArray:tempArray];
    //return all the symptom history categories array.
    return symptomsCategoryArray;
}


@end
