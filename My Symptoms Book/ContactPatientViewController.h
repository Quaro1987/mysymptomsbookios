//
//  ContactPatientViewController.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/25/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class User, M13Checkbox;

@interface ContactPatientViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) User *patientUser;

//subview properties
@property (weak, nonatomic) IBOutlet UITextView *textFieldSubView;
@property (weak, nonatomic) IBOutlet M13Checkbox *sendAsSMSCheckBox;

//audio recording buttons and AVAudioRecorder and Player properties
@property (nonatomic, strong) AVAudioRecorder *messageRecorder;
@property (nonatomic, strong) AVAudioPlayer *messagePlayer;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

//buttons pressed actions
- (IBAction)sendMessagePressed:(id)sender;
- (IBAction)recordVoiceMessagePressed:(id)sender;
- (IBAction)stopRecordingPressed:(id)sender;
- (IBAction)playPressed:(id)sender;


@end