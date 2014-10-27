//
//  ViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "InitialViewController.h"
#import "LogInViewController.h"
#import "RegisterViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    //set title to my symptoms book when the inital view loads
    self.navigationBar.title = @"My Symptoms Book";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark navigation functions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //check which button was pressed
    if([[segue identifier] isEqualToString:@"loginSegue"])
    {
        //if it was log in button, go to log in view
        LogInViewController *destinationController = [segue destinationViewController];
    }
    else if([[segue identifier] isEqualToString:@"registerSegue"])
    {
        //if register button got to register view
        RegisterViewController *destinationController = [segue destinationViewController];
    }
}
@end
