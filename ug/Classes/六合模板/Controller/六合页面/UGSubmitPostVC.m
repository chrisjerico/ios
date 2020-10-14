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

// Model
#import "UGLHPostModel.h"

// Tools
#import <MobileCoreServices/MobileCoreServices.h>   //
#import "TZImagePickerController.h"                 // 访问系统相册
#import "TZImageManager.h"
#import "AVAsset+Degress.h"
#import "YYText.h"
#import "YYAnimatedImageView.h"

#define TextViewMinHeight 250
#define FontSize 17
#define PhotoItemHeight _CalWidth(100)
#define MaxPhotoCnt 3



@interface YYTextView (Utils)
@end

@implementation YYTextView (Utils)
- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    Class Cls_selectionView = NSClassFromString(@"UITextSelectionView");
    Class Cls_selectionGrabberDot = NSClassFromString(@"UISelectionGrabberDot");
    if ([view isKindOfClass:[Cls_selectionGrabberDot class]]) {
        view.layer.contents = [UIView new];
    }
    if ([view isKindOfClass:[Cls_selectionView class]]) {
        view.hidden = YES;
    }
}
@end





@interface UGSubmitPostVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate, YYTextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView; /**<    帖子图片CollectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *gifCollectionView;   /**<    git图CollectionView */

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;             /**<    文本占位符Label */
@property (weak, nonatomic) IBOutlet UILabel *textLengthLabel;              /**<    文本长度Label */


@property (nonatomic, strong) YYTextView *textView;                  /**<    YYTextView */
@property (nonatomic, strong) NSMutableString *content;

@property (nonatomic) NSMutableArray <UIImage *>*photos;    /**<    动态图片 */
@property (nonatomic, assign) double priceMax;  /**<   最大价格 */
@property (nonatomic, assign) double priceMin;  /**<   最小价格 */
@end

@implementation UGSubmitPostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发帖";
    __weakSelf_(__self);
    self.navigationItem.rightBarButtonItem = [STBarButtonItem barButtonItemWithTitle:@"历史帖子" block:^(UIButton *sender) {
        UGPostListVC *vc = _LoadVC_from_storyboard_(@"UGPostListVC");
        vc.title = @"历史记录";
        vc.request = ^CCSessionModel * _Nonnull(NSInteger page) {
            return [NetworkManager1 lhdoc_historyContent:__self.clm.cid page:page];
        };
        [NavController1 pushViewController:vc animated:true];
    }];
    
    _photos = @[].mutableCopy;
    LHPriceModel *pm = [SysConf.lhcPriceList objectWithValue:_clm.alias keyPath:@"alias"];
    _priceMax = MAX(pm.priceMax, 0);
    _priceMin = MAX(pm.priceMin, 0);
    
    // 监听文本长度
    [self xw_addNotificationForName:UITextViewTextDidChangeNotification block:^(NSNotification * _Nonnull noti) {
        __self.textLengthLabel.text = _NSString(@"%td/150", __self.textView.text.length);
        __self.textLengthLabel.textColor = __self.textView.text.length > 150 ? APP.AuxiliaryColor2 : APP.TextColor3;
    }];
    
    FastSubViewCode(self.view);
//    subTextField(@"收费TextField").placeholder = _FloatString2(_priceMin);
    [subButton(@"发帖Btn") setBackgroundColor:Skin1.navBarBgColor];
    subTextField(@"收费TextField").superview.hidden = [_FloatString2(_priceMax) isEqualToString:@"0"];
    subImageView(@"表情ImageView").image = UGLHPostModel.allEmoji.firstObject;
    _photoCollectionView.superview.hidden = !_photos.count;
    
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[IQKeyboardManager sharedManager] registerTextFieldViewClass:[YYTextView class] didBeginEditingNotificationName:YYTextViewTextDidBeginEditingNotification didEndEditingNotificationName:YYTextViewTextDidEndEditingNotification];
        });
        _content = @"".mutableCopy;
        _textView = [[YYTextView alloc] initWithFrame:CGRectMake(28, 6, APP.Width-56, 250)];
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.delegate = self;
        [_gifCollectionView.superview insertSubview:_textView atIndex:0];
        
        // 禁用TextView编辑菜单
        [_textView aspect_hookSelector:@selector(canPerformAction:withSender:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aInfo) {
            BOOL ret = false;
            [aInfo.originalInvocation setReturnValue:&ret];
        } error:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (OBJOnceToken(self)) {
        // textView
        self.gifCollectionView.cc_constraints.height.constant = TextViewMinHeight;
        
        // photoCollectionView
        {
            ((UICollectionViewFlowLayout *)self.photoCollectionView.collectionViewLayout).itemSize = CGSizeMake(PhotoItemHeight, PhotoItemHeight);
            [self refreshUI];
        }
    }
}

