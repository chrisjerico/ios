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

#import "TZImagePickerController.h"

@interface UGAvaterSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *avatersBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigImgViewTopConstraint;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <UGAvatarModel *> *dataArray;
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
       
        [self.submitButton setBackgroundColor: Skin1.navBarBgColor];
        self.cancelButton.layer.cornerRadius = 3;
        self.cancelButton.layer.masksToBounds = YES;
        [self initCollectionView];
        [self setBackgroundColor: Skin1.bgColor];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.bounds, point)) {
        
    } else {
        [self hiddenSelf];
    }
    return view;
}

- (void)getAvatarList:(void (^)(BOOL canUpload))completed {
    _bigImgViewTopConstraint.constant = 20;
    [SVProgressHUD showWithStatus: nil];
    WeakSelf;
    [NetworkManager1 user_getAvatarSetting].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        if (!err) {
            [SVProgressHUD dismiss];
            NSMutableArray *temp = @[].mutableCopy;
            for (NSDictionary *dict in resObject[@"data"][@"publicAvatarList"]) {
                [temp addObject:[UGAvatarModel mj_objectWithKeyValues:dict]];
            }
            weakSelf.dataArray = temp;
            if (!weakSelf.dataArray.count) {
                return ;
            }
            UGAvatarModel *avatar = self.dataArray.firstObject;
            [weakSelf.collectionView reloadData];
            [weakSelf.bigImgView sd_setImageWithURL:[NSURL URLWithString:avatar.url] placeholderImage:[UIImage imageNamed:@"txp"] options:SDWebImageAllowInvalidSSLCertificates];
            
            BOOL canUpload = resObject[@"data"][@"isAcceptUpload"];
            if (canUpload) {
                weakSelf.bigImgViewTopConstraint.constant = 60;
            }
            
            if (completed)
                completed(canUpload);
        }
    };
}

- (void)changAvatar:(UGAvatarModel *)avatar {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [NetworkManager1 user_updateAvatar:avatar.filename].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        if (!err) {
            [SVProgressHUD showSuccessWithStatus:resObject[@"msg"]];
            UGUserModel *user = [UGUserModel currentUser];
            user.avatar = avatar.url;
            SANotificationEventPost(UGNotificationUserAvatarChanged, nil);
            [weakSelf hiddenSelf];
        }
    };
}


#pragma mark - IBAction

- (IBAction)onUploadAvatarBtnClick:(UIButton *)sender {
    __weakSelf_(__self);
    TZImagePickerController *ipc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    ipc.allowTakeVideo = false;
    ipc.allowPickingVideo = false;
    ipc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingFormat:@"%d.png", arc4random()%10000];
        [UIImagePNGRepresentation(photos.firstObject) writeToFile:path atomically:true];
        [SVProgressHUD show];
        [NetworkManager1 user_uploadAvatar:path].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            if (!err) {
                [SVProgressHUD showSuccessWithStatus:resObject[@"msg"]];
                [__self hiddenSelf];
                BOOL isReview = [resObject[@"data"][@"isReview"] boolValue];
                if (!isReview) {
                    SANotificationEventPost(UGNotificationGetUserInfo, nil);
                }
            }
        };
    };
    [NavController1 presentViewController:ipc animated:true completion:^{}];
}

- (IBAction)submitClick:(id)sender {
    [self changAvatar:self.dataArray[self.selIndex]];
}

- (IBAction)cancelClick:(id)sender {
    [self hiddenSelf];
}

- (IBAction)leftClick:(id)sender {
    [_collectionView setContentOffset:({
        CGPoint offset = self.collectionView.contentOffset;
        offset.x -= _collectionView.width;
        offset.x = MAX(offset.x, 0);
        offset;
    }) animated:true];
}

- (IBAction)rightClick:(id)sender {
    [_collectionView setContentOffset:({
        CGPoint offset = self.collectionView.contentOffset;
        offset.x += _collectionView.width;
        offset.x = MIN(offset.x, _collectionView.contentSize.width-_collectionView.width);
        offset;
    }) animated:true];
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


#pragma mark - UICollectionViewDelagate

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
    __weakSelf_(__self);
    [self getAvatarList:^(BOOL canUpload) {
        UIWindow* window = UIApplication.sharedApplication.keyWindow;
        UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
        UIView* view = __self;
        view.height += canUpload * 40;
        
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        [maskView addSubview:view];
        [window addSubview:maskView];
        [UIView animateWithDuration:0.25 animations:^{
            view.y = __self.oldFrame.origin.y - view.height;
        }];
    }];
}


#pragma mark -

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

- (NSMutableArray<UGAvatarModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
