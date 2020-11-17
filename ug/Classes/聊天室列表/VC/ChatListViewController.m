//
//  ChatListViewController.m
//  UGBWApp
//
//  Created by andrew on 2020/11/17.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListTableViewCell.h"

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;            /**<   内容列表 */
@property (nonatomic, strong)NSMutableArray   *dataArray ;    /**<  数据*/
@end

@implementation ChatListViewController
-(void)dataReLoad{
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor: Skin1.bgColor];
    [self tableStyle];
}
-(void)tableStyle{
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChatListTableViewCell"];
    self.tableView.rowHeight = 50;
    [self.tableView setBackgroundColor:Skin1.bgColor];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListTableViewCell" forIndexPath:indexPath];

    [cell.contentView setBackgroundColor:Skin1.bgColor];
    return cell;
}


// 得到线上配置的聊天室
- (void)chatgetToken {
    

  
}

@end
