//
//  MessageManager.h
//  Barfliz
//
//  Created by User on 11/24/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;

@interface MessageManager : NSObject

@property (nonatomic, strong) NSMutableArray* messages;

- (NSString*)deviceToken;

- (void)setDeviceToken:(NSString*)token;

- (void) addMessage:(Message*) msg;

- (NSInteger) size;

- (void) initManager;

@end
