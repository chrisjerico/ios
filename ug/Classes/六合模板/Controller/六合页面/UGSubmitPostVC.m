//
//  UGSubmitPostVC.m
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSubmitPostVC.h"
#import "UGPostListVC.h"

// View
#import "STBarButtonItem.h"
#import "MediaViewer.h"

// Tools
#import <MobileCoreServices/MobileCoreServices.h>   //
#import "TZImagePickerController.h"                 // 访问系统相册
#import "TZImageManager.h"
#import "AVAsset+Degress.h"


#define TextViewMinHeight 120
#define FontSize 17
#define PhotoItemHeight _CalWidth(100)
#define MaxPhotoCnt 9

@interface UGSubmitPostVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; /**<    动态图片CollectionView */

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;                  /**<    文本CollectionView */
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;             /**<    文本占位符Label */
@property (weak, nonatomic) IBOutlet UILabel *textLengthLabel;              /**<    文本长度Label */

@property (nonatomic) NSMutableArray <UIImage *>*photos;    /**<    动态图片 */

@end

@implementation UGSubmitPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发帖";
    __weakSelf_(__self);
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithTitle:@"历史帖子" block:^(UIButton *sender) {
        UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
        vc.clm = __self.clm;
        vc.isHistory = true;
        [NavController1 pushViewController:vc animated:true];
    }];
    
    _photos = @[].mutableCopy;
    
    // 监听文本长度
    [self xw_addNotificationForName:UITextViewTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
        __self.textLengthLabel.text = _NSString(@"%td/150", __self.textView.text.length);
        __self.textLengthLabel.textColor = __self.textView.text.length > 150 ? APP.AuxiliaryColor2 : APP.TextColor3;
    }];
    
    // 禁用TextView编辑菜单
    [_textView aspect_hookSelector:@selector(canPerformAction:withSender:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aInfo) {
        BOOL ret = false;
        [aInfo.originalInvocation setReturnValue:&ret];
    } error:nil];
    
    _collectionView.superview.hidden = !_photos.count;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (OBJOnceToken(self)) {
        // textView
        self.textView.cc_constraints.height.constant = TextViewMinHeight;
        
        // collectionView
        {
            ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(PhotoItemHeight, PhotoItemHeight);
            [self refreshUI];
        }
        
        __weakSelf_(__self);
        // 点击背景隐藏键盘⌨️
        [self.view addGestureRecognizer:[UITapGestureRecognizer gestureRecognizer:^(__kindof UIGestureRecognizer *gr) {
            [__self.textView resignFirstResponder];
        }]];
    }
}

- (void)refreshUI {
    __weakSelf_(__self);
    
    // CollectionView
    {
        NSInteger count = MIN(__self.photos.count + 1, MaxPhotoCnt);
        NSInteger columnCount = 3;
        NSInteger lineCount = count/columnCount + !!(count%columnCount);
        __self.collectionView.cc_constraints.height.constant = (PhotoItemHeight + 5) * lineCount;
        __self.collectionView.cc_constraints.width.constant = (PhotoItemHeight + 5) * columnCount;
        [__self.collectionView reloadData];
    }
    
    // BottomBarItems
    {
        FastSubViewCode(self.view);
        subButton(@"照片Button").enabled = _photos.count < MaxPhotoCnt;
        _collectionView.superview.hidden = !_photos.count;
    }
}

// 去拍摄
- (void)shoot:(BOOL)videoOrPhoto {
    if (_photos.count && videoOrPhoto)
        return;
    
    // 拍摄视频质量
    // UIImagePickerControllerQualityTypeHigh高清
    // UIImagePickerControllerQualityTypeMedium中等质量
    // UIImagePickerControllerQualityTypeLow低质量
    // UIImagePickerControllerQualityType640x480
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [NavController1 presentViewController:picker animated:true completion:nil];
}

// 去相册
- (void)gallery:(BOOL)videoOrPhoto {
    if (_photos.count && videoOrPhoto)
        return;
    if (_photos.count >= MaxPhotoCnt)
        return;
    
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:(MaxPhotoCnt - _photos.count) delegate:nil];
    picker.navigationBar.barTintColor = APP.NavigationBarColor;
    picker.barItemTextColor = APP.TextColor1;
    picker.navigationBar.barStyle = UIBarStyleDefault;
    picker.allowPickingVideo = videoOrPhoto;
    picker.allowPickingImage = !videoOrPhoto;
    picker.allowPickingOriginalPhoto = false;
    picker.pickerDelegate = self;
    picker.isStatusBarDefault = true;
    
    __weakSelf_(__self);
    // 选中图片
    picker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray <PHAsset *>*assets, BOOL isSelectOriginalPhoto) {
        [HUDHelper showLoadingView].userInteractionEnabled = true;
        
        // 获取原图，压缩，并刷新UI
        // 这里在递归中切换线程，保证每次block都会被销毁，且避免多次调用“获取原图函数”使其并发处理图片导致内存不足崩溃。
        NSMutableArray <UIImage *>*compressedPhotos = [@[] mutableCopy];
        __block NSInteger __idx = 0;
        void (^imageAction)(void);
        void (^__block __imageAction)(void) = imageAction = ^ {
            if (assets.count <= __idx)
                return ;
            PHAsset *asset = assets[__idx++];
            // 获取原图（在回调中会回到主线程）
            [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
                if ([info[PHImageResultIsDegradedKey] boolValue])
                    return ;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [compressedPhotos addObject:[UIImage compressImage:photo toByte:APP.PhotoMaxLength]];
                    
                    if (compressedPhotos.count >= photos.count) {
                        __imageAction = nil;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [HUDHelper hideLoadingView];
                            [__self.photos addObjectsFromArray:compressedPhotos];
                            
                            [__self refreshUI];
                        });
                    } else {
                        if (__imageAction)
                            __imageAction();
                    }
                });
            }];
        };
        imageAction();
    };
    [NavController1 presentViewController:picker animated:YES completion:nil];
}

