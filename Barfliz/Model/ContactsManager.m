//
//  ContactsManager.m
//  Barfliz
//
//  Created by User on 11/16/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ContactsManager.h"
#import "AppDelegate.h"
#import "FriendInfo.h"

@implementation ContactsManager

- (void) setMyNo:(NSInteger)myNo
{
    _myNo = myNo;
    [self getInfoForNo:_myNo];
}

- (void) getInfoForNo:(NSInteger) no{
    self.myContactInfo = [[ContactInfo alloc] init];
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/get_data.php?mode=info&no=%ld", (long)no];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return;
    }
    
    NSDictionary *resDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *result = [resDictionary objectForKey:@"result"];
    
    if(![result isEqualToString:@"success"])
    {
        NSString *dataStr = [resDictionary objectForKey:@"data"];
        [AppDelegate message:dataStr];
        return;
    }
    
    NSDictionary *dataDic = [resDictionary objectForKey:@"data"];
    
    NSString *strNo = [dataDic objectForKey:@"no"];
    self.myContactInfo.no = [strNo integerValue];
    
    self.myContactInfo.usr_id = [dataDic objectForKey:@"usr_id"];
    self.myContactInfo.email = [dataDic objectForKey:@"email"];
    self.myContactInfo.phone_number = [dataDic objectForKey:@"phone_number"];
    self.myContactInfo.facebook = [dataDic objectForKey:@"facebook"];
    self.myContactInfo.twitter = [dataDic objectForKey:@"twitter"];
    self.myContactInfo.instagram = [dataDic objectForKey:@"instagram"];

}

- (void) getContactsList{
    self.myContactList = [[NSArray alloc] init];
    self.myFavoriteList = [[NSArray alloc] init];
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/get_data.php?mode=friend&no=%ld", (long)self.myNo];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return;
    }
    
    NSDictionary *resDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *result = [resDictionary objectForKey:@"result"];
    
    if(![result isEqualToString:@"success"])
    {
//        NSString *dataStr = [resDictionary objectForKey:@"data"];
        NSString *errorStr = [NSString stringWithFormat:@"There is no friend list for user \"%@\"", self.myContactInfo.usr_id];
        [AppDelegate message:errorStr];
        return;
    }
    
    NSArray *contactArray = [resDictionary objectForKey:@"data"];
    NSMutableArray *tempConactList = [[NSMutableArray alloc] init];
    NSMutableArray *tempFavoriteList = [[NSMutableArray alloc] init];
    
    for(NSDictionary *item in contactArray)
    {
        FriendInfo *friendInfo = [[FriendInfo alloc] init];
        
        NSString *strNO = [item objectForKey:@"no"];
        friendInfo.no = [strNO integerValue];
        
        friendInfo.img_url = [item objectForKey:@"img_url"];
        friendInfo.usr_id = [item objectForKey:@"usr_id"];
        friendInfo.email = [item objectForKey:@"email"];
        friendInfo.phone_number = [item objectForKey:@"phone_number"];
        
        [tempConactList addObject:friendInfo];
        
        NSString *strFavorite = [item objectForKey:@"favorite"];
        if([strFavorite isEqualToString:@"1"])
        {
            [tempFavoriteList addObject:friendInfo];
        }
    }
    
    self.myContactList = tempConactList;
    self.myFavoriteList = tempFavoriteList;
}

-(NSArray *)getSearchFriends:(NSString *)strSearchItem{
    NSMutableArray *resultArray;
    resultArray = [[NSMutableArray alloc] init];
    
    if([strSearchItem length] == 0) return (NSArray *)resultArray;
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/get_data.php?mode=search&myno=%ld&item=%@", (long)self.myNo, strSearchItem];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return (NSArray*)resultArray;
    }
    
    NSDictionary *resDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *result = [resDictionary objectForKey:@"result"];
    
    if(![result isEqualToString:@"success"])
    {
        NSString *dataStr = [resDictionary objectForKey:@"data"];
        [AppDelegate message:dataStr];
        return (NSArray*)resultArray;
    }
    
    NSArray *contactArray = [resDictionary objectForKey:@"data"];
    
    for(NSDictionary *item in contactArray)
    {
        FriendInfo *friendInfo = [[FriendInfo alloc] init];
        
        NSString *strNO = [item objectForKey:@"no"];
        friendInfo.no = [strNO integerValue];
        
        friendInfo.img_url = [item objectForKey:@"img_url"];
        friendInfo.usr_id = [item objectForKey:@"usr_id"];
        friendInfo.email = [item objectForKey:@"email"];
        friendInfo.phone_number = [item objectForKey:@"phone_number"];
        
        [resultArray addObject:friendInfo];
    }

    
    return (NSArray*)resultArray;
}

