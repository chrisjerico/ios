//
//  BetFormViewModel.h
//  ug
//
//  Created by tim swift on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BetFormViewModel : NSObject<UITableViewDelegate, UITableViewDataSource>

- (void)setupWithTabeView: (UITableView *) tableView
       betFormTableHeight: (NSLayoutConstraint *) betFormTableHeight;
@end

NS_ASSUME_NONNULL_END
