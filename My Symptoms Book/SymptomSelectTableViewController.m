//
//  SymptomSelectTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/31/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "SymptomSelectTableViewController.h"
#import "FMDB.h"
#import "DataAndNetFunctions.h"
#import "Symptom.h"
#import "SymptomViewController.h"

@interface SymptomSelectTableViewController ()

@end

@implementation SymptomSelectTableViewController
//synthesize properties
@synthesize selectedCategory, queryResultSymptomsArray, navigationBar, filteredSymptomsArray, symptomSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    //set view title
    navigationBar.title = selectedCategory;
    //get all the symptoms with the selected symptom category
    queryResultSymptomsArray = [self getSymptomsWithCategory:selectedCategory];
    //set the filtered array's capacity
    filteredSymptomsArray = [NSMutableArray arrayWithCapacity:[queryResultSymptomsArray count]];
    
    [self.tableView reloadData];
    
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
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredSymptomsArray count];
    }
    else
    {
        //get the symptoms of this cell
        return [queryResultSymptomsArray count];
    }
    // Return the number of rows in the section.
    
}

//configure cell function
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"symptomCell" forIndexPath:indexPath];
    
    Symptom *someSymptom;
    //check if the table is the full results array or the filtered one and display the appropriate entries
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        someSymptom = [filteredSymptomsArray objectAtIndex:indexPath.row];
    }
    else
    {
        //get the symptoms of this cell
        someSymptom = [queryResultSymptomsArray objectAtIndex:indexPath.row];
    }
    
    //set the title to the symptoms title and the subtitle to the symptom's inclusions
    cell.textLabel.text = someSymptom.symptomTitle;
    cell.detailTextLabel.text = someSymptom.symptomInclusions;
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"viewSymptomSegue" sender:tableView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"viewSymptomSegue"])
    {
        SymptomViewController *destinationController = [segue destinationViewController];
        
        //check if it's the filtered or the normal table view and get the symptom object of the view
        if(sender == self.searchDisplayController.searchResultsTableView)
        {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            destinationController.thisSymptom = [filteredSymptomsArray objectAtIndex:[indexPath row]];
        }
        else
        {
            destinationController.thisSymptom = [queryResultSymptomsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        }
    }
}


#pragma mark my functions

//get the symptoms with the selected category
-(NSMutableArray *)getSymptomsWithCategory:(NSString *)symptomCategory
{
    //create datacontroller
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    
    //get database
    FMDatabase *database = [FMDatabase databaseWithPath:[dataController getMySymptomsBookDatabasePath]];
    
    //if database doesn't open, end function and reutnr null
    if(![database open])
    {
        return NULL;
    }
    
    //query for symptoms
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM tbl_symptoms WHERE symptomCategory = \"%@\" ORDER by title ASC;", symptomCategory];
    FMResultSet *symptomsResult = [database executeQuery: queryString];
    //init symptoms array
    NSMutableArray *symptomsWithSelectedCategoryArray = [[NSMutableArray alloc] init];
    
    //loop through results, create symptom object for each, and push into array
    while([symptomsResult next])
    {
        //copy string values for row into temporary strings
        NSString *tempSymCode = [symptomsResult stringForColumn:@"symptomCode"];
        NSString *tempSymTitle = [symptomsResult stringForColumn:@"title"];
        NSString *tempSymInclusions = [symptomsResult stringForColumn:@"inclusions"];
        NSString *tempSymExclusions = [symptomsResult stringForColumn:@"exclusions"];
        NSString *tempSymCategory = [symptomsResult stringForColumn:@"symptomCategory"];
        //init symptoms object
        Symptom *thisSymptom = [[Symptom alloc] initWithSymptomCode:tempSymCode andSymptomTitle:tempSymTitle andSymptomInclusions:tempSymInclusions andSymptomExclusions:tempSymExclusions andSymptomCategory:tempSymCategory];
        //add symptom to results array
        [symptomsWithSelectedCategoryArray addObject:thisSymptom];
    }
    
    //return result
    return symptomsWithSelectedCategoryArray;
}

//function to filter the table view content
-(void)filterSymptomsForText:(NSString *)searchText
{
    //remove all objects from the filteredSymptomsArray
    [filteredSymptomsArray removeAllObjects];
    
    //filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.symptomTitle contains[c] $searchString) OR (SELF.symptomInclusions  contains[c] $searchString)"];
    
    //populate filteredSymptomsArray with symptoms containing hte title or inclusions like the search string
    filteredSymptomsArray = [NSMutableArray arrayWithArray:[queryResultSymptomsArray filteredArrayUsingPredicate:[predicate predicateWithSubstitutionVariables:@{@"searchString":searchText} ]]];
}

#pragma mark UISearchController Delegate Methods
-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterSymptomsForText:searchString];
    //return yes to update search table view
    return YES;
}
@end
