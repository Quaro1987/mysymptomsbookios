//
//  SymptomViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/1/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Symptom;

@interface SymptomViewController : UIViewController

@property (nonatomic, strong) Symptom *thisSymptom;

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
//labels with symptom properties
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *inclusionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *exclusionsLabel;

@end
