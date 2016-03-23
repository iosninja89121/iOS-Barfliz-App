//
//  FriendInfo.h
//  Barfliz
//
//  Created by User on 11/17/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfo : NSObject
@property (nonatomic) NSInteger no;
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *usr_id;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone_number;
@property (nonatomic) double lat;
@property (nonatomic) double log;
@end
