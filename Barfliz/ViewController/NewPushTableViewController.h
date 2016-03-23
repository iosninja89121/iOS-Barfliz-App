//
//  NewPushTableViewController.h
//  Barfliz
//
//  Created by User on 11/11/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPushTableViewController : UITableViewController<UITextViewDelegate>

- (IBAction)unwindToNewPushFromContactsList:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindToNewPushFromCalendar:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindToNewPushFromLocation:(UIStoryboardSegue *)unwindSegue;


@property BOOL location_expended;
@property BOOL calendar_expended;
@property NSString *strMsg;
@property NSString *strCalendar;
@property NSString *strLocation;
@property NSString *strContent;

@property UITextView *msgTextView;
//@property UILabel *countLabel;

@property (nonatomic, strong) NSMutableArray *receiverList;
@end
