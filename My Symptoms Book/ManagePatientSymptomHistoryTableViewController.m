//
//  ManagePatientSymptomHistoryTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/23/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "ManagePatientSymptomHistoryTableViewController.h"
#import "User.h"
#import "DoctorRequest.h"
#import "SymptomhistoryTableViewController.h"

@interface ManagePatientSymptomHistoryTableViewController ()

@end

@implementation ManagePatientSymptomHistoryTableViewController

@synthesize patientUsersArray, patientUsersWithNewSymptomsAddedIDsArray;

- (void)viewDidLoad {
    
    
    //populate arrays
    User *aPatient = [[User alloc] init];
    DoctorRequest *aRequest = [[DoctorRequest alloc] init];
    
    patientUsersArray = [aPatient getUsersDoctorHasRelationOfType:@"relations"];
    patientUsersWithNewSymptomsAddedIDsArray = [aRequest getIDsOfPatientUsersWithNewSymptomsAdded];
    [super viewDidLoad];
    
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
    return [patientUsersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"patientUserCell" forIndexPath:indexPath];
    
    //this cell's patient user
    User *thisPatient = [patientUsersArray objectAtIndex:indexPath.row];
    
    
    // get full name of patient
    NSString *patientFullName = [[NSString alloc] initWithString:thisPatient.lastName];
    patientFullName = [patientFullName stringByAppendingString:@" "];
    patientFullName = [patientFullName stringByAppendingString:thisPatient.firstName];
    //configue cell labels
    cell.textLabel.text = patientFullName;
    
    //if the patient has a new symptom added, add sub title
    if([patientUsersWithNewSymptomsAddedIDsArray containsObject:thisPatient.userID])
    {
        cell.detailTextLabel.text = @"New Symptom Added";
    }
    else
    {
        cell.detailTextLabel.text = NULL;
    }
    
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
    if([[segue identifier] isEqualToString:@"patientSymptomHistorySegue"])
    {
        SymptomhistoryTableViewController *destinationController =  [segue destinationViewController];
        destinationController.thisUser = [patientUsersArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}


@end
