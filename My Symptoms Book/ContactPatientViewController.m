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
#import "ContactForm.h"
#import "DoctorUserMainViewController.h"
@interface ContactPatientViewController ()

@end

@implementation ContactPatientViewController

@synthesize patientUser, textFieldSubView, sendAsSMSCheckBox, recordButton, stopButton, messageRecorder, playButton, messagePlayer,
audioMessageFileName, sendAudioMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sendAudioMessage = NO;
    //set up audio recorder
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    //get thef ile name
    audioMessageFileName = [dataController getContactMessageFileNameForUser:patientUser.username];
    messageRecorder = [dataController getAudioRecorderForMessageFile:audioMessageFileName];
    messageRecorder.delegate = self;
    [messageRecorder prepareToRecord];
    
    //set check box label
    sendAsSMSCheckBox.titleLabel.text = @"Also send as SMS:";
    
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
    ContactForm *contact = [[ContactForm alloc] init];
    [contact sendMessage:textFieldSubView.text toUserWithID:patientUser.userID andAlsoeSendAsSMS:sendAsSMSCheckBox.selected andAlsoSendRecordedMessage:sendAudioMessage withFileName:audioMessageFileName];
    
    //get success alert view
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    UIAlertView *successAlert = [dataController alertStatus:@"Message Successfully sent to User" andAlertTitle:@"Message Sent"];
    //show alert view
    [successAlert show];
    
    //redirect to doctor main menu
    DoctorUserMainViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorUserMainView"];
    [self.navigationController pushViewController:destinationController animated:NO];
}

//record a message when it is pressed
- (IBAction)recordVoiceMessagePressed:(id)sender {
    //change button availabillity
    recordButton.enabled = NO;
    stopButton.enabled = YES;
    //start recording
    [messageRecorder record];
    sendAudioMessage = YES;
}

//stop recording or playback when pressed
- (IBAction)stopRecordingPressed:(id)sender {
    //change button availabillity
    playButton.enabled = YES;
    stopButton.enabled = NO;
    recordButton.enabled = YES;
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
    recordButton.enabled = NO;
    
    //init audio player
    NSError *error;
    messagePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:messageRecorder.url error:&error];
    messagePlayer.delegate = self;
    
    //play message
    [messagePlayer play];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //change button availabillity
    playButton.enabled = YES;
    stopButton.enabled = NO;
    recordButton.enabled = YES;
}

@end