- (void)refreshUI {
    __weakSelf_(__self);
    
    // CollectionView
    {
        NSInteger count = MIN(__self.photos.count + 1, MaxPhotoCnt);
        NSInteger columnCount = 3;
        NSInteger lineCount = count/columnCount + !!(count%columnCount);
        __self.photoCollectionView.cc_constraints.height.constant = (PhotoItemHeight + 5) * lineCount;
        __self.photoCollectionView.cc_constraints.width.constant = (PhotoItemHeight + 5) * columnCount;
        [__self.photoCollectionView reloadData];
    }
    
    // BottomBarItems
    {
        FastSubViewCode(self.view);
        subButton(@"照片Button").enabled = _photos.count < MaxPhotoCnt;
        _photoCollectionView.superview.hidden = !_photos.count;
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

// 显示/隐藏表情
- (IBAction)onGifBtnClick:(id)sender {
    _gifCollectionView.hidden = !_gifCollectionView.hidden;
}
// 隐藏表情
- (IBAction)onHideGifBtnClick:(id)sender {
    _gifCollectionView.hidden = true;
}

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

// 发贴
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
    FastSubViewCode(self.view);
    double price = subTextField(@"收费TextField").text.doubleValue;
    if (price > 0.001) {
        if (price < _priceMin) {
            [HUDHelper showMsg:@"收费不能低于%@", _FloatString2(_priceMin)];
            return;
        } else if (price > _priceMax) {
            [HUDHelper showMsg:@"收费不能高于%@", _FloatString2(_priceMax)];
            return;
        }
    }
    
    NSMutableString *text = _textView.text.mutableCopy;
    NSRange r = NSMakeRange(0, _textView.attributedText.length);
    NSInteger idx = r.length;
    while (idx-- > 0) {
        NSDictionary *dict = [_textView.attributedText attributesAtIndex:idx effectiveRange:&r];
        if (dict[@"YYTextAttachment"] && dict[@"表情文本"]) {
            [text insertString:dict[@"表情文本"] atIndex:idx];
        }
    }
    text = [text stringByReplacingOccurrencesOfString:@"￼" withString:@""].mutableCopy; // 别删，看起来是个空串实际上是一个Xcode识别不出来的字符，使用YYText添加表情就会有这个字符，这里替换掉否则h5会显示这个字符出来
    
    LoadingView *lv = [HUDHelper showLoadingViewWithSuperview:self.view];
    lv.userInteractionEnabled = true;
    lv.y = NavController1.navigationBar.by;
    lv.iconOffset = CGPointMake(0, -NavController1.navigationBar.by);
    lv.duration = 3600;

    __weakSelf_(__self);
    [NetworkManager1 lhcdoc_postContent:_clm.alias title:_textField.text content:text images:_photos price:price].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
        [HUDHelper hideLoadingView];
        if (!sm.error) {
            
            [__self.navigationController popViewControllerAnimated:true];
            if (__self.didSubmitAction)
                __self.didSubmitAction();
            [AlertHelper showAlertView:sm.resObject[@"msg"] msg:nil btnTitles:@[@"确定"]];
        }
        else{
            NSDictionary *responeDic = (NSDictionary *) sm.resObject;
            NSDictionary *extra = [responeDic objectForKey:@"extra"];
            NSNumber *hasNickname = (NSNumber *) [extra objectForKey:@"hasNickname"];
            BOOL ishas = [hasNickname boolValue];
            if (hasNickname && !ishas) {
                sm.noShowErrorHUD = true;
                
                // 使用一个变量接收自定义的输入框对象 以便于在其他位置调用
                __block UITextField *tf = nil;
                [LEEAlert alert].config
                .LeeTitle(@"论坛昵称")
                .LeeContent(@"为了保护您的隐私，请绑定论坛昵称")
                .LeeAddTextField(^(UITextField *textField) {
                    textField.placeholder = @"请输入昵称：1-8个汉字";
                    textField.textColor = [UIColor darkGrayColor];
                    textField.限制长度 = 8;
                    tf = textField; //赋值
                })

                .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
                .LeeDestructiveAction(@"好的", ^{
                    if (!tf.text.length) {
                        return ;
                    }
                    if (!tf.text.isChinese) {
                        [HUDHelper showMsg:@"请输入纯汉字昵称"];
                        return;
                    }
                    [NetworkManager1 lhcdoc_setNickname:tf.text].successBlock = ^(CCSessionModel *sm, id responseObject) {
                        [NetworkManager1 lhcdoc_postContent:__self.clm.alias title:__self.textField.text content:text images:__self.photos price:price].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
                            NSLog(@"responseObject = %@",responseObject);
                            if (!sm.error) {
                                [__self.navigationController popViewControllerAnimated:true];
                                if (__self.didSubmitAction)
                                    __self.didSubmitAction();
                                [AlertHelper showAlertView:sm.resObject[@"msg"] msg:nil btnTitles:@[@"确定"]];
                            }
                        };
                    };
                    
                })
                .leeShouldActionClickClose(^(NSInteger index){
                    // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
                    // 这里演示了与输入框非空校验结合的例子
                    BOOL result = ![tf.text isEqualToString:@""];
                    result = index == 1 ? result : YES;
                    return result;
                })
                .LeeShow();
            }
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
//    if (![text isEqualToString:@""]) { // 非删除时
//        // 文本长度限制
//        NSString *resultString = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        if (resultString.length >= textView.text.length && resultString.length > 150) {
//            [HUDHelper showMsg:@"不得超过150字符"];
//            return false;
//        }
//    }
    
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
    h = MAX(h, TextViewMinHeight);
    _textView.height = h;
    _gifCollectionView.cc_constraints.height.constant = h;
}


#pragma mark - UITableView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _gifCollectionView) {
        return UGLHPostModel.allEmoji.count;
    } else {
        return _photos.count < MaxPhotoCnt ? _photos.count + 1 : MaxPhotoCnt;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    __weakSelf_(__self);
    if (collectionView == _gifCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        FastSubViewCode(cell);
        UIImage *image = subImageView(@"ImageView").image = UGLHPostModel.allEmoji[indexPath.item];
        [subButton(@"GifButton") removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [subButton(@"GifButton") addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            __self.textView.attributedText = ({
                NSMutableAttributedString *text = __self.textView.attributedText.mutableCopy;
                UIFont *font = [UIFont systemFontOfSize:17];
                YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                [attachText addAttributes:@{@"表情文本":[UGLHPostModel keyWithImage:image]} range:NSMakeRange(0, 1)];
                [text insertAttributedString:attachText atIndex:__self.textView.selectedRange.location];
                text;
            });
            __self.gifCollectionView.hidden = true;
        }];
        return cell;
    }
    
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
            NSInteger index = [__self.photoCollectionView indexPathForCell:__cell].row;
            [__self.photos removeObjectAtIndex:index];
            [__self refreshUI];
        }];
        
        UIButton *btn2 = [cell viewWithTagString:@"点击事件Button"];
        [btn2 removeAllBlocksForControlEvents:UIControlEventTouchUpInside];
        [btn2 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
            NSInteger index = [__self.photoCollectionView indexPathForCell:__cell].row;
            
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
                    UICollectionViewCell *cell = [__self.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:mv.index inSection:0]];
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
    if (scrollView != _textView && (scrollView.isTracking || scrollView.isDragging))
        [_textView resignFirstResponder];
}

@end
