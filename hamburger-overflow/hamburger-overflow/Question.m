//
//  Question.m
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/17/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "Question.h"

@interface Question()

@end

@implementation Question


// class method for generating instances from a json blob
+ (NSArray*)questionsFromJSON:(NSData*) jsonData{
    NSError* error;
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if(error){
        // printl something useful then fail
        return nil;
    }
    NSArray* items = [jsonDictionary objectForKey:@"items"];
    
    NSMutableArray* temp = [[NSMutableArray alloc] init];
    for (NSDictionary* item in items){
        Question* question = [[Question alloc] init];
        question.title = item[@"title"];
        NSDictionary* userInfo = item[@"owner"];
        question.avatarURL = userInfo[@"profile_image"];
        
        [temp addObject:question];
    }
    NSArray *final = [[NSArray alloc] initWithArray:temp];
    return final;
}


@end