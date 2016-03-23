//
//  FacebookUserInfoModel.h
//  Barfliz
//
//  Created by User on 11/6/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookUserInfoModel : NSObject
@property (strong, nonatomic) NSString* service;
@property (strong, nonatomic) NSString* remoteId;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* serviceName;
@property (strong, nonatomic) NSString* fullName;
@property (strong, nonatomic) NSString* nickname;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* middleName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* gender;
@property (strong, nonatomic) NSString* hometown;
@property (strong, nonatomic) NSString* locale;
@property (strong, nonatomic) NSString* photo;
@property (strong, nonatomic) NSString* userDetails;
@end
