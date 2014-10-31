//
//  AppDelegate.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 10/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "AppDelegate.h"
#import "DataAndNetFunctions.h"
@interface AppDelegate ()

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //if the app has been launched for the first time, create a plist file with all the symptom category properties
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    //copy path file into string
    NSString *symptomCategoriesPlistPath = [dataController getSymptomCategoriesFilePath];
    
    //check if a file exists at path. if it doesn't, execute the code inside the if statement.
    if(![[NSFileManager defaultManager] fileExistsAtPath:symptomCategoriesPlistPath])
    {
        //populate array with symptom categories
        NSArray *categoryArray = @[@"Blood, immune system", @"Circulatory", @"Digestive", @"Ear, Hearing"
                                   , @"Eye", @"Female genital", @"General", @"Male genital"
                                   , @"Metabolic, endocrine", @"Musculoskeletal", @"Neurological", @"Psychological", @"Respiratory", @"Skin",
                                   @"Social problems", @"Urological", @"Women's health, pregnancy"];
        //write categoryArray to symptomCategoris.plist file
        [categoryArray writeToFile:symptomCategoriesPlistPath atomically:YES];
    }
    
    //check if database exists, otherwise populate it with symptoms
    if(![[NSFileManager defaultManager] fileExistsAtPath:[dataController getMySymptomsBookDatabasePath]])
    {
        [dataController populateSymptomsDatabaseOnFirstLoad];
    }
    
    //set navigaton bar color properties
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x6399cd)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];;
    [[UINavigationBar appearance]
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

       return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
