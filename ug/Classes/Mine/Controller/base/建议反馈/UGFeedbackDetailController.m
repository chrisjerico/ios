//
//  UGFeedbackDetailController.m
//  ug
//
//  Created by ug on 2019/7/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFeedbackDetailController.h"
#import "UGFeedbackDetailCell.h"
#import "UGMessageModel.h"


@interface UGFeedbackDetailController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, strong) NSMutableArray <UGMessageModel *> *dataArray;

@end

@implementation UGFeedbackDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"反馈记录详情";
    self.tableView.rowHeight = 100;
    self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextView.layer.borderWidth = 0.8;
    self.contentTextView.delegate = self;
    self.submitButton.layer.cornerRadius = 3;
    self.submitButton.layer.masksToBounds = YES;
    [self getFeedbackDetail];
    
    self.tableView.tableHeaderView.height = NavController1.navigationBar.by + 10;
}

- (void)getFeedbackDetail {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *dict = @{@"token":[UGUserModel currentUser].sessid,
                           @"pid":self.item.messageId
                           };
    [CMNetwork getFeedbackDetailWithParams:dict completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGMessageListModel *listModel = model.data;
            [self.dataArray removeAllObjects];
            [self.dataArray addObject:self.item];
            [self.dataArray addObjectsFromArray:listModel.list];
            [self.tableView reloadData];
            
        } failure:^(id msg) {
            
            
        }];
    }];
}

- (IBAction)submitClick:(id)sender {
    ck_parameters(^{
        ck_parameter_non_empty(self.contentTextView.text, @"请输入内容");
    }, ^(id err) {
        [SVProgressHUD showInfoWithStatus:err];
    }, ^{
        if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
            return;
        }
        NSDictionary *params = @{@"pid":self.item.messageId,
                                 @"token":[UGUserModel currentUser].sessid,
                                 @"type":@(self.item.type),
                                 @"content":self.contentTextView.text
                                 };
        [SVProgressHUD showWithStatus:nil];
        [CMNetwork writeMessageWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                self.contentTextView.text = nil;
                [self.contentTextView resignFirstResponder];
                [self getFeedbackDetail];
            } failure:^(id msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }];
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGFeedbackDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGFeedbackDetailCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - text view delegate

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = self.contentTextView.text.length;
    if ([textView.text length] > 200) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 200)];
        [textView.undoManager removeAllActions];
        return;
    }
    NSInteger wordCount = textView.text.length;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/200",(long)wordCount];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)setItem:(UGMessageModel *)item {
    _item = item;
    [self.dataArray insertObject:item atIndex:0];
}

- (NSMutableArray<UGMessageModel *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
