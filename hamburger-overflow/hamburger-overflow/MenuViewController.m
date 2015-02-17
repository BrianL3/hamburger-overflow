//
//  MenuViewController.m
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/16/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "MenuViewController.h"
#import "WebOAuthViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults stringForKey:@"token"];
    // if the user does not have a token...
    if (!token) {
        // pop the WKView so they can log in
        WebOAuthViewController *webOAuthController = [[WebOAuthViewController alloc] init];
        [self presentViewController:webOAuthController animated:true completion:^{
            // no completion necessary yet
        }];
    }//eo if no token found.  Else do nothing.
}//eo viewDidAppear func

@end
