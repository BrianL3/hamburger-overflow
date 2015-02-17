//
//  NetworkController.h
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/17/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkController : NSObject

+(id) sharedService;

-(void)fetchQuestionsWithSearchTerm: (NSString*) searchTerm completionHandler:(void (^)(NSArray *results, NSString *error))completionHandler;

-(void)fetchImageForURL: (NSString *)avatarURL completionHandler:(void (^) (UIImage *image))completionHandler;

@end
