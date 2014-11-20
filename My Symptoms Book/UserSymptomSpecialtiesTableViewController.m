//
//  UserSymptomSpecialtiesTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/20/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "UserSymptomSpecialtiesTableViewController.h"
#import "User.h"
#import "Symptom.h"
#import "DoctorSymptomSpecialty.h"

@interface UserSymptomSpecialtiesTableViewController ()

@end

@implementation UserSymptomSpecialtiesTableViewController

@synthesize userSymptomSpecialtiesArray, currentUser, filteredUserSymptomSpecialtiesArray, symptomSearchBar, symptomSpecialtyForDelete;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Symptom *aSymptom = [[Symptom alloc] init];
    //populate array with user's symptom specialties
    userSymptomSpecialtiesArray = [aSymptom getSymptomSpecialtiesForDoctorUser:currentUser];
    
    //set the filtered array's capacity
    filteredUserSymptomSpecialtiesArray = [NSMutableArray arrayWithCapacity:[userSymptomSpecialtiesArray count]];
    
    [self.tableView reloadData];
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
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredUserSymptomSpecialtiesArray count];
    }
    else
    {
        return [userSymptomSpecialtiesArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"symptomSpecialtyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Symptom *someSymptom;
    
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        someSymptom = [filteredUserSymptomSpecialtiesArray objectAtIndex:indexPath.row];
    }
    else
    {
        someSymptom = [userSymptomSpecialtiesArray objectAtIndex:indexPath.row];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark my functions

//function to filter the table view content
-(void)filterSymptomsForText:(NSString *)searchText
{
    //remove all objects from the filteredSymptomsArray
    [filteredUserSymptomSpecialtiesArray removeAllObjects];
    
    //filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.symptomTitle contains[c] $searchString) OR (SELF.symptomInclusions  contains[c] $searchString)"];
    
    //populate filteredSymptomsArray with symptoms containing hte title or inclusions like the search string
    filteredUserSymptomSpecialtiesArray = [NSMutableArray arrayWithArray:[userSymptomSpecialtiesArray filteredArrayUsingPredicate:[predicate predicateWithSubstitutionVariables:@{@"searchString":searchText} ]]];
}

#pragma mark UISearchController Delegate Methods
-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterSymptomsForText:searchString];
    //return yes to update search table view
    return YES;
}

#pragma mark delete specialty functions

//show alert message for deletion
-(UIAlertView *)alertStatus:(NSString *)alertBody andAlertTitle:(NSString *)alertTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertBody
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Delete", nil];
    return alertView;
}

//when delete clicked, delete entry
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        //delete doctor specialty
        DoctorSymptomSpecialty *symptomSpecialty = [[DoctorSymptomSpecialty alloc] init];
        
        //get the selected symptom
        
        Symptom *symptomForDelete = [[Symptom alloc] init];
        
        if(self.tableView == self.searchDisplayController.searchResultsTableView)
        {
            //delete symptom specialty
            [symptomSpecialty deleteDoctorSymptomSpecialtyWithSymptomCode:symptomSpecialtyForDelete.symptomCode];
            //remove symptom from table
            [userSymptomSpecialtiesArray removeObject:symptomSpecialtyForDelete];
            [filteredUserSymptomSpecialtiesArray removeObject:symptomSpecialtyForDelete];
            //reload table data
            [self.searchDisplayController.searchResultsTableView reloadData];
            
        }
        else
        {
            //delete symptom specialty
            [symptomSpecialty deleteDoctorSymptomSpecialtyWithSymptomCode:symptomSpecialtyForDelete.symptomCode];
            //remove symptom fromt able
            [userSymptomSpecialtiesArray removeObject:symptomSpecialtyForDelete];
            //reload table data
            [self.tableView reloadData];
        }
        
        
    }
}

//when a user selects a symptom specialty, show the notification message for it
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Symptom *thisSymptom = [[Symptom alloc] init];
    
    //get the selected symptom
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        thisSymptom = [filteredUserSymptomSpecialtiesArray objectAtIndex:indexPath.row];
    }
    else
    {
        thisSymptom = [userSymptomSpecialtiesArray objectAtIndex:indexPath.row];
    }
    
    //copy that symptom specialty the user has selected
    symptomSpecialtyForDelete = thisSymptom;
    
    //show alert with symptom details
    [[self alertStatus:thisSymptom.symptomInclusions andAlertTitle:thisSymptom.symptomTitle] show];
}

@end