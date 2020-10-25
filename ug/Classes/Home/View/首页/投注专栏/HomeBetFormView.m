//
//  HomeBetFormView.m
//  UGBWApp
//
//  Created by fish on 2020/10/21.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeBetFormView.h"

#import "BetFormViewModel.h"

@interface HomeBetFormView ()
@property (weak, nonatomic) IBOutlet UITableView *betFormTableView;
@property (nonatomic, strong) BetFormViewModel * betFormViewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betFormTableHeight;
@end

@implementation HomeBetFormView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.betFormViewModel = [BetFormViewModel new];
    [self.betFormViewModel setupWithTabeView: _betFormTableView betFormTableHeight: _betFormTableHeight];
}

@end
