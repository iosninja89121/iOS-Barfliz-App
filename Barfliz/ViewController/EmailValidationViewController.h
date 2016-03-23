//
//  EmailValidationViewController.h
//  Barfliz
//
//  Created by User on 11/4/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailValidationViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *code;
@end
