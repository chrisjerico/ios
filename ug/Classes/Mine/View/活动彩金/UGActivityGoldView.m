//
//  UGActivityGoldView.m
//  ug
//
//  Created by ug on 2019/9/19.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGActivityGoldView.h"
#import "UITextView+Extension.h"
#import "UGMosaicGoldModel.h"
#import "UGContentMoneyCollectionViewCell.h"
#import "OpenUDID.h"

#import "UGMosaicGoldViewController.h"
#define SCHorizontalMargin   5.0f
#define SCVerticalMargin     5.0f


@interface UGActivityGoldView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *validationImageView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;


@property (strong, nonatomic) NSMutableArray <NSString *> *quickAmountArray;

@property (nonatomic, assign) NSInteger selectSection;
@end


@implementation UGActivityGoldView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //
    FastSubViewCode(self);
    {
        self.layer.cornerRadius = 10; 
        self.layer.masksToBounds = true;
        
        subLabel(@"标题Label").textColor = Skin1.navBarBgColor;
        subButton(@"确定Button").backgroundColor = Skin1.navBarBgColor;
        subButton(@"关闭btn").layer.borderWidth = 1;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"UGContentMoneyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGContentMoneyCollectionViewCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_textView setPlaceholderWithText:@"申请说明" Color:UGRGBColor(205, 205, 209)];
        
        _webView.scrollView.bounces = false;
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_webView xw_addObserverBlockForKeyPath:@"scrollView.contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
            CGFloat h = [newVal CGSizeValue].height;
            ((UIWebView *)obj).cc_constraints.height.constant = h;
        }];
        [_webView setOpaque:NO];
        
        if (Skin1.isBlack) {
            [self setBackgroundColor:Skin1.bgColor];
            [subLabel(@"标题Label") setTextColor:[UIColor whiteColor]];
            [subLabel(@"活动说明Label") setTextColor:[UIColor whiteColor]];
            [subLabel(@"快捷金额Label") setTextColor:[UIColor whiteColor]];
            [subTextField(@"金额TextField") setTextColor:[UIColor whiteColor]];
            [_textView setTextColor:[UIColor whiteColor]];
            [subTextField(@"验证码TextField") setTextColor:[UIColor whiteColor]];
            [subButton(@"关闭btn") setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            subButton(@"关闭btn").layer.borderColor = [UIColor whiteColor].CGColor;
            
        } else {
            [self setBackgroundColor:[UIColor whiteColor]];
            [subLabel(@"标题Label") setTextColor:[UIColor blackColor]];
            [subLabel(@"活动说明Label") setTextColor:[UIColor blackColor]];
            [subLabel(@"快捷金额Label") setTextColor:[UIColor blackColor]];
            [subTextField(@"金额TextField") setTextColor:[UIColor blackColor]];
            [_textView setTextColor:[UIColor blackColor]];
            [subTextField(@"验证码TextField") setTextColor:[UIColor blackColor]];
            [subButton(@"关闭btn") setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            subButton(@"关闭btn").layer.borderColor = [UIColor blackColor].CGColor;
            
        }
        [CMCommon textFieldSetPlaceholderLabelColor:RGBA(159, 166, 173, 1) TextField:subTextField(@"验证码TextField")];
        [CMCommon textFieldSetPlaceholderLabelColor:RGBA(159, 166, 173, 1) TextField:subTextField(@"金额TextField")];
    }
    
    // 验证码
    [self imageButtonClicked:nil];
    
    
    // 键盘事件
    {
        __weakSelf_(__self);
        __block CGFloat __bottom = 0;
        
        [self xw_addNotificationForName:UIKeyboardWillShowNotification block:^(NSNotification * _Nonnull noti) {
            UITextField *tf = ({
                if (subTextField(@"金额TextField").isFirstResponder)
                    tf = subTextField(@"金额TextField");
                if (subTextField(@"验证码TextField").isFirstResponder)
                    tf = subTextField(@"验证码TextField");
                if (subTextField(@"说明TextView").isFirstResponder)
                    tf = subTextField(@"说明TextView");
                tf;
            });
            __bottom = __self.height - ([tf convertRect:tf.bounds toView:__self].origin.y + tf.height);
            CGFloat h = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
            [UIView animateWithDuration:0.25 animations:^{
                __self.centerY = APP.Height/2 - h + __bottom + 40;
            }];
        }];
        [self xw_addNotificationForName:UITextFieldTextDidBeginEditingNotification block:^(NSNotification * _Nonnull noti) {
            
        }];
        [self xw_addNotificationForName:UIKeyboardWillHideNotification block:^(NSNotification * _Nonnull noti) {
            [UIView animateWithDuration:0.25 animations:^{
                __self.centerY = APP.Height/2;
            }];
        }];
    }
}

