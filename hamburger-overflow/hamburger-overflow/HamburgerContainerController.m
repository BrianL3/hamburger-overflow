//
//  HamburgerContainerController.m
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/16/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "HamburgerContainerController.h"

@interface HamburgerContainerController ()
@property (strong, nonatomic) UIViewController* topVC;
@property (strong, nonatomic) UIButton* burgerButton;
@property (strong, nonatomic) UITapGestureRecognizer* tapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property (strong, nonatomic) UINavigationController* searchVC;


@end

@implementation HamburgerContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // instantiate our searchVC navigation controller (aka the burger) and set it as our top VC
    [self addChildViewController:self.searchVC];
    self.searchVC.view.frame = self.view.frame;
    [self.view addSubview:self.searchVC.view];
    [self.searchVC didMoveToParentViewController:self];
    self.topVC = self.searchVC;
    
    //create our burger button, add it to the view, then set our burgerbutton property
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 44, 44)];
    [button setBackgroundImage:[UIImage imageNamed:@"hamburger"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(burgerButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.searchVC.view addSubview:button];
    self.burgerButton = button;
    
    // set up gesture recogniers
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    // the pan gesture should be available from the start
    [self.topVC.view addGestureRecognizer:self.panGestureRecognizer];
}
// what happens when you smash that burger
- (void) burgerButtonPress{
    // no double smashing the burger
    self.burgerButton.userInteractionEnabled = false;
    //add a weakself
    __weak HamburgerContainerController *weakSelf = self;

    // animate a move over
    [UIView animateWithDuration:.4 animations:^{
        weakSelf.topVC.view.center = CGPointMake(weakSelf.topVC.view.center.x + (weakSelf.view.frame.size.width*0.75), weakSelf.topVC.view.center.y);
        
    } completion:^(BOOL finished) {
        //re-enable the burger
        [weakSelf.topVC.view addGestureRecognizer: weakSelf.tapGestureRecognizer];
    }];
}

// the pan gesture will slide the panel closed
-(void)closePanel {
    // no double tapping
    [self.topVC.view removeGestureRecognizer:self.tapGestureRecognizer];

    __weak HamburgerContainerController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.topVC.view.center = weakSelf.view.center;
    } completion:^(BOOL finished) {
        weakSelf.burgerButton.userInteractionEnabled = true;
    }];
}

// pan gesture slides it open/closed depending on direction
-(void)slidePanel:(id)sender {
    //self.panGestureRecognizer = (UIPanGestureRecognizer *) sender;
    CGPoint translatedPoint = [self.panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [self.panGestureRecognizer velocityInView:self.view];
    
    if ([self.panGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0 || self.topVC.view.frame.origin.x >0) {
            //set translation
            self.topVC.view.center = CGPointMake(self.topVC.view.center.x + translatedPoint.x, self.topVC.view.center.y);
            [self.panGestureRecognizer setTranslation:CGPointZero inView:self.view];
        }//eo if-velocity
    }//eo if-state changed
    
    // if the pan stops, snap the hamburger either open or closed
    if ([self.panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        __weak HamburgerContainerController *weakSelf = self;
        if (self.topVC.view.frame.origin.x > self.view.frame.size.width/3) {
            self.burgerButton.userInteractionEnabled = false;
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.topVC.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.25, weakSelf.topVC.view.center.y);
            } completion:^(BOOL finished) {
                [weakSelf.topVC.view addGestureRecognizer:weakSelf.tapGestureRecognizer];

            }];
        }//eo if-they meant to open the hamburger
        else{
            //they meant to close it
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.topVC.view.center = weakSelf.view.center;
            } completion:^(BOOL finished) {
                weakSelf.burgerButton.userInteractionEnabled = true;
            }];

            [self.topVC.view removeGestureRecognizer:self.tapGestureRecognizer];
        }//eo if-they meant to open or close
    }//eo if-state ended
}//eo slidePanel func

//MARK: Lazy-loading Getters
-(UINavigationController *)searchVC {
    if (!_searchVC) {
        _searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH_VC"];
    }
    return _searchVC;
}

@end
