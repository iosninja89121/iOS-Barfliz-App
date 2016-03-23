//
//  AppDelegate.m
//  Barfliz
//
//  Created by User on 11/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "Message.h"
#import "AppDelegate.h"
#import "LocationTracker.h"
#import "RegisterViewController.h"
#import "FacebookUserInfoModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MainTabBarController.h"
#import "WelcomViewController.h"
#import "PushMessageViewController.h"
#import "MainNavigationController.h"
#import "MainPushMessageViewController.h"
#import <Parse/Parse.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)initOperation:(NSDictionary*)launchOptions
{
    
    // Register for Push Notitications
    
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"1");
    // init for Parse.com
    [Parse setApplicationId:@"KaqQZcOU6CMmq63RTWCZ6zSKB739drDIUbiXytiP" clientKey:@"aya3RStHXObRW6em2WPssa3XUtKRqTCbBArBUnoq"];
    
//    UIApplication* application = [UIApplication sharedApplication];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge |     UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }else{
        [application registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"Launched from push notification: %@", dictionary);
            [self addMessageFromRemoteNotification:dictionary];

        }
    }
    
    UIAlertView * alert;
    
    //We have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh"
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        
        alert = [[UIAlertView alloc]initWithTitle:@""
                                          message:@"The functions of this app are limited because the Background App Refresh is disable."
                                         delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil, nil];
        [alert show];
        
    } else{
        
        self.locationTracker = [[LocationTracker alloc]init];
        [self.locationTracker startLocationTracking];
        
        PFUser *currentUser = [PFUser currentUser];
        
        if(currentUser){
            PFGeoPoint *pfGeoPoint = [currentUser valueForKey:keyLocation];
            CLLocationCoordinate2D location;
            location.latitude = pfGeoPoint.latitude;
            location.longitude = pfGeoPoint.longitude;
            
            self.locationTracker.myLocation = location;
        }
        
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        NSTimeInterval time = 60.0;
        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
    }
    
    
    
    // Override point for customization after application launch.
    
    [FBAppEvents activateApp];
    self.eventManager = [[EventManager alloc] init];
    
    self.twitterToken = @"";
    self.mainTabCtrl = nil;
    
    NSString *strRadius = [[NSUserDefaults standardUserDefaults] objectForKey:@"radiusValue"];
    
    if(strRadius == nil){
        self.strRadius = @"25";
        self.strUnit = @"km";
        
        [[NSUserDefaults standardUserDefaults] setObject:@"25" forKey:@"radiusValue"];
        [[NSUserDefaults standardUserDefaults] setObject:@"km" forKey:@"unitValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        self.strRadius = strRadius;
        self.strUnit = [[NSUserDefaults standardUserDefaults] objectForKey:@"unitValue"];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"2");
    
//    [self performSelectorInBackground:@selector(initOperation:) withObject:launchOptions];
    
    NSLog(@"3");
    
    NSString *strUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *strPSW =      [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if(strUsername.length > 0 && strPSW.length > 0 && launchOptions == nil){
        [PFUser logInWithUsernameInBackground:strUsername password:strPSW block:^(PFUser *user, NSError *error) {
            
        }];
        
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
        
        WelcomViewController *welcomeController = (WelcomViewController *)[storyboard instantiateViewControllerWithIdentifier:welcome_scene];
        
        MainTabBarController * tabController = (MainTabBarController *)[storyboard instantiateViewControllerWithIdentifier:mainTab_scene];
        tabController.selectedIndex = 1;
        
        [self.navigationController setViewControllers:@[welcomeController, tabController] animated:NO];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = self.navigationController;
        [self.window makeKeyAndVisible];
        
        
    }
    
    return YES;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    UIApplicationState state = [application applicationState];
    
//    if (state == UIApplicationStateActive) {
        NSLog(@"Received notification: %@", userInfo);
        
        //Remove the badge icon from app icon.
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if(state == UIApplicationStateActive){
        SystemSoundID soundID;
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"Voicemail.wav", NULL, NULL);
        AudioServicesCreateSystemSoundID(ref, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
        
        //    UINavigationController *navCtroller = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:mainNav_scene];
        
        
        
        NSString* mode = [userInfo valueForKey:@"reply_mode"];
        
        if([mode isEqualToString:@"yes"]){
            MainPushMessageViewController * controller = (MainPushMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:mainPushScene];
            
            controller.strMessageContnet = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
            controller.strReceiverID = [userInfo valueForKey:@"from"];
            controller.strLocationID = [userInfo valueForKey:@"location"];
            controller.strLocationTitle = [userInfo valueForKey:@"location_name"];
            controller.strCalendarInfo = [userInfo valueForKey:@"time_name"];
            
            [self.navigationController pushViewController:controller animated:NO];
        }else{
            
            PushMessageViewController * controller = (PushMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:pushScene];
            
            NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
            
            controller.msgContent = alertValue;
            
            [self.navigationController pushViewController:controller animated:NO];
        }
        
        [self.mainTabCtrl setSelectedIndex:1];
        
//    }else{
//        
//    }
    
    
    
    
    
//    [self.mainNavCtrl pushViewController:controller animated:YES];

    
//    [self addMessageFromRemoteNotification:userInfo updateUI:YES];
    
//     [PFPush handlePush:userInfo];
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
    
    WelcomViewController *welcomeController = (WelcomViewController *)[storyboard instantiateViewControllerWithIdentifier:welcome_scene];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    
    [self.navigationController setViewControllers:@[welcomeController]];
    
    NSString *strUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *strPSW =      [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if(strUsername.length > 0 && strPSW.length > 0){
        [PFUser logInWithUsernameInBackground:strUsername password:strPSW block:^(PFUser *user, NSError *error) {
            
        }];
        
        MainTabBarController * tabController = (MainTabBarController *)[storyboard instantiateViewControllerWithIdentifier:mainTab_scene];
        tabController.selectedIndex = 1;
        
        [self.navigationController pushViewController:tabController animated:NO];
    }
    
    NSString* mode = [userInfo valueForKey:@"reply_mode"];
    
    if([mode isEqualToString:@"yes"]){
        MainPushMessageViewController * controller = (MainPushMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:mainPushScene];
        
        controller.strMessageContnet = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        controller.strReceiverID = [userInfo valueForKey:@"from"];
        controller.strLocationID = [userInfo valueForKey:@"location"];
        controller.strLocationTitle = [userInfo valueForKey:@"location_name"];
        controller.strCalendarInfo = [userInfo valueForKey:@"time_name"];
        
        [self.navigationController pushViewController:controller animated:NO];
    }else{
        
        PushMessageViewController * controller = (PushMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:pushScene];
        
        NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        
        controller.msgContent = alertValue;
        
        [self.navigationController pushViewController:controller animated:NO];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
}

- (void)postUpdateRequest
{
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/manage_contact.php?mode=update_token&no=%ld&token=%@", (long)self.contactsManager.myNo, [self.messageManager deviceToken]];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSError * error = nil;
    [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if(currentUser){
        [currentInstallation setObject:currentUser forKey:@"user"];
    }
    
    [currentInstallation saveInBackground];
    
    NSString* oldToken = [self.messageManager deviceToken];
    
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is: %@", newToken);
    
    [self.messageManager setDeviceToken:newToken];
    
    if (![newToken isEqualToString:oldToken])
    {
        [self postUpdateRequest];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


-(void)updateLocation {
    NSLog(@"updateLocation");
    
    [self.locationTracker updateLocationToServer];
}


+ (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // attempt to extract a token from the url
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)openSession
{
    //    NSArray* permissions = @[@"public_profile", @"email"];
    NSArray* permissions = @[@"public_profile"];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession* session, FBSessionState state, NSError* error) {
                                      [self sessionStateChanged:session state:state error:error];
                                  }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            [self fetchUserInfo];
        }
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
        {
            // Once the user has logged in, we want them to
            // be looking at the root view.
            
            [FBSession.activeSession closeAndClearTokenInformation];
        }
            break;
            
        default:
            break;
    }
    
    if (error)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)fetchUserInfo
{
    //    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Loading", @"Loading...")];
    
    FBRequest* meRequest = [FBRequest requestForMe];
    [meRequest startWithCompletionHandler:^(FBRequestConnection* connection, id<FBGraphUser> user, NSError* error) {
        
        if (!error)
        {
//            [self showCaptureSplash];
            NSLog(@"%@", user);
            
            _fbUserInfo = [[FacebookUserInfoModel alloc] init];
            
            NSString* accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
            NSLog(@"access token --> %@", accessToken);
            
            _fbUserInfo.service = ServiceName_Facebook;
            _fbUserInfo.remoteId = [AppDelegate getNonNilValue:user[key_id]];
            _fbUserInfo.accessToken = accessToken;
            _fbUserInfo.serviceName = [AppDelegate getNonNilValue:user[key_name]];
            _fbUserInfo.fullName = [AppDelegate getNonNilValue:user[key_name]];
            _fbUserInfo.nickname = [AppDelegate getNonNilValue:user[key_nick]];
            _fbUserInfo.firstName = [AppDelegate getNonNilValue:user[key_first_name]];
            _fbUserInfo.middleName = [AppDelegate getNonNilValue:user[key_middle_name]];
            _fbUserInfo.lastName = [AppDelegate getNonNilValue:user[key_last_name]];
            _fbUserInfo.gender = [AppDelegate getNonNilValue:user[key_gender]];
            _fbUserInfo.hometown = [AppDelegate getNonNilValue:user[key_hometown]];
            _fbUserInfo.locale = [AppDelegate getNonNilValue:user[key_locale]];
            
            NSURL* userInfoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", accessToken]];
            NSString* userInfo = [NSString stringWithContentsOfURL:userInfoUrl encoding:NSUTF8StringEncoding error:&error];
            userInfo = [userInfo substringToIndex:([userInfo length] - 1)];
            NSLog(@"userInfo -- %@", userInfo);
            
            NSURL* photoDataURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/picture?width=200&redirect=0&type=normal&height=200&access_token=%@", accessToken]];
            NSString* photoData = [NSString stringWithContentsOfURL:photoDataURL
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
            
            NSDictionary* photoDataDict = [NSJSONSerialization JSONObjectWithData:[photoData dataUsingEncoding:NSUTF8StringEncoding]
                                                                          options:kNilOptions
                                                                            error:&error];
            
            NSString* photoPath = [[photoDataDict objectForKey:key_data] objectForKey:key_url];
            _fbUserInfo.photo = photoPath;
            _fbUserInfo.userDetails = [NSString stringWithFormat:@"%@,\"photo\":\"%@\"}", userInfo, photoPath];
            
            
            
            //            [SVProgressHUD showSuccessWithStatus:@"Loading..."];
            /*
             {"id":"100006552646702","first_name":"Lu","last_name":"Xin","name":"Lu Xin","gender":"male","picture":"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-frc3/c40.0.188.188/996603_1407774409450967_1626130355_n.jpg"}
             */
            
            //            [self.mHandler sendSignupRequest:serviceName remote_id:remote_id access_token:access_token service_name:middle_name service_first_name:first_name service_middle_name:middle_name service_last_name:last_name service_user_detail:photo _gender:gender _homeTown:homeTown];
            
            
            self.fbAccessToken = accessToken;
            self.fbUserPhoto = photoPath;
            
            NSString *userID = user[key_id];
            
            if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(fbDidLoginSuccess: token:)])
                [self.fbDelegate performSelector:@selector(fbDidLoginSuccess: token:) withObject:userID withObject:accessToken];
        }
        else {
            NSLog(@"Facebook fetchUserInfo Error : %@", [error localizedDescription]);
            
            if (self.fbDelegate && [self.fbDelegate respondsToSelector:@selector(fbDidLoginFailedWithError:)])
                [self.fbDelegate performSelector:@selector(fbDidLoginFailedWithError:) withObject:error];
        }
    }];
}

+ (void) message:(NSString*)content{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:content
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
}

+ (NSString*)getNonNilValue:(NSString*)value
{
    if (!value)
        return @"";
    
    return value;
}

-(void)requestAccessToEvents{
    [self.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.eventManager.eventsAccessGranted = granted;
            NSArray * arrCalendar = [self.eventManager getLocalEventCalendars];
            self.eventManager.selectedCalendarIdentifier = [[arrCalendar objectAtIndex:0] calendarIdentifier];
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


@end
