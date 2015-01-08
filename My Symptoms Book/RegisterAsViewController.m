//
//  RegisterAsViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 1/8/15.
//  Copyright (c) 2015 Ioannis Pasmatzis. All rights reserved.
//

#import "RegisterAsViewController.h"
#import "RegisterViewController.h"

static int userType;

@interface RegisterAsViewController ()

@end

@implementation RegisterAsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"registerSegue"])
    {
        RegisterViewController *destinationController = [[RegisterViewController alloc] init];
        destinationController = [segue destinationViewController];
        //copy the usertype selection to the destination controller
        destinationController.userType = userType;
    }
}

//if normal user is pressed
- (IBAction)normalUserPressed:(id)sender {
    //set user type to 0
    userType = 0;
    //perform registration page segue
    [self performSegueWithIdentifier:@"registerSegue" sender:self];
}

//if doctor user is pressed
- (IBAction)doctorUserPressed:(id)sender {
    //set user type to 1
    userType = 1;
    //perform registration page segue
    [self performSegueWithIdentifier:@"registerSegue" sender:self];

}
@end
