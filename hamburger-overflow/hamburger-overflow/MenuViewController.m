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
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // load up the user's stack overflow token
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
