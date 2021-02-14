//
//  HomeMarqueeView.m
//  UGBWApp
//
//  Created by fish on 2020/10/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HomeMarqueeView.h"
#import "UUMarqueeView.h"
#import "TKLPlatformNotiveView.h"
#import "UGPlatformNoticeView.h"
#import "PromotePopView.h"

#import "UGNoticeTypeModel.h"

@interface HomeMarqueeView ()<UUMarqueeViewDelegate>
@property (weak, nonatomic) IBOutlet UUMarqueeView *leftwardMarqueeView;            /**<   跑马灯 */
@property (nonatomic, strong) NSMutableArray <NSString *> *leftwardMarqueeViewData; /**<   跑马灯数据 */
@property (nonatomic, strong) UGNoticeTypeModel *noticeTypeModel;                   /**<   点击跑马灯弹出的数据 */

@property (nonatomic, strong) NSMutableArray <UGNoticeModel *> *popNoticeArray;     /**<   弹窗公告数据 */

@property (nonatomic, strong) UGPlatformNoticeView *notiveView;                     /**<   平台公告View */
@property (nonatomic, strong) TKLPlatformNotiveView *tklnotiveView;                  /**<   天空蓝平台公告View */
@end

@implementation HomeMarqueeView

- (void)awakeFromNib {
    [super awakeFromNib];
    _popNoticeArray = @[].mutableCopy;
    _leftwardMarqueeViewData = @[].mutableCopy;
    SANotificationEventSubscribe(UGNotificationWithSkinSuccess, self, ^(typeof (self) self, id obj) {
        if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
            self.backgroundColor = UIColor.whiteColor;
        }
        if (Skin1.isJY||Skin1.isTKL) {
            self.backgroundColor = RGBA(249, 249, 249, 1);
            [CMCommon setBorderWithView:self top:YES left:NO bottom:YES right:NO borderColor:RGBA(241, 241, 241, 1) borderWidth:1];
        }
        if ([Skin1.skitType isEqualToString:@"香槟金"]) {
            self.backgroundColor = UIColor.clearColor;
        }
    });
    SANotificationEventSubscribe(UGNotificationLoginComplete, self, ^(typeof (self) self, id obj) {
        if ([SysConf.popup_type isEqualToString:@"1"] && UGLoginIsAuthorized()) {
            [self reloadData:^(BOOL succ) {}];
        }
    });
    
    FastSubViewCode(self);
    if ([Skin1.skitType isEqualToString:@"香槟金"]) {
        self.backgroundColor = UIColor.clearColor;
        subImageView(@"公告图标ImageView").cc_constraints.left.constant = 15;
        subImageView(@"公告图标ImageView").hidden = true;
        subLabel(@"公告Label").hidden = false;
        subLabel(@"公告Label").textColor = Skin1.menuHeadViewColor;
        subLabel(@"公告Label").layer.shadowColor = [UIColor blackColor].CGColor;
        subLabel(@"公告Label").layer.shadowOffset = CGSizeMake(0, 1);
        subLabel(@"公告Label").layer.shadowRadius = 1.5;
        subLabel(@"公告Label").layer.shadowOpacity = 0.2;
    } else {
        self.backgroundColor = Skin1.homeContentColor;
    }
    
    self.leftwardMarqueeView.direction = UUMarqueeViewDirectionLeftward;
    self.leftwardMarqueeView.delegate = self;
    self.leftwardMarqueeView.timeIntervalPerScroll = 0.5f;
    self.leftwardMarqueeView.scrollSpeed = 60.0f;
    self.leftwardMarqueeView.itemSpacing = 20.0f;
    self.leftwardMarqueeView.touchEnabled = YES;
    
    
}

- (void)start { [self.leftwardMarqueeView start];}
- (void)pause { [self.leftwardMarqueeView pause];}

// 公告
- (void)reloadData:(void (^)(BOOL succ))completion {
    WeakSelf;
    [CMNetwork getNoticeListWithParams:@{} completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UGNoticeTypeModel *type = model.data;
                weakSelf.noticeTypeModel = model.data;
                weakSelf.popNoticeArray = type.popup.mutableCopy;
                for (UGNoticeModel *notice in type.scroll) {
                    //                NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[notice.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    [weakSelf.leftwardMarqueeViewData addObject:notice.title];
                }
                [weakSelf.leftwardMarqueeView reloadData];
   
                if (![type.popupSwitch isEqualToString:@"0"]) {
                    [weakSelf showPlatformNoticeView];
                }
                
                if (completion)
                    completion(true);
            });
        } failure:^(id msg) {
            if (completion)
                completion(false);
        }];
    }];
}


