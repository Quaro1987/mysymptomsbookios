//
//  ContactPatientViewController.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/25/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "ContactPatientViewController.h"
#import "User.h"
#import "M13Checkbox.h"
#import "DataAndNetFunctions.h"

@interface ContactPatientViewController ()

@end

@implementation ContactPatientViewController

@synthesize patientUser, textFieldSubView, sendAsSMSCheckBox, recordButton, stopButton, messageRecorder, playButton, messagePlayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set up audio recorder
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    messageRecorder = [dataController getAudioRecorderForMessage];
    messageRecorder.delegate = self;
    [messageRecorder prepareToRecord];
    
    //set check box label
    sendAsSMSCheckBox.titleLabel.text = @"Also send as SMS:";
    BOOL selectedValue = sendAsSMSCheckBox.selected;
    
    NSLog(@"Bool value is %i", selectedValue);
    
    //disable stop and play button
    stopButton.enabled = NO;
    playButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//function to send the message to the server
- (IBAction)sendMessagePressed:(id)sender {
}

//record a message when it is pressed
- (IBAction)recordVoiceMessagePressed:(id)sender {
    //change button availabillity
    playButton.enabled = NO;
    stopButton.enabled = YES;
    //start recording
    [messageRecorder record];
}

//stop recording or playback when pressed
- (IBAction)stopRecordingPressed:(id)sender {
    //change button availabillity
    playButton.enabled = YES;
    stopButton.enabled = NO;
    //check if the app is recording
    if([messageRecorder isRecording])
    {
        //stop recording
        [messageRecorder stop];
    }
    else if([messagePlayer isPlaying])
    {
        //stop playback
        [messagePlayer stop];
    }
    
}

//play recorded message
- (IBAction)playPressed:(id)sender {
    //change button availabillity
    playButton.enabled = NO;
    stopButton.enabled = YES;
    //recordButton.enabled = NO;
    
    //init audio player
    NSError *error;
    messagePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:messageRecorder.url error:&error];
    messagePlayer.delegate = self;
    
    //play message
    [messagePlayer play];
}


@end
