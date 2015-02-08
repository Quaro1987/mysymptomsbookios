//
//  SymptomCategoryTableViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/31/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "SymptomCategoryTableViewController.h"
#import "DataAndNetFunctions.h"
#import "SymptomSelectTableViewController.h"

@interface SymptomCategoryTableViewController ()

@end

@implementation SymptomCategoryTableViewController

- (void)viewDidLoad {
    _navigationBar.title = @"Pick a Symptom Category";
    
    [super viewDidLoad];
    
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

//configure the cells of the table view
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
    //when a symptom category cell is selected, change views
    if([[segue identifier] isEqualToString:@"showSymptomsSegue"])
    {
        //get selected table cell
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        
        //create destination controller
        SymptomSelectTableViewController *destinationController = [segue destinationViewController];
        
        //copy selection
        destinationController.selectedCategory = selectedCell.textLabel.text;
    }
}


#pragma mark functions

//return an array with all symptom categories
-(NSArray *)getSymptomsCategoryArray
{
    //create controller to get data file path
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    //copy the contents of the file into an array
    NSArray *symptomsCategoryArray = [[NSArray alloc] initWithContentsOfFile:[dataController getSymptomCategoriesFilePath]];
    return symptomsCategoryArray;
}

//force view on portrait
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