- (void)showPlatformNoticeView {

        WeakSelf;
        //在这里 进行请求后的方法，回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (Skin1.isTKL) {
                CGFloat h = UGScerrnH - APP.StatusBarHeight - APP.BottomSafeHeight - 150-130;
                weakSelf.tklnotiveView = [[TKLPlatformNotiveView alloc] initWithFrame:CGRectMake(25, (UGScerrnH-h)/2, UGScreenW - 50, h)];
                weakSelf.tklnotiveView.dataArray = self.popNoticeArray;
  
                
                UIWindow* window = UIApplication.sharedApplication.keyWindow;
                BOOL isSubView = [weakSelf.notiveView isDescendantOfView:window];
                
                if (!isSubView) {
                    //                SysConf.popup_type = @"1";
                    if ( [SysConf.popup_type isEqualToString:@"0"]) {
                        [weakSelf.tklnotiveView show];
                    } else {
                        BOOL isLogin = UGLoginIsAuthorized();
                        if (isLogin) {
                            [weakSelf.tklnotiveView show];
                        }
                    }
                }
            } else {
                CGFloat h = UGScerrnH - APP.StatusBarHeight - APP.BottomSafeHeight - 150;
                weakSelf.notiveView = [[UGPlatformNoticeView alloc] initWithFrame:CGRectMake(25, (UGScerrnH-h)/2, UGScreenW - 50, h)];
                [weakSelf.notiveView.bgView setBackgroundColor: Skin1.navBarBgColor];
                weakSelf.notiveView.dataArray = self.popNoticeArray;
                weakSelf.notiveView.supVC = weakSelf;
                
                UIWindow* window = UIApplication.sharedApplication.keyWindow;
                BOOL isSubView = [weakSelf.notiveView isDescendantOfView:window];
                
                if (!isSubView) {
                    //                SysConf.popup_type = @"1";
                    if ( [SysConf.popup_type isEqualToString:@"0"]) {
                        [weakSelf.notiveView show];
                    } else {
                        BOOL isLogin = UGLoginIsAuthorized();
                        if (isLogin) {
                            [weakSelf.notiveView show];
                        }
                    }
                }
            }
            
            
        });
}

- (IBAction)showNoticeInfo {
    NSMutableString *str = [[NSMutableString alloc] init];
    for (UGNoticeModel *notice in self.noticeTypeModel.scroll) {
//        [str appendString:@"<center>"];
//        [str appendString:notice.title];
//        [str appendString:@"</center>"];
        [str appendString:notice.content];
        [str appendString:@"<HR SIZE=2>"];
    }
    if (str.length) {
        float y;
        if ([CMCommon isPhoneX]) {
            y = 160;
        } else {
            y = 100;
        }
        PromotePopView *popView = [[PromotePopView alloc] initWithFrame:CGRectMake(40, y, UGScreenW - 80, UGScerrnH - y * 2)];
        [popView setContent:str title:@"公告详情"];
        [popView show];
    }
}


#pragma mark - UUMarqueeViewDelegate

- (NSUInteger)numberOfVisibleItemsForMarqueeView:(UUMarqueeView *)marqueeView {
    return 1;
}

- (NSUInteger)numberOfDataForMarqueeView:(UUMarqueeView *)marqueeView {
    return self.leftwardMarqueeViewData.count;
}

- (void)createItemView:(UIView *)itemView forMarqueeView:(UUMarqueeView *)marqueeView {
    itemView.backgroundColor = [UIColor clearColor];
    
    UILabel *content = [[UILabel alloc] initWithFrame:itemView.bounds];
    content.font = [UIFont systemFontOfSize:14.0f];
    content.tag = 1001;
    [itemView addSubview:content];
}

- (void)updateItemView:(UIView *)itemView atIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView *)marqueeView {
    UILabel *content = [itemView viewWithTag:1001];
    
    if ([APP.SiteId isEqualToString:@"c115"]) {
        content.textColor = [UIColor redColor];
    }
    else{
        if ([Skin1.skitType isEqualToString:@"香槟金"]) {
            content.textColor = [UIColor whiteColor];
        } else {
            content.textColor = Skin1.textColor1;
        }
       
    }
    
    content.text = self.leftwardMarqueeViewData[index];
}

- (CGFloat)itemViewWidthAtIndex:(NSUInteger)index forMarqueeView:(UUMarqueeView*)marqueeView {
    // for leftwardMarqueeView
    UILabel *content = [[UILabel alloc] init];
    content.text = self.leftwardMarqueeViewData[index];
    return content.intrinsicContentSize.width;  // icon width + label width (it's perfect to cache them all)
}

@end