+ (NSString *)genFilenameWithExt:(NSString *)ext {
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid);
    CFRelease(uuid);
    NSString *uuidStr = [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    NSString *name = [NSString stringWithFormat:@"%@",uuidStr];
    return [ext length] ? [NSString stringWithFormat:@"%@.%@",name,ext]:name;
}


#pragma mark - IBAction

// 添加图片
- (IBAction)onPhotoItemBtnClick:(UIButton *)sender {
    __weakSelf_(__self);
    UIAlertController *ac = [AlertHelper showActionSheet:nil msg:nil btnTitles:@[@"拍照", @"从手机相册选择"] cancel:@"取消"];
    [ac setActionAtTitle:@"拍照" handler:^(UIAlertAction *aa) {
        [__self shoot:false];
    }];
    [ac setActionAtTitle:@"从手机相册选择" handler:^(UIAlertAction *aa) {
        [__self gallery:false];
    }];
}

// 发布动态
- (IBAction)onSubmitBtnClick:(UIButton *)sender {
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];

    if (![[_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""].length) {
        [HUDHelper showMsg:@"标题不能为空！"];
        return;
    }
    if (![[_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""].length) {
        [HUDHelper showMsg:@"内容不能为空！"];
        return;
    }
    
    LoadingView *lv = [HUDHelper showLoadingViewWithSuperview:self.view];
    lv.userInteractionEnabled = true;
    lv.y = NavController1.navigationBar.by;
    lv.iconOffset = CGPointMake(0, -NavController1.navigationBar.by);
    lv.duration = 3600;

    __weakSelf_(__self);
    FastSubViewCode(self.view);
    [NetworkManager1 lhcdoc_postContent:_clm.alias title:_textField.text content:_textView.text images:nil price:subTextField(@"收费TextField").text.doubleValue].completionBlock = ^(CCSessionModel *sm) {
        [HUDHelper hideLoadingView];
        if (!sm.error) {
            NSLog(@"发布动态成功");
            [HUDHelper showMsg:@"发布成功！"];
            [__self.navigationController popViewControllerAnimated:true];
            if (__self.didSubmitAction)
                __self.didSubmitAction();
        }
    };
}


#pragma mark - UIImagePickerControllerDelegate

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //如果是图片
        __weakSelf_(__self);
        [HUDHelper showLoadingView].userInteractionEnabled = true;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *img = [UIImage compressImage:info[UIImagePickerControllerOriginalImage] toByte:APP.PhotoMaxLength];
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUDHelper hideLoadingView];
                [__self.photos addObject:img];
                [__self refreshUI];
            });
        });
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""]) { // 非删除时
        // 文本长度限制
        NSString *resultString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (resultString.length >= textView.text.length && resultString.length > 150) {
            [HUDHelper showMsg:@"不得超过150字符"];
            return false;
        }
    }
    
    // 使用户输入文字始终是黑色
    textView.typingAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:FontSize]};
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    _placeholderLabel.hidden = textView.text.length;
    
    CGFloat h = [textView.attributedText boundingRectWithSize:CGSizeMake(textView.contentSize.width - 10, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      context:nil].size.height;
    h += 40;
    textView.cc_constraints.height.constant = MAX(h, TextViewMinHeight);
}


#pragma mark - UITableView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count < MaxPhotoCnt ? _photos.count + 1 : MaxPhotoCnt;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    __weakSelf_(__self);
    
    if (indexPath.row == _photos.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"加号Cell" forIndexPath:indexPath];
        if (OBJOnceToken(cell)) {
            UIButton *btn = [cell viewWithTagString:@"加号Button"];
            [btn addTarget:__self action:@selector(onPhotoItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"图片Cell" forIndexPath:indexPath];
        FastSubViewCode(cell);
        UIImageView *imgView = [cell viewWithTagString:@"ImageView"];
        imgView.image = _photos[indexPath.row];
        
        UIButton *btn1 = [cell viewWithTagString:@"删除Button"];
        __weak_Obj_(cell, __cell);
        [btn1 removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [btn1 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            NSInteger index = [__self.collectionView indexPathForCell:__cell].row;
            [__self.photos removeObjectAtIndex:index];
            [__self refreshUI];
        }];
        
        UIButton *btn2 = [cell viewWithTagString:@"点击事件Button"];
        [btn2 removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [btn2 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            NSInteger index = [__self.collectionView indexPathForCell:__cell].row;
            
            NSMutableArray *models = [NSMutableArray array];
            for (UIImage *img in __self.photos) {
                MediaModel *mm = [MediaModel new];
                mm.img = img;
                [models addObject:mm];
            }
            
            MediaViewer *vpView = _LoadView_from_nib_(@"MediaViewer");
            vpView.frame = APP.Bounds;
            vpView.models = models;
            vpView.index = index;
            [TabBarController1.view addSubview:vpView];
            
            // 设置入场动画、退场动画
            {
                // 入场动画
                CGRect rect = [imgView convertRect:imgView.bounds toView:APP.Window];
                [vpView showEnterAnimations:rect image:imgView.image];
                
                // 退场动画
                vpView.exitAnimationsBlock = ^CGRect (MediaViewer *mv) {
                    UICollectionViewCell *cell = [__self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:mv.index inSection:0]];
                    UIImageView *imgV = [cell viewWithTagString:@"ImageView"];
                    return [imgV convertRect:imgV.bounds toView:APP.Window];
                };
            }
        }];
    }
    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isTracking || scrollView.isDragging)
        [_textView resignFirstResponder];
}

@end
