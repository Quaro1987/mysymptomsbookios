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

@synthesize userSymptomhistoryArray, currentUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get the user's symptom history
    Symptomhistory *symptomHistoryObject = [[Symptomhistory alloc] init];
    //get the users password
    NSString *password = [SSKeychain passwordForService:@"MySymptomsBook" account:currentUser.username];
    
   userSymptomhistoryArray = [symptomHistoryObject getSymptomhistoryForUser:currentUser.username andWithPassword:password];
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
    return [userSymptomhistoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"symptomHistory" forIndexPath:indexPath];
    
    Symptomhistory *aSymptomhistoryObejct;
    //get the symptomhistory at this location
    aSymptomhistoryObejct = [userSymptomhistoryArray objectAtIndex:indexPath.row];
    
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

@end
