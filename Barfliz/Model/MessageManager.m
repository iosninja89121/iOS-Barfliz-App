//
//  MessageManager.m
//  Barfliz
//
//  Created by User on 11/24/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "MessageManager.h"

static NSString* const DeviceTokenKey = @"DeviceToken";

@implementation MessageManager

- (void) addMessage:(Message*) msg{
    [self.messages addObject:msg];
}

- (NSInteger) size{
    return self.messages.count;
}

- (void) initManager{
    self.messages = [NSMutableArray arrayWithCapacity:20];
}

- (NSString*)deviceToken
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
}

- (void)setDeviceToken:(NSString*)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DeviceTokenKey];
}



@end
