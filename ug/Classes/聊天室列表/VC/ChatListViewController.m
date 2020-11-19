//
//  ChatListViewController.m
//  UGBWApp
//
//  Created by andrew on 2020/11/17.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListTableViewCell.h"
#import "CMTimeCommon.h"
#import "RememberPass.h"
#import "WHC_ModelSqlite.h"


@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;            /**<   内容列表 */
@property (nonatomic, strong)NSMutableArray<RoomChatModel *>   *dataArray ;    /**<  数据*/
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
    self.dataArray = [NSMutableArray<RoomChatModel *>  new];
    [self chatgetToken];
}
-(void)tableStyle{
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChatListTableViewCell"];
    self.tableView.rowHeight = 50;
    [self.tableView setBackgroundColor:Skin1.bgColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListTableViewCell" forIndexPath:indexPath];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
    RoomChatModel *model = [self.dataArray objectAtIndex:indexPath.row];
  
        if ([Skin1.skitString isEqualToString:@"经典 1蓝色"]) {
            if (indexPath.row % 2) {
                [cell setBackgroundColor:RGBA(92, 154, 196, 1)];
            } else {
                [cell setBackgroundColor:RGBA(108 ,166 ,208, 1)];
            }
        }
        else{
            if (indexPath.row % 2) {
                [cell setBackgroundColor:Skin1.cellBgColor];
            } else {
                [cell setBackgroundColor:Skin1.homeContentColor];
            }
        }

    cell.item = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RoomChatModel *model = [self.dataArray objectAtIndex:indexPath.row];
    //取数据
    NSArray * rpArray = [WHCSqlite query:[RememberPass class] where:[NSString stringWithFormat:@"roomId = '%@'",model.roomId]];
    RememberPass *rp = (RememberPass *)[rpArray objectAtIndex:0];
    BOOL isPass = NO;
    if (![CMCommon stringIsNull:rp.password]) {
        isPass = YES;
    } else {
        isPass =[CMCommon stringIsNull:model.password];
    }
    if (isPass) {
        if (self.chatListelectBlock) {
            self.chatListelectBlock(model);
        }
    } else {
        // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
        __block UITextField *tf = nil;
        
        [LEEAlert alert].config
        .LeeTitle(@"请输入房间密码")
        .LeeAddTextField(^(UITextField *textField) {
            textField.placeholder = @"请输入房间密码";
            textField.textColor = [UIColor darkGrayColor];
            tf = textField; //赋值
        })

        .LeeAction(@"确定", ^{
            if ([model.password isEqualToString:tf.text]) {
                //保存密码
                RememberPass *rp = [RememberPass new];
                rp.roomId = model.roomId;
                rp.roomName = model.roomName;
                rp.password = model.password;
                [WHCSqlite insert:rp];
                
                if (self.chatListelectBlock) {
                    self.chatListelectBlock(model);
                }
                                            
            } else {
                [CMCommon showToastTitle:@"房间密码错误"];
            }
        })
        .leeShouldActionClickClose(^(NSInteger index){
            // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
            // 这里演示了与输入框非空校验结合的例子
            BOOL result = ![tf.text isEqualToString:@""];
            result = index == 0 ? result : YES;
            return result;
        })
        .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
        .LeeShow();
        
    }
    
}

// 得到线上配置的聊天室
- (void)chatgetToken {
    

    {//得到线上配置的聊天室
        NSDictionary *params = @{@"t":[NSString stringWithFormat:@"%ld",(long)[CMTimeCommon getNowTimestamp]],
                                 @"token":[UGUserModel currentUser].sessid
        };
        [CMNetwork chatgetTokenWithParams:params completion:^(CMResult<id> *model, NSError *err) {
            [CMResult processWithResult:model success:^{
                NSLog(@"model.data = %@",model.data);
                NSDictionary *data = (NSDictionary *)model.data;
                NSMutableArray *chatIdAry = [NSMutableArray new];
                NSMutableArray<UGChatRoomModel *> *chatRoomAry = [NSMutableArray new];
                NSArray * roomAry =[RoomChatModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"chatAry"]];
                NSArray *chatAry = [roomAry sortedArrayUsingComparator:^NSComparisonResult(RoomChatModel *p1, RoomChatModel *p2){
                //对数组进行排序（升序）
                    return p1.sortId > p2.sortId;
                //对数组进行排序（降序）
                // return [p2.dateOfBirth compare:p1.dateOfBirth];
                }];
                //获得数据
                self.dataArray = [[NSMutableArray alloc] initWithArray:chatAry];
                [self.tableView reloadData];
                
                //====================================================
                for (int i = 0; i< chatAry.count; i++) {
                    RoomChatModel *dic =  [chatAry objectAtIndex:i];
                    [chatIdAry addObject:dic.roomId];
                    [chatRoomAry addObject: [UGChatRoomModel mj_objectWithKeyValues:dic]];
                    
                }
                [CMCommon removeLastRoomAction:chatIdAry];
                
                NSNumber *number = [data objectForKey:@"chatRoomRedirect"];
                
                
                MyChatRoomsModel.currentRoom = [MyChatRoomsModel new];;
                SysChatRoom.chatRoomRedirect = [number intValue];
                SysChatRoom.chatRoomAry = chatRoomAry;

                if (![CMCommon arryIsNull:chatRoomAry]) {
                      UGChatRoomModel *obj  = SysChatRoom.defaultChatRoom = [chatRoomAry objectAtIndex:0];
                }
                else{
                    UGChatRoomModel *obj  = [UGChatRoomModel new];
                    obj.roomId = @"0";
                    obj.roomName = @"聊天室";
                    SysChatRoom.defaultChatRoom = obj;
                    
                }
                [MyChatRoomsModel setCurrentRoom:SysChatRoom ];
  
            } failure:^(id msg) {
                //            [self stopAnimation];
            }];
        }];
        
    }
}

@end
