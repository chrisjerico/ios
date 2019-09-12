//
//  UGFundsBankView.m
//  ug
//
//  Created by ug on 2019/9/12.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGFundsBankView.h"
#import "UGOneTitleTableViewCell.h"
@interface UGFundsBankView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, assign) NSInteger selectSection;

@end
@implementation UGFundsBankView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGFundsBankView" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectSection = 0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self.tableView registerNib:[UINib nibWithNibName:@"UGOneTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"UGOneTitleTableViewCell"];
        //         [self.tableView registerNib:[UINib nibWithNibName:@"UGSingInHistoryTableViewCell" bundle:nil] forHeaderFooterViewReuseIdentifier:historyHeaderViewid];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.layer.cornerRadius = 5;
        
    }
    return self;
    
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
    
}

- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    self.title1Label.text = nameStr;
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGOneTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGOneTitleTableViewCell" forIndexPath:indexPath];
    cell.item = (UGrechargeBankModel*)self.dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   UGrechargeBankModel *model = self.dataArray[indexPath.row];
    
    if (self.signInHeaderViewnBlock) {
        self.signInHeaderViewnBlock(model);
        [self hiddenSelf];
    }
    
}


- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}

@end

