//
//  QuestionViewCell.h
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/17/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end
