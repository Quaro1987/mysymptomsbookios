//
//  SymptomhistoryTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/11/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "SymptomhistoryTableViewController.h"
#import "User.h"
#import "Symptomhistory.h"
#import "SSKeychain.h"

@interface SymptomhistoryTableViewController ()

@end

@implementation SymptomhistoryTableViewController

@synthesize userSymptomhistoryArray, currentUser, filteredSymptomhistoryArray, symptomHistorySearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get the user's symptom history
    Symptomhistory *symptomHistoryObject = [[Symptomhistory alloc] init];
    
    //get the users password
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    
    //populate array with user's symptom history
    userSymptomhistoryArray = [symptomHistoryObject getSymptomhistoryForUser:currentUser.username andWithPassword:password];
    
    //set the filtered array's capacity
    filteredSymptomhistoryArray = [NSMutableArray arrayWithCapacity:[userSymptomhistoryArray count]];
    
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
    // Return the number of rows in the section for the normal or filtered array
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredSymptomhistoryArray count];
    }
    else
    {
        return [userSymptomhistoryArray count];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"symptomHistoryCell" forIndexPath:indexPath];
    
    Symptomhistory *aSymptomhistoryObejct;
    
    //check if the table is the full results array or the filtered one and display the appropriate entries
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        aSymptomhistoryObejct = [filteredSymptomhistoryArray objectAtIndex:indexPath.row];
    }
    else
    {
        //get the symptoms of this cell
        aSymptomhistoryObejct = [userSymptomhistoryArray objectAtIndex:indexPath.row];
    }
    
    
    cell.textLabel.text = aSymptomhistoryObejct.symptomTitle;
    cell.detailTextLabel.text = aSymptomhistoryObejct.dateSymptomAdded;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark filtering functions

-(void)filterSymptomhistoryForText:(NSString *) searchText andScope:(NSString *) scope
{
    //empty the filtered array
    [filteredSymptomhistoryArray removeAllObjects];
    
    //filter array for symptomhistory with title equal to the search text
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.symptomTitle contains[c] $searchString)"];
    
    //populate filtered array
    filteredSymptomhistoryArray = [NSMutableArray arrayWithArray:[userSymptomhistoryArray filteredArrayUsingPredicate:[predicate predicateWithSubstitutionVariables:@{@"searchString":searchText}]]];

    if(![scope isEqualToString:@"All"])
    {
        if([scope isEqualToString:@"Today"])
        {
            //get today's date
            NSTimeInterval secondsPast = -86400;
            NSDate * oneDayPast = [NSDate dateWithTimeInterval:secondsPast sinceDate:[NSDate date]];
            
            //create predicate for symptom history added today
            NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.datedAddedInNSDateFormat >= %@", oneDayPast];
            
            //filter temp array with scope
            filteredSymptomhistoryArray = [NSMutableArray arrayWithArray:[filteredSymptomhistoryArray filteredArrayUsingPredicate:scopePredicate ]];
        }
        else if([scope isEqualToString:@"This Week"])
        {
            //get past week's date
            NSTimeInterval secondsPast = -604800;
            NSDate *sevenDaysPast = [NSDate dateWithTimeInterval:secondsPast sinceDate:[NSDate date]];
            
            
            //create predicate for symptom history added 1 week ago
            NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.datedAddedInNSDateFormat >= %@", sevenDaysPast];
            
            //filter temp array with scope
            filteredSymptomhistoryArray = [NSMutableArray arrayWithArray:[filteredSymptomhistoryArray filteredArrayUsingPredicate:scopePredicate ]];
        }
        else if([scope isEqualToString:@"This Month"])
        {
            //get past week's date
            NSTimeInterval secondsPast = -(2.63e+6);
            NSDate *oneMonthPast = [NSDate dateWithTimeInterval:secondsPast sinceDate:[NSDate date]];
            
            
            //create predicate for symptom history added 1 week ago
            NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.datedAddedInNSDateFormat >= %@", oneMonthPast];
            
            //filter temp array with scope
            filteredSymptomhistoryArray = [NSMutableArray arrayWithArray:[filteredSymptomhistoryArray filteredArrayUsingPredicate:scopePredicate ]];
        }
    }
}

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes with the selected scope
    
    [self filterSymptomhistoryForText:searchString
                               andScope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    //return yes to update search table view
    return YES;
}

@end
