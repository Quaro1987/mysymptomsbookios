//
//  LogInViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
//properties
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
//functions
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)backgroundClick:(id)sender;
@end
