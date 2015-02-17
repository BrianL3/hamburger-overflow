//
//  SearchQuestionsViewController.m
//  hamburger-overflow
//
//  Created by Brian Ledbetter on 2/17/15.
//  Copyright (c) 2015 Brian Ledbetter. All rights reserved.
//

#import "SearchQuestionsViewController.h"
#import "NetworkController.h"
#import "Question.h"
#import "QuestionViewCell.h"


@interface SearchQuestionsViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray* questions;

@end

@implementation SearchQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [[NetworkController sharedService] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSString *error) {
        if (!error){
            self.questions = results;
        }else{
            NSLog(error);
        }
        [self.tableView reloadData];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    Question* question = self.questions[indexPath.row];
    cell.questionLabel.text = question.title;
    cell.avatarImage.image = nil;
    // if the Question does not have a image for their avatar, go get one
    if (!question.avatarImage){
        [[NetworkController sharedService] fetchImageForURL:question.avatarURL completionHandler:^(UIImage *image) {
            question.avatarImage = image;
            cell.avatarImage.image = question.avatarImage;
        }];
    }else {
        //else just use the one we already got
        cell.avatarImage.image = question.avatarImage;
    }//eo check for avatar image
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questions.count;
}

@end
