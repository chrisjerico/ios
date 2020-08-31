//
//  YNQuickSelectView.m
//  UGBWApp
//
//  Created by andrew on 2020/7/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import "YNQuickSelectView.h"
#import "HMSegmentedControl.h"
#import "YNQuickListView.h"
@interface YNQuickSelectView()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic,strong)  NSMutableArray <NSString *> *itemArray;//标题数组
@property (nonatomic,strong)  NSMutableArray <YNQuickListView *> *itemViewArray;//views 数组

@property (nonatomic, assign) NSInteger selectedSegmentIndex;//当前选中的索引
@end

@implementation YNQuickSelectView

- (instancetype)YNQuickSelectView {
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self.subviews.count) {
        self.contentView = [[YNQuickSelectView alloc] initWithFrame:CGRectZero];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        [self myInit];

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentView = [self YNQuickSelectView];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        [self myInit];
    }

    return self;
}

-(void)myInit{
    _itemArray = [NSMutableArray new];
    [self segmentedControlInit:self.itemArray];
    
    _itemViewArray =  [NSMutableArray new];
    self.segmentedControl.selectedSegmentIndex = 0;

}

-(void)setBet:(UGGameBetModel *)bet{
    
    _bet = bet;
    if (![CMCommon arryIsNull:bet.ynFastList]) {
        [self.itemArray removeAllObjects];
        [self.itemViewArray removeAllObjects];
        
        for (UGGameplaySectionModel *dd in bet.ynFastList) {
            if (dd.name) {
                [self.itemArray addObject:dd.name] ;
            }
        }
        
        for (int i = 0; i<bet.ynFastList.count ; i++) {
            UGGameplaySectionModel *dd  = [bet.ynFastList objectAtIndex:i];
            
            YNQuickListView *ynQuickListView = [[YNQuickListView alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:ynQuickListView];
            [ynQuickListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(self);
                make.top.equalTo(self.segmentedControl.mas_bottom);
            }];
            ynQuickListView.dataArry = dd.list;
            
            WeakSelf;
            ynQuickListView.collectIndexBlock = ^(UICollectionView *collectionView,NSIndexPath* indexPath) {
                
                if (self.ynCollectIndexBlock) {
                    self.ynCollectIndexBlock(collectionView,indexPath,weakSelf.selectedSegmentIndex);
                }
            };
            [_itemViewArray addObject:ynQuickListView];
            
        }
        WeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [weakSelf segmentedControlInit:self.itemArray];
            [weakSelf reload];
        });
    }
}



-(void)segmentedControlInit:(NSMutableArray *)arry{
    
    if (!self.segmentedControl) {
        self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:arry];
        self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        self.segmentedControl.frame = CGRectMake(0, 1, self.width, 40);
        self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        self.segmentedControl.verticalDividerEnabled = YES;
        self.segmentedControl.verticalDividerColor = [UIColor blackColor];
        self.segmentedControl.verticalDividerWidth = 1.0f;
        [self.segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{
                NSForegroundColorAttributeName : selected ?Skin1.navBarBgColor: [UIColor blackColor],
                NSFontAttributeName : [UIFont systemFontOfSize:15]
            }];
            return attString;
        }];
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.segmentedControl];
        [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@40);
        }];
    }
    else{
        if (![CMCommon arryIsNull:arry]) {
             self.segmentedControl.sectionTitles = arry;
        }
       
    }
}



- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %tu (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    self.selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self reload];
}


-(void)reload{
    YNQuickListView *ynQuickListView  = [self.itemViewArray objectAtIndex:self.selectedSegmentIndex];
    [self.contentView bringSubviewToFront:ynQuickListView ];
    [ynQuickListView reloadData];
}


@end
