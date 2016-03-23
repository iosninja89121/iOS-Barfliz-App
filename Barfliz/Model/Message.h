//
//  Message.h
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

// Data model object that stores a single message
@interface Message : NSObject

@property (nonatomic, copy) NSString* senderName;

@property (nonatomic, copy) NSString* date;

@property (nonatomic, copy) NSString* text;

@property (nonatomic, copy) NSString *yelp_id;

@end
