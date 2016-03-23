//
//  SettingMainViewController.h
//  Barfliz
//
//  Created by User on 12/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface SettingMainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
- (IBAction)unwindSettingFromChangePassword:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindSettingFromMyProfile:(UIStoryboardSegue *)unwindSegue;
@end
