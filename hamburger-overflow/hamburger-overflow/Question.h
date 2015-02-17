//
//  Question.h
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/17/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* avatarURL;
@property (strong, nonatomic) UIImage* avatarImage;



+ (NSArray*)questionsFromJSON:(NSData*) jsonData;
@end
