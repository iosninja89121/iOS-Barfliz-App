//
//  SelectGroupViewController.m
//  Barfliz
//
//  Created by User on 11/12/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "SelectGroupViewController.h"
#import "ContactListTableViewController.h"

@interface SelectGroupViewController ()
@property NSString *selGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnContacts;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorites;
@end

@implementation SelectGroupViewController

- (IBAction)PushFavoritesButton:(id)sender {
    self.selGroup = @"Favorites";
    [self performSegueWithIdentifier:@"ToSelectContacts" sender:self];
}

- (IBAction)PushContactsButton:(id)sender {
    self.selGroup = @"Contacts";
    [self performSegueWithIdentifier:@"ToSelectContacts" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navBar = [[self navigationController] navigationBar];
//    UIImage *backgroundImage = [UIImage imageNamed:@"logo.png"];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self setBorderRadiusForButton];
}

-(void) setBorderRadiusForButton {
    self.btnContacts.layer.cornerRadius = 10;
    self.btnContacts.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.btnFavorites.layer.cornerRadius = 10;
    self.btnFavorites.layer.borderColor = [[UIColor blackColor] CGColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ToSelectContacts"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        ContactListTableViewController *destTableViewController = segue.destinationViewController;
        destTableViewController.selectedItem = self.selGroup;
    }
    
}


@end
