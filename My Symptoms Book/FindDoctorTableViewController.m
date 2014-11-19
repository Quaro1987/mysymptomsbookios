//
//  FindDoctorTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/18/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "FindDoctorTableViewController.h"
#import "SSKeychain.h"
#import "User.h"
#import "DoctorUser.h"
#import "Symptomhistory.h"
#import "AddDoctorViewController.h"

@interface FindDoctorTableViewController ()

@end

@implementation FindDoctorTableViewController

@synthesize doctorsArray, currentUser, thisSymptomhistoryRecord, navigationBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get saved user
    User *currentUser = [[User alloc] initWithSavedUser];
    //get the users password
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];

    //change title
    NSString *titleString = @"Find Doctor for ";
    titleString = [titleString stringByAppendingString:thisSymptomhistoryRecord.symptomTitle];
    navigationBar.title = titleString;
    
    //populate array with doctors for this symptom
    DoctorUser *aDoctor = [[DoctorUser alloc] init];
    doctorsArray = [aDoctor getDoctorsForUser:currentUser.username andPassword:password forSymptomWithSymptomCode:thisSymptomhistoryRecord.symptomCode];

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
    return [doctorsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doctorCell" forIndexPath:indexPath];
    
    // Configure the cell...
    //get the doctor
    DoctorUser *theDoctor = [doctorsArray objectAtIndex:indexPath.row];
    NSString *doctorFullName = [[NSString alloc] initWithString:theDoctor.lastName];
    doctorFullName = [doctorFullName stringByAppendingString:@" "];
    doctorFullName = [doctorFullName stringByAppendingString:theDoctor.firstName];
    //configue cell labels
    cell.textLabel.text = doctorFullName;
    cell.detailTextLabel.text = theDoctor.doctorSpecialty;
    
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

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //perform segue
    [self performSegueWithIdentifier:@"doctorSegue" sender:tableView];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"doctorSegue"])
    {
        AddDoctorViewController *destinationController = [segue destinationViewController];
        destinationController.selectedDoctor = [doctorsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        destinationController.thisSymptomhistoryEntry = thisSymptomhistoryRecord;
    }
    
}


@end
