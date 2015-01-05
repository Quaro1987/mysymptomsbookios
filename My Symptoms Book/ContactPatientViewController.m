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

static int numberOfSecondsRecorded;
static int secondsDuration;
static int anotherSecondsRecorded;
static NSTimer *theTimer;

@implementation ContactPatientViewController

@synthesize patientUser, textFieldSubView, sendAsSMSCheckBox, recordButton, stopButton, messageRecorder, playButton, messagePlayer,
audioMessageFileName, sendAudioMessage, sendingMessageActivityIndicator, tapGestureRecognizer, totalTimeLabel, slashLabel, timerLengthOfMessageLabel,
checkBoxChecked;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    sendAudioMessage = NO;
    checkBoxChecked = NO;
    //set up audio recorder
    DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
    //get thef ile name
    audioMessageFileName = [dataController getContactMessageFileNameForUser:patientUser.username];
    messageRecorder = [dataController getAudioRecorderForMessageFile:audioMessageFileName];
    messageRecorder.delegate = self;
    [messageRecorder prepareToRecord];
    
    //set check box label
    sendAsSMSCheckBox.titleLabel.text = @"Also send as SMS:";
    sendAsSMSCheckBox.userInteractionEnabled = YES;
    
    //set sms checkbox as not checked
    [sendAsSMSCheckBox setCheckState:M13CheckboxStateUnchecked];
    
    //disable stop and play button
    stopButton.enabled = NO;
    playButton.enabled = NO;
    
    //set gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(dismissKeyboard)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(changeCheckBox)];
    [self.view addGestureRecognizer:tap];
    [sendAsSMSCheckBox addGestureRecognizer:tap2];
}

//dismiss keyboard from textfield
-(void)dismissKeyboard {
    [textFieldSubView resignFirstResponder];
}

-(void)changeCheckBox
{
    if(checkBoxChecked)
    {
        checkBoxChecked = NO;
        [sendAsSMSCheckBox setCheckState:M13CheckboxStateUnchecked];
    }
    else
    {
        checkBoxChecked = YES;
        [sendAsSMSCheckBox setCheckState:M13CheckboxStateChecked];
    }
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
    //check if device still has internet access
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    //if there is internet access, post message
    if([dataAndNetController internetAccess])
    {
        [sendingMessageActivityIndicator startAnimating];
        //stop the indicator from animating once the segue has been performed with a 2 second delay
        [self performSelector:@selector(stopLoadingAnimationOfActivityIndicator:) withObject:self.sendingMessageActivityIndicator afterDelay:2.0];
    }
    else //else show error message and take back to main menu
    {
        [dataAndNetController takeToMainMenuForNavicationController:self.navigationController];
    }
}


//stop loading animation and send message
- (void)stopLoadingAnimationOfActivityIndicator: (UIActivityIndicatorView *)spinner {
    //stop loading animation
    [spinner stopAnimating];
    
    //send contact information
    ContactForm *contact = [[ContactForm alloc] init];
    NSString *reply = [contact sendMessage:textFieldSubView.text toUserWithID:patientUser.userID andAlsoeSendAsSMS:checkBoxChecked andAlsoSendRecordedMessage:sendAudioMessage withFileName:audioMessageFileName];
    
    if([reply isEqualToString:@"SUCCESS"])
    {
        //get success alert view
        DataAndNetFunctions *dataController = [[DataAndNetFunctions alloc] init];
        UIAlertView *successAlert = [dataController alertStatus:@"Message Successfully sent to User" andAlertTitle:@"Message Sent"];
        //show alert view
        [successAlert show];
        //redirect to doctor main menu
        DoctorUserMainViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorUserMainView"];
        [self.navigationController pushViewController:destinationController animated:NO];
    }
}

//record a message when it is pressed
- (IBAction)recordVoiceMessagePressed:(id)sender {
    //change button availabillity
    recordButton.enabled = NO;
    stopButton.enabled = YES;
    //show labels
    timerLengthOfMessageLabel.text = @"0";
    timerLengthOfMessageLabel.hidden = NO;   
    slashLabel.hidden = NO;
    totalTimeLabel.text = @"20";
    totalTimeLabel.hidden = NO;
    //[messageRecorder recordForDuration:10];
    //start recording
    sendAudioMessage = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    [session setActive:YES error:nil];
    
    [messageRecorder record];
    [self startTimerForSeconds:20];
}

//stop recording or playback when pressed
- (IBAction)stopRecordingPressed:(id)sender {
    //stop the timer
    [self StopTimer];
    //change button availabillity
    playButton.enabled = YES;
    stopButton.enabled = NO;
    recordButton.enabled = YES;
    //check if the app is recording
    if([messageRecorder isRecording])
    {
        anotherSecondsRecorded = numberOfSecondsRecorded;
        //stop recording
        [messageRecorder stop];
        //hide the slash label
        slashLabel.hidden = YES;
        //copy the recorded time into the total time label
        totalTimeLabel.text = timerLengthOfMessageLabel.text;
        //show the length of message label
        timerLengthOfMessageLabel.text = @"Length of Message:";
        //stop recording session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        int flags = AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation;
        [session setActive:NO withOptions:flags error:nil];
    }
    else if([messagePlayer isPlaying])
    {
        //stop playback
        [messagePlayer stop];
        //hide the slash label
        slashLabel.hidden = YES;
        //show the length of message label
        timerLengthOfMessageLabel.text = @"Length of Message:";
    }
}

//play recorded message
- (IBAction)playPressed:(id)sender {
    //change button availabillity
    playButton.enabled = NO;
    stopButton.enabled = YES;
    recordButton.enabled = NO;
    timerLengthOfMessageLabel.text = @"0";
    timerLengthOfMessageLabel.hidden = NO;
    slashLabel.hidden = NO;
    NSString *secondsRecordedString = [NSString stringWithFormat:@"%d",anotherSecondsRecorded];
    totalTimeLabel.text = secondsRecordedString;
    [self startTimerForSeconds:anotherSecondsRecorded];
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
    //hide the slash label
    slashLabel.hidden = YES;
    //copy the recorded time into the total time label
    //totalTimeLabel.text = timerLengthOfMessageLabel.text;
    //show the length of message label
    timerLengthOfMessageLabel.text = @"Length of Message:";
}

#pragma mark timer functions private
//start the timer function
-(void) startTimerForSeconds: (int) numberOfSeconds
{
    secondsDuration = numberOfSeconds;
    //set recorded seconds to 0
    numberOfSecondsRecorded = 0;
    //start a repeating timer to show the second progress till there are 20 secodns recorded
    theTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerTickWithTimer:) userInfo:nil repeats:(numberOfSecondsRecorded!=numberOfSeconds)];
    [[NSRunLoop currentRunLoop] addTimer:theTimer forMode:NSDefaultRunLoopMode];
}
//increment the second timer by 1
-(void) timerTickWithTimer: (NSTimer *) aTimer
{
    //increment number of seconds recorded
    numberOfSecondsRecorded++;
    NSString *secondsPassedString = [NSString stringWithFormat:@"%d",numberOfSecondsRecorded];
    timerLengthOfMessageLabel.text = secondsPassedString;
    if(numberOfSecondsRecorded==secondsDuration)
    {
        [stopButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

//stop the timer
- (void) StopTimer
{
    [theTimer invalidate];
}

@end
