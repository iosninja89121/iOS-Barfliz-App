//
//  PhoneValidationViewController.h
//  Barfliz
//
//  Created by User on 11/6/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneValidationViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString* number;
@end
