//
//  NormalUserMainViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/28/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface NormalUserMainViewController : UIViewController

//properties
@property (nonatomic, strong) User *currentUser;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

//button outlets
- (IBAction)addSymptomPressed:(id)sender;

- (IBAction)checkSymptomsHistoryPressed:(UIButton *)sender;

- (IBAction)manageDoctorsPressed:(UIButton *)sender;

- (IBAction)logoutPressed:(UIButton *)sender;


@end
