//
//  NetworkController.m
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/17/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "NetworkController.h"
#import "Question.h"
@interface NetworkController()

@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSString* baseAPIURL;

@end

@implementation NetworkController

// the singleton for our network controller
+(id)sharedService{
    static NetworkController* sharedService = nil;
    // a dispatch once token
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedService = [[NetworkController alloc] init];
        sharedService.key = @"F3axyHlRoihnBpaZKHPiEQ((";
        sharedService.baseAPIURL = @"https://api.stackexchange.com/2.2/";
    });
    return sharedService;
}
//TODO: make a completion handler
-(void)fetchQuestionsWithSearchTerm:(NSString*)searchTerm completionHandler:(void (^)(NSArray *results, NSString *error))completionHandler {
    // create the start of our URL request
    NSString* urlString = self.baseAPIURL;
    urlString = [urlString stringByAppendingString:@"search?order=desc&sort=activity&site=stackoverflow&intitle="];
    urlString = [urlString stringByAppendingString:searchTerm];
    
    //grab our token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"token"];
    
    if(token){
        urlString = [urlString stringByAppendingString:@"&access_token="];
        urlString = [urlString stringByAppendingString:token];
        urlString = [urlString stringByAppendingString:@"&key="];
        urlString = [urlString stringByAppendingString:self.key];
        //do append your token and your key
    }else{
        //throw error
    }
    //create the URL with our urlString
    NSURL* url = [NSURL URLWithString:urlString];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    
    NSURLSession* session = [NSURLSession sharedSession];
    
    NSURLSessionTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionHandler(nil, @"fetchQuestionsWithSearchTerm failed to create NSURLSessionTask");
        }else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
            NSInteger statusCode = httpResponse.statusCode;
            //run a switch on the http response
            switch (statusCode) {
                case 200 ... 299: {
                    NSArray *result = [Question questionsFromJSON:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (result){
                            completionHandler(result, nil);
                        }else{
                            //results were nil
                            completionHandler(nil, @"Status 200 OK but results nil");
                            
                        }//eo check if results nil
                    });
                    break;
                }
                default:
                    completionHandler(nil, [NSString stringWithFormat:@"Status code was %lu", statusCode]);
                    break;
            }
        }
    }];
    [task resume];
}

//fetch the image for the URL, pass the image back via completion block
-(void)fetchImageForURL: (NSString *)avatarURL completionHandler:(void (^) (UIImage *image))completionHandler{
    //create a thread for fetching the image
    dispatch_queue_t imageQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    // async get the image
    dispatch_async(imageQueue, ^{
        NSURL *url = [NSURL URLWithString:avatarURL];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        //completion block the image back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(image);
        }); //eo completion block sending image to main Q
    }); // eo completion block getting image
}
@end
