//
//  ContactForm.h
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/27/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactForm : NSObject

-(NSString *)sendMessage:(NSString *) message toUserWithID:(NSNumber *) patientID andAlsoeSendAsSMS:(BOOL) smsBoolean andAlsoSendRecordedMessage:(BOOL) recordedMessageBoolean;

@end
