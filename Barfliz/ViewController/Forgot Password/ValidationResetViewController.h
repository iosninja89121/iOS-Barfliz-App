//
//  ValidationResetViewController.h
//  Barfliz
//
//  Created by User on 12/21/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidationResetViewController : UIViewController
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) PFUser *pfUser;
@end
