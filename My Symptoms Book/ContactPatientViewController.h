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

@interface ContactPatientViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextViewDelegate>

@property (nonatomic, strong) User *patientUser;

//subview properties
@property (weak, nonatomic) IBOutlet UITextView *textFieldSubView;
@property (weak, nonatomic) IBOutlet M13Checkbox *sendAsSMSCheckBox;
@property (nonatomic) BOOL checkBoxChecked;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

//audio recording buttons and AVAudioRecorder and Player properties
@property (nonatomic, strong) AVAudioRecorder *messageRecorder;
@property (nonatomic, strong) AVAudioPlayer *messagePlayer;
@property (nonatomic, strong) NSString *audioMessageFileName;
@property (nonatomic) BOOL sendAudioMessage;

//recording length labels
@property (weak, nonatomic) IBOutlet UILabel *timerLengthOfMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *slashLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

//recording buttons
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingMessageActivityIndicator;

//buttons pressed actions
- (IBAction)sendMessagePressed:(id)sender;
- (IBAction)recordVoiceMessagePressed:(id)sender;
- (IBAction)stopRecordingPressed:(id)sender;
- (IBAction)playPressed:(id)sender;

//background click function to dismiss the keyboard
-(IBAction)dismissKeyboard;

@end
