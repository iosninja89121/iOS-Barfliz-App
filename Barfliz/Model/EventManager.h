//
//  EventManager.h
//  EventKitDemo
//
//  Created by User on 11/14/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;

@property (nonatomic) BOOL eventsAccessGranted;

@property (nonatomic, strong) NSString *selectedCalendarIdentifier;

@property (nonatomic, strong) NSString *selectedEventIdentifier;

@property (nonatomic, strong) EKEvent *currentEvent;


-(NSArray *)getLocalEventCalendars;

-(void)saveCustomCalendarIdentifier:(NSString *)identifier;

-(BOOL)checkIfCalendarIsCustomWithIdentifier:(NSString *)identifier;

-(void)removeCalendarIdentifier:(NSString *)identifier;

-(NSString *)getStringFromDate:(NSDate *)date;
- (NSDate *)getDateFromString:(NSString *)strDate;

-(NSArray *)getEventsOfSelectedCalendar;

-(void)deleteEventWithIdentifier:(NSString *)identifier;
@end
