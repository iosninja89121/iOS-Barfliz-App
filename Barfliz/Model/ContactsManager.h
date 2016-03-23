//
//  ContactsManager.h
//  Barfliz
//
//  Created by User on 11/16/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "ContactInfo.h"

@interface ContactsManager : NSObject

@property(nonatomic) NSInteger myNo;
@property(nonatomic, strong) ContactInfo *myContactInfo;
@property(nonatomic, strong) NSArray *myContactList;
@property(nonatomic, strong) NSArray *myFavoriteList;

- (void) getContactsList;
-(NSArray *)getSearchFriends:(NSString *)strSearchItem;
- (BOOL) checkRealFriend:(NSInteger) chk_no;
- (void) addFriend:(NSInteger) friend_no;
- (void) removeFriend:(NSInteger) friend_no;
- (void) removeFavorite:(NSInteger) friend_no;
-(void) setFavorite:(NSArray *) friendArray;
- (NSArray *) mapSearchI:(double) nRadius;
- (NSArray *) mapSearchII:(double) nRadius;
@end
