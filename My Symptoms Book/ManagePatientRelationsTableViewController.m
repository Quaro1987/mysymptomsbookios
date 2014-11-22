//
//  ManagePatientRelationsTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/21/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "ManagePatientRelationsTableViewController.h"
#import "User.h"

@interface ManagePatientRelationsTableViewController ()

@end

@implementation ManagePatientRelationsTableViewController

@synthesize patientRelationsArray, patientRequestsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //populate patient relations array
    User *aUser = [[User alloc] init];
    patientRelationsArray = [aUser getUsersDoctorHasRelationsWith];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if(section==0)
    {
        return 0;
    }
    else
    {
        return [patientRelationsArray count];
    }
}

#pragma mark section functions

//set sections title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //set thet itle for each section
    if(section==0)
    {
        return @"User Requests";
    }
    else
    {
        return @"User Relations";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //configure cells for each sections
    if(indexPath.section==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"patientRequestCell" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"patientRelationCell" forIndexPath:indexPath];
        
        //this cell's patient user
        User *aPatient = [patientRelationsArray objectAtIndex:indexPath.row];
        
        // get full name of doctor
        NSString *patientFullName = [[NSString alloc] initWithString:aPatient.lastName];
        patientFullName = [patientFullName stringByAppendingString:@" "];
        patientFullName = [patientFullName stringByAppendingString:aPatient.firstName];
        //configue cell labels
        cell.textLabel.text = patientFullName;
        
        return cell;
    }
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

@end