- (void)setItem:(UGMosaicGoldParamModel *)item {
    _item = item;
    
    NSLog(@"item=%@",item);
    _quickAmountArray = ({
        _quickAmountArray = [NSMutableArray new];
        for (int i = 1 ; i<=12; i++) {
            NSString *str = [item valueForKey:_NSString(@"quickAmount%d", i)];
            if (![CMCommon stringIsNull:str])
                if (str.doubleValue > 0)
                    [_quickAmountArray addObject:str];
        }
        _quickAmountArray;
    });
    
    
    FastSubViewCode(self);
    NSLog(@"item.showWinAmount=%d",item.showWinAmount);
    if (item.showWinAmount) {
        subTextField(@"金额TextField").hidden = NO;
        subLabel(@"快捷金额Label").hidden = !_quickAmountArray.count;
        _collectionView.hidden = !_quickAmountArray.count;
    }
    else {
        subTextField(@"金额TextField").hidden = YES;
        subLabel(@"快捷金额Label").hidden = true;
        _collectionView.hidden = true;
    }
    subTextField(@"验证码TextField").hidden = false;
    
    
    NSLog(@"self.item.win_apply_content = %@", self.item.win_apply_content);
    
    [self.webView loadHTMLString:[APP htmlStyleString:self.item.win_apply_content] baseURL:nil];
    
    
    //    NSString *str = _NSString(@"<head><style>img{width:auto !important;max-width:%f;height:auto}</style></head>%@", self.width-30, self.item.win_apply_content);
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,} documentAttributes:nil error:nil];
    //        NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
    //        ps.lineSpacing = 5;
    //        [mas addAttributes:@{NSParagraphStyleAttributeName:ps,} range:NSMakeRange(0, mas.length)];
    //
    //        // 替换文字颜色
    //        NSAttributedString *as = [mas copy];
    //        for (int i=0; i<as.length; i++) {
    //            NSRange r = NSMakeRange(0, as.length);
    //            NSMutableDictionary *dict = [as attributesAtIndex:i effectiveRange:&r].mutableCopy;
    //            UIColor *c = dict[NSForegroundColorAttributeName];
    //            if (fabs(c.red - c.green) < 0.05 && fabs(c.green - c.blue) < 0.05) {
    //                dict[NSForegroundColorAttributeName] = Skin1.textColor2;
    //                [mas addAttributes:dict range:NSMakeRange(i, 1)];
    //            }
    //        }
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self.webView loadHTMLString:mas baseURL:nil];
    //        });
    //    });
}

- (void)show {
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
}


#pragma mark - IBAction
- (void)hiddenSelf {

//    UIView *view = self;
//    self.superview.backgroundColor = [UIColor clearColor];
//    [view.superview removeFromSuperview];
//    [view removeFromSuperview];
    [SGBrowserView hide];
}
- (IBAction)close:(id)sender {

        [self hiddenSelf];
}



- (IBAction)okButtonClicked:(id)sender {

    FastSubViewCode(self);
    // 得到领取连续签到奖励数据
    
    if (!subTextField(@"金额TextField").hidden) {
        if ([CMCommon stringIsNull:subTextField(@"金额TextField").text]) {
            [self makeToast:@"申请金额不能为空"];
            return;
        }
    }
    
    if ([CMCommon stringIsNull:_textView.text]) {
        [self makeToast:@"申请说明不能为空"];
        return;
    }
    if ([CMCommon stringIsNull:subTextField(@"验证码TextField").text]) {
        [self makeToast:@"验证码不能为空"];
        return;
    }
    
    NSString *pid = self.item.mid;
    
    NSString *amount = [subTextField(@"金额TextField").text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *userComment = [_textView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *imgCode = [subTextField(@"验证码TextField").text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params;
    if (_item.showWinAmount) {
        params = @{@"token":[UGUserModel currentUser].sessid,
                   @"id":pid,
                   @"amount":amount,
                   @"userComment":userComment,
                   @"imgCode":imgCode
        };
    } else {
        params = @{@"token":[UGUserModel currentUser].sessid,
                   @"id":pid,
                   @"userComment":userComment,
                   @"imgCode":imgCode
        };
    }
    
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork activityApplyWinWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [SVProgressHUD showSuccessWithStatus:model.msg];
                [self close:nil];
            });
            
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            [self close:nil];
        }];
    }];
}

- (IBAction)imageButtonClicked:(id)sender {
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"accessToken":[OpenUDID value]
    };
    
    [CMNetwork getImgVcodeWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        if (!err) {
            NSData *data = (NSData *)model;
            NSString *imageStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            imageStr = [imageStr substringFromIndex:22];
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:imageStr ? : @"" options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            self.validationImageView.image = decodedImage;
        }
    }];
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _quickAmountArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UGContentMoneyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGContentMoneyCollectionViewCell" forIndexPath:indexPath];
    cell.myStr = [_quickAmountArray objectAtIndex:indexPath.row];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 20.0f;
    CGFloat width = [self gainStringWidthWithString:_quickAmountArray[indexPath.row] font:13.0f height:height];
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
    FastSubViewCode(self);
    subTextField(@"金额TextField").text = [_quickAmountArray objectAtIndex:indexPath.row];
}

- (CGFloat)gainStringWidthWithString:(NSString *)string font:(CGFloat)font height:(CGFloat)height {
    if (string.length == 0) {
        return 0.0f;
    }
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    CGSize realSize = [string boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                           context:nil].size;
    /// 左右各16
    return (realSize.width + 2 * (SCHorizontalMargin + 1.f));
}


#pragma mark -- 拦截webview用户触击了一个链接

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {

            NSString *url = [request.URL absoluteString];
            
            //拦截链接跳转到货源圈的动态详情
            if ([url rangeOfString:@"http"].location != NSNotFound)
            {
                //跳转到你想跳转的页面
                TGWebViewController *webViewVC = [[TGWebViewController alloc] init];
                webViewVC.url = url;
                [NavController1 pushViewController:webViewVC animated:YES];
                
                [self close:self];
                return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
            }
            else{
                if ([url containsString:@"?"]) {
                    
                    NSLog(@"url = %@",url);
                    
                    [CMCommon goVCWithUrl:url];
                    
                    [self close:self];
                    return NO; //返回NO，此页面的链接点击不会继续执行，只会执行跳转到你想跳转的页面
                    
                }
                
            }

            return NO;
        }
        return YES;
}

@end
