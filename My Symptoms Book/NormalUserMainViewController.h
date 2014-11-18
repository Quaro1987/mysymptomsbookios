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

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *userSymptomhistoryActivityIndicator;

//button outlets

- (IBAction)manageDoctorsPressed:(UIButton *)sender;

- (IBAction)symptomHistoryPressed:(UIButton *)sender;

- (IBAction)logoutPressed:(UIButton *)sender;

//functions

- (void)stopLoadingAnimationOfActivityIndicatorAndPerformSegue: (UIActivityIndicatorView *)spinner;
@end
