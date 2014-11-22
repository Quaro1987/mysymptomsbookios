//
//  ManageRelationsTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/19/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "ManageRelationsTableViewController.h"
#import "DoctorUser.h"
#import "User.h"
#import "SSKeychain.h"
#import "UserDoctorRelationViewController.h"

@interface ManageRelationsTableViewController ()

@end

@implementation ManageRelationsTableViewController

@synthesize userDoctorsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DoctorUser *doctors = [[DoctorUser alloc] init];
    //get username and apssword
    User *currentUser = [doctors initWithSavedUser];
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    
    //populate users array
    userDoctorsArray = [doctors getDoctorsForUser:currentUser.username andPassword:password forSymptomWithSymptomCode:@"GET DOCTORS"];
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
    return [userDoctorsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doctorCell" forIndexPath:indexPath];
    
    //this cell's doctor user
    DoctorUser *aDoctor = [userDoctorsArray objectAtIndex:indexPath.row];
    
    // get full name of doctor
    NSString *doctorFullName = [[NSString alloc] initWithString:aDoctor.lastName];
    doctorFullName = [doctorFullName stringByAppendingString:@" "];
    doctorFullName = [doctorFullName stringByAppendingString:aDoctor.firstName];
    //configue cell labels
    
    cell.textLabel.text = doctorFullName;

    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"userRelationSegue"])
    {
        UserDoctorRelationViewController *destinationController = [segue destinationViewController];
        destinationController.thisUser = [userDoctorsArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}


@end
