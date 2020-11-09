//
//  BetFormViewModel.m
//  ug
//
//  Created by tim swift on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "BetFormViewModel.h"
#import "HSC_BetFormCell.h"

@interface BetFormViewModel()

@property(nonatomic,retain) dispatch_source_t timer;
@property(nonatomic, strong) NSArray * items;

@end

@implementation BetFormViewModel

- (void)dealloc
{
    dispatch_source_cancel(self.timer);

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray * tempArray = [NSMutableArray array];
        for (int i = 0; i < 60; i ++) {
            [tempArray appendObject:@{@"name": [self randName], @"time": [self randDateString], @"gameImage" : [NSString stringWithFormat:@"hsc_form_game_%d", rand()%4 + 1], @"amount" : [NSString stringWithFormat:@"%d", rand() % 20 * 10 + 10 ] }];
        }
        [tempArray appendObjects:tempArray];
        self.items = tempArray;
    }
    return self;
}



- (void)setupWithTabeView: (UITableView *) tableView
       betFormTableHeight: (NSLayoutConstraint *) betFormTableHeight {
    [tableView registerNib: [UINib nibWithNibName:@"HSC_BetFormCell" bundle:nil] forCellReuseIdentifier:@"HSC_BetFormCell"];

    tableView.delegate  = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView reloadData];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    betFormTableHeight.constant = 6 * 100;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    self.timer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (tableView.tracking || tableView.isDragging || tableView.isDecelerating) {
            return;
        }
        CGPoint previousPoint = tableView.contentOffset;
        if (previousPoint.y >= 6000 && (NSInteger)(previousPoint.y) % 100 == 0) {
            previousPoint.y = 0;
        }
        [tableView setContentOffset:CGPointMake(0, previousPoint.y + 0.5)];
        
    });
    dispatch_resume(timer);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSC_BetFormCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HSC_BetFormCell" forIndexPath:indexPath];
    NSDictionary * item = self.items[indexPath.row];
    [cell bindName:item[@"name"] time:item[@"time"] gameImageName:item[@"gameImage"] number:item[@"amount"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSString *)randDateString {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970: [[NSDate date] timeIntervalSince1970] - rand()%(24*60*60*2)];
    return [date timeAgoSinceDate:[NSDate date] numericDates:false];
}
- (NSString *)randName {
    return [NSString stringWithFormat:@"%c%c***%c", rand()%26+97, rand()%26+97, rand()%10+48];
}
@end

