//
//  EditEventViewController.h
//  EventKitDemo
//
//  Created by Gabriel Theodoropoulos on 11/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"

@protocol EditEventViewControllerDelegate

-(void)eventWasSuccessfullySaved;

@end


@interface EditEventViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DatePickerViewControllerDelegate>

@property (nonatomic, strong) id<EditEventViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblEvent;
@property (nonatomic) NSInteger mode;
@property (nonatomic, strong) NSString *strDate;
@property (nonatomic, strong) NSString *strLocationInfo;

- (IBAction)saveEvent:(id)sender;

@end
