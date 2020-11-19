//
//  ChatListTableViewCell.m
//  UGBWApp
//
//  Created by andrew on 2020/11/17.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "RoomChatModel.h"
@interface ChatListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //名称
@property (weak, nonatomic) IBOutlet UILabel *goLabel;   //进入

@end
@implementation ChatListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([Skin1.skitString isEqualToString:@"经典 1蓝色"]) {
        self.nameLabel.textColor = [UIColor whiteColor];
        self.goLabel.textColor = [UIColor whiteColor];
        self.goLabel.layer.cornerRadius = 5;
        self.goLabel.layer.masksToBounds = YES;
        self.goLabel.layer.borderWidth = 1;
        self.goLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    else{
        self.nameLabel.textColor = Skin1.textColor1;
        self.goLabel.textColor = Skin1.textColor1;
        self.goLabel.layer.cornerRadius = 5;
        self.goLabel.layer.masksToBounds = YES;
        self.goLabel.layer.borderWidth = 1;
        self.goLabel.layer.borderColor =[Skin1.textColor1 CGColor];
    }

    

    
}

- (void)setItem:(RoomChatModel *)item {
    _item = item;
    self.nameLabel.text = item.roomName;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
