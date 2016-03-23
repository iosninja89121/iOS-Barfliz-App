//
//  AppDelegate.h
//  Barfliz
//
//  Created by User on 11/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookUserInfoModel.h"
#import "EventManager.h"
#import "MessageManager.h"
#import "ContactsManager.h"
@class MainNavigationController;
@class MainTabBarController;
@class LocationTracker;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)openSession;

+ (AppDelegate*) appDelegate;
+ (NSString*)getNonNilValue:(NSString*)value;
+ (void) message:(NSString*)content;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (strong, nonatomic) id fbDelegate;
@property (strong, nonatomic) NSString* fbAccessToken;
@property (strong, nonatomic) NSString* fbUserPhoto;
@property (strong, nonatomic) FacebookUserInfoModel* fbUserInfo;

@property (nonatomic, strong) MessageManager* messageManager;
@property (nonatomic, strong) EventManager *eventManager;
@property (nonatomic, strong) ContactsManager *contactsManager;
@property (nonatomic, strong) UITabBar *myTabBar;

@property (strong, nonatomic) NSString *twitterToken;
@property (nonatomic, strong) NSString *strRadius;
@property (strong, nonatomic) NSString *strUnit;

@property LocationTracker * locationTracker;
@property MainTabBarController *mainTabCtrl;
@property MainNavigationController *mainNavCtrl;

@property (nonatomic) NSTimer* locationUpdateTimer;

@property (strong, nonatomic) NSString *objectId;

@property (nonatomic) CLLocationCoordinate2D myLocation;

@property (nonatomic, strong) NSMutableArray *onTabViewCtrlArray;
@property (nonatomic, strong) NSMutableArray *offTabViewCtrlArray;

@end