- (BOOL) checkRealFriend:(NSInteger) chk_no{
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/get_data.php?mode=friend_check&1st_no=%ld&2nd_no=%ld", (long)self.myNo, (long)chk_no];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return FALSE;
    }
    
    NSDictionary *resDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *result = [resDictionary objectForKey:@"result"];
    
    if(![result isEqualToString:@"success"])
    {
        return FALSE;
    }

    return TRUE;
}

- (void) addFriend:(NSInteger) friend_no{
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/manage_contact.php?mode=add_friend&my_no=%ld&friend_no=%ld", (long)self.myNo, (long)friend_no];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return;
    }
}

- (void) removeFriend:(NSInteger) friend_no{
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/manage_contact.php?mode=remove_friend&my_no=%ld&friend_no=%ld", (long)self.myNo, (long)friend_no];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return;
    }
}

- (void) removeFavorite:(NSInteger) friend_no{
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/manage_contact.php?mode=remove_favorite&my_no=%ld&friend_no=%ld", (long)self.myNo, (long)friend_no];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return;
    }
}

-(void) setFavorite:(NSArray *) friendArray{
    NSString *strURL = [NSMutableString stringWithFormat:@"http://barfliz.com/mobileApi/manage_contact.php?mode=set_favorite&my_no=%ld", (long)self.myNo];
    
    for(FriendInfo *item in friendArray){
        NSString *strItem = [NSString stringWithFormat:@"&f[]=%ld", (long)item.no];
        strURL = [NSString stringWithFormat:@"%@%@", strURL, strItem];
    }
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return;
    }

}

-(NSArray *) mapSearchII:(double)nRadius{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/get_data.php?mode=map_search&my_no=%ld&r=%lf", (long)self.myNo, nRadius];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return (NSArray*)resultArray;
    }
    
    NSDictionary *resDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *result = [resDictionary objectForKey:@"result"];
    
    if(![result isEqualToString:@"success"])
    {
        NSString *dataStr = [resDictionary objectForKey:@"data"];
        [AppDelegate message:dataStr];
        return (NSArray*)resultArray;
    }
    
    NSArray *contactArray = [resDictionary objectForKey:@"data"];
    
    for(NSDictionary *item in contactArray)
    {
        FriendInfo *friendInfo = [[FriendInfo alloc] init];
        
        NSString *strNO = [item objectForKey:@"no"];
        friendInfo.no = [strNO integerValue];
        
        friendInfo.img_url = [item objectForKey:@"img_url"];
        friendInfo.usr_id = [item objectForKey:@"usr_id"];
        friendInfo.email = [item objectForKey:@"email"];
        friendInfo.phone_number = [item objectForKey:@"phone_number"];
        friendInfo.lat = [[item objectForKey:@"lat"] doubleValue];
        friendInfo.log = [[item objectForKey:@"long"] doubleValue];
        [resultArray addObject:friendInfo];
    }
    
    return (NSArray *) resultArray;
}

- (NSArray *) mapSearchI:(double) nRadius{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/get_data.php?mode=map_search&my_no=%ld&r=%lf", (long)self.myNo, nRadius];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can't access server!"];
        return (NSArray*)resultArray;
    }
    
    NSDictionary *resDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *result = [resDictionary objectForKey:@"result"];
    
    if(![result isEqualToString:@"success"])
    {
        NSString *dataStr = [resDictionary objectForKey:@"data"];
        [AppDelegate message:dataStr];
        return (NSArray*)resultArray;
    }
    
    NSArray *contactArray = [resDictionary objectForKey:@"data"];
    
    for(NSDictionary *item in contactArray)
    {
        FriendInfo *friendInfo = [[FriendInfo alloc] init];
        
        NSString *strNO = [item objectForKey:@"no"];
        friendInfo.no = [strNO integerValue];
        
        friendInfo.img_url = [item objectForKey:@"img_url"];
        friendInfo.usr_id = [item objectForKey:@"usr_id"];
        friendInfo.email = [item objectForKey:@"email"];
        friendInfo.phone_number = [item objectForKey:@"phone_number"];
        friendInfo.lat = [[item objectForKey:@"lat"] doubleValue];
        friendInfo.log = [[item objectForKey:@"long"] doubleValue];
        [resultArray addObject:friendInfo];
    }
    
    return (NSArray *) resultArray;
}

@end
