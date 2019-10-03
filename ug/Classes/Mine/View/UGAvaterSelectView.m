//
//  UGAvaterSelectView.m
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAvaterSelectView.h"
#import "UGAvaterCollectionViewCell.h"
#import "UGAvatarModel.h"

@interface UGAvaterSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *avatersBgView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) NSInteger selIndex;
@property (nonatomic, assign) NSInteger leftIndex;
@property (nonatomic, assign) NSInteger reghtIndex;
@end

static NSString *avaterCellid = @"UGAvaterCollectionViewCell";
@implementation UGAvaterSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:0].firstObject;
        self.frame = frame;
        self.oldFrame = frame;
        self.selIndex = 0;
        self.leftIndex= 1;
        self.reghtIndex= 4;
        self.submitButton.layer.cornerRadius = 3;
        self.submitButton.layer.masksToBounds = YES;
        self.cancelButton.layer.cornerRadius = 3;
        self.cancelButton.layer.masksToBounds = YES;
        [self initCollectionView];
        [self getAvatarList];
        [self setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];

    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point)) {
        
    }else {
        [self hiddenSelf];
    }
    return view;
}

- (void)getAvatarList {
    [SVProgressHUD showWithStatus: nil];
    [CMNetwork getAvatarListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD dismiss];
            self.dataArray = model.data;
            if (!self.dataArray.count) {
                return ;
            }
            UGAvatarModel *avatar = self.dataArray.firstObject;
            [self.collectionView reloadData];
            [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:avatar.url] placeholderImage:[UIImage imageNamed:@"txp"]];
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}

- (void)changAvatar:(UGAvatarModel *)avatar {
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"filename":avatar.filename
                             };
    [SVProgressHUD showWithStatus:nil];
    [CMNetwork changeAvatarWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            [SVProgressHUD showSuccessWithStatus:model.msg];
            UGUserModel *user = [UGUserModel currentUser];
            user.avatar = avatar.url;
            SANotificationEventPost(UGNotificationUserAvatarChanged, nil);
            [self hiddenSelf];
        } failure:^(id msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }];
    
}

- (IBAction)submitClick:(id)sender {
    
    [self changAvatar:self.dataArray[self.selIndex]];
    
}

- (IBAction)cancelClick:(id)sender {
    
    [self hiddenSelf];
}

- (IBAction)leftClick:(id)sender {
    
   
//    NSLog(@"self.dataArray.count = %lu",(unsigned long)self.dataArray.count);
//    NSLog(@"self.leftIndex = %lu",(unsigned long)self.leftIndex);
//
//
//    if (self.leftIndex >= self.dataArray.count-2 || self.leftIndex<1) {
//        return;
//    } else {
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow: self.leftIndex inSection:0];
////        UICollectionViewScrollPositionLeft                 = 1 << 3,
////        UICollectionViewScrollPositionCenteredHorizontally = 1 << 4,
////        UICollectionViewScrollPositionRight                = 1 << 5
//
//        [self layoutIfNeeded];
//        [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//
//          self.leftIndex += 1;
//    }
//

}

- (IBAction)rightClick:(id)sender {
    NSLog(@"self.dataArray.count = %lu",(unsigned long)self.dataArray.count);
    NSLog(@"self.reghtIndex = %lu",(unsigned long)self.reghtIndex);
    
    
//    if (self.reghtIndex<= 0 ||self.reghtIndex>_dataArray.count-1) {
//        return;
//    } else {
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow: self.reghtIndex inSection:0];
//        //        UICollectionViewScrollPositionLeft                 = 1 << 3,
//        //        UICollectionViewScrollPositionCenteredHorizontally = 1 << 4,
//        //        UICollectionViewScrollPositionRight                = 1 << 5
//
//        [self layoutIfNeeded];
//        [self.collectionView scrollToItemAtIndexPath:scrollIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//
//        self.reghtIndex -= 1;
//    }
    
    
}

- (void)initCollectionView {
    
    float itemW = self.width / 6;
    UICollectionViewFlowLayout *layout = ({
        
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout;
        
    });
    
    UICollectionView *collectionView = ({
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(35, 0, self.avatersBgView.width - 100, self.avatersBgView.height) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerNib:[UINib nibWithNibName:@"UGAvaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:avaterCellid];
        
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView;
        
    });
    
    self.collectionView = collectionView;
    [self.avatersBgView addSubview:collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UGAvaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:avaterCellid forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selIndex = indexPath.row;
    UGAvatarModel *model = self.dataArray[indexPath.row];
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"txp"]];
}

- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    [UIView animateWithDuration:0.25 animations:^{
        view.y = self.oldFrame.origin.y - view.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
        view.y = self.oldFrame.origin.y;
    } completion:^(BOOL finished) {
        [view.superview removeFromSuperview];
        [view removeFromSuperview];
    }];
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    CGPoint point=self.collectionView.contentOffset;
//    NSLog(@"%f,%f",point.x,point.y);
//
//    float y = point.y;
//    int  index = y/60;
//
//    self.leftIndex= index+1;
//    self.reghtIndex = index+4;
//
//    NSLog(@"leftIndex=%d,reghtIndex=%d",index+1,index+4);
}
#pragma mark - scrollView 停止滚动监测

@end
