//
//  WebOAuthViewController.m
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/16/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "WebOAuthViewController.h"
#import <WebKit/WebKit.h>

@interface WebOAuthViewController () <WKNavigationDelegate>
@property (strong, nonatomic) NSString* appID;
@end

@implementation WebOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set our app ID
    self.appID = @"4283";
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
    NSString *urlString = [NSString stringWithFormat:@"https://stackexchange.com/oauth/dialog?client_id=%@&scope=no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success", self.appID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    // create the requestion
    NSURLRequest *request = navigationAction.request;
    NSURL *url = request.URL;
    //NSLog(@"%@",url.description);
    
    // parse the returned URLs until we get one with "access_token".
    if ([url.description containsString:@"access_token"]) {
        // parse the correct URL for the token
        NSArray *components = [[url description] componentsSeparatedByString:@"="];
        NSString *token = components.lastObject;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:token forKey:@"token"];
        [userDefaults synchronize];
        
        [self dismissViewControllerAnimated:true completion:nil];
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);

}

@end
