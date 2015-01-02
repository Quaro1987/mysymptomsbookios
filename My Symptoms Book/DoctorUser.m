//
//  DoctorUser.m
//  My Symptoms Book
//
//  Created by Giannis Pas on 11/16/14.
//  Copyright (c) 2014 Ioannis Pasmatzis. All rights reserved.
//

#import "DoctorUser.h"
#import "DataAndNetFunctions.h"
#import "User.h"
@implementation DoctorUser

@synthesize username, userType, userID, email, status, doctorSpecialty, aboutDoctor ,firstName, lastName;

//init doctor function
-(id)initWithId:(NSNumber *)usrID andUserName:(NSString *)usrName andUserType:(NSNumber *)usrType andEmail:(NSString *)usrEmail andStatus:(NSNumber *)usrStatus andFirstName:(NSString *)frName andLastName:(NSString *)lsName andDoctorSpecialty:(NSString *)drSpecialty andAboutDoctor:(NSString *)aboutDr
{
    self = [super init];
    
    //if succesful init copy attributes and return self
    if(self)
    {
        userID = usrID;
        username = usrName;
        userType = usrType;
        status = usrStatus;
        email = usrEmail;
        firstName = frName;
        lastName = lsName;
        doctorSpecialty = drSpecialty;
        aboutDoctor = aboutDr;
    }
    
    return self;
}

//cast user into doctor user
-(id)typeCastUser:(User *)aUser
{
    //create doctor user for inputed user
    DoctorUser *thisUser = [[DoctorUser alloc] initWithId:aUser.userID andUserName:aUser.username andUserType:aUser.userType andEmail:aUser.email andStatus:aUser.status andFirstName:aUser.firstName andLastName:aUser.lastName andDoctorSpecialty:@"Patient" andAboutDoctor:@"Patient User"];

    return thisUser;
}

//function to get the doctor users
-(NSMutableArray *)getDoctorsForSymptomWithSymptomCode:(NSString *)symptomCode
{
    //init dataAndNetController
    DataAndNetFunctions *dataAndNetController = [[DataAndNetFunctions alloc] init];
    
    //get current user
    User *currentUser = [[User alloc] initWithSavedUser];
    
    NSString *serverString = [dataAndNetController serverUrlString];
    //creatue url
    NSString *stringUrl = [serverString stringByAppendingString:@"findDoctorIOS"];

    NSLog(stringUrl);
    NSURL *url = [[NSURL alloc] initWithString:stringUrl];
    
    NSString *postMessage = [[NSString alloc] init];
    //create post data
    if([symptomCode isEqualToString:@"GET DOCTORS"])
    {
        postMessage = [NSString stringWithFormat:@"username=%@&password=%@&symptomCode=%@", [currentUser getEncodedUsername], [dataAndNetController getUserPassword], symptomCode];
    }
    else
    {
        postMessage = [NSString stringWithFormat:@"username=%@&password=%@&symptomCode=%@", [currentUser getEncodedUsername], [dataAndNetController getUserPassword], symptomCode];
    }
    
    //create request
    NSMutableURLRequest *request = [dataAndNetController getURLRequestForURL:url andPostMessage:postMessage];
    
    //error attribute
    NSError *error = [[NSError alloc] init];
    
    //create response
    NSURLResponse *response;
    
    //json data
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //create array that will keep the doctor users objects
    NSMutableArray *doctorsArray = [[NSMutableArray alloc] init];
    
    if([responseData length] == 0)
    {
        //log the error and show error message
        NSLog(@"ERROR no contact with server");
        [dataAndNetController failedToContactServerShowAlertView];
    }
    else
    {
        //pass doctor user objects into an array
        NSDictionary *jsonReponseData = (NSDictionary *) [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //set so the formatter doesn't reutrn decimals
        [numberFormatter setGeneratesDecimalNumbers:FALSE];
        
        for (NSDictionary *doctorUserObject in jsonReponseData)
        {
            NSString *tempDoctorFirstName = [doctorUserObject valueForKeyPath:@"jsonDataSource.relations.profile.firstname"];
            NSString *tempDoctorLastName = [doctorUserObject valueForKeyPath:@"jsonDataSource.relations.profile.lastname"];
            NSString *tempDoctorUsername = [doctorUserObject valueForKeyPath:@"jsonDataSource.attributes.username"];
            NSString *tempDoctorEmail = [doctorUserObject valueForKeyPath:@"jsonDataSource.attributes.email"];
            NSString *tempDoctorSpecialty = [doctorUserObject valueForKeyPath:@"jsonDataSource.attributes.doctorSpecialty"];
            NSString *tempDoctorAboutDoctor = [doctorUserObject valueForKeyPath:@"jsonDataSource.attributes.aboutDoctor"];
            NSNumber *tempDoctorUserID = [numberFormatter numberFromString:[doctorUserObject valueForKeyPath:@"jsonDataSource.attributes.id"]];
            NSNumber *tempDoctorUserStatus = [numberFormatter numberFromString:[doctorUserObject valueForKeyPath:@"jsonDataSource.attributes.status"]];
            NSNumber *tempDoctorUserType = [numberFormatter numberFromString:[doctorUserObject valueForKeyPath:@"jsonDataSource.attributes.userType"]];
            //create temp doctor user
            DoctorUser *aDoctor = [[DoctorUser alloc] initWithId:tempDoctorUserID andUserName:tempDoctorUsername andUserType:tempDoctorUserType andEmail:tempDoctorEmail andStatus:tempDoctorUserStatus andFirstName:tempDoctorFirstName andLastName:tempDoctorLastName andDoctorSpecialty:tempDoctorSpecialty andAboutDoctor:tempDoctorAboutDoctor];
            //add doctor to aray
            [doctorsArray addObject:aDoctor];
        }
    }
    return doctorsArray;
}

@end
