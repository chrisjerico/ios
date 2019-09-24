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
#define SCHorizontalMargin   5.0f
#define SCVerticalMargin     5.0f
@interface UGActivityGoldView ()<UICollectionViewDelegate, UICollectionViewDataSource,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *okView;
@property (weak, nonatomic) IBOutlet UIView *closeView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *my1TextField;
@property (weak, nonatomic) IBOutlet UITextField *my2TextField;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UIImageView *validationImageView;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;


@property (strong, nonatomic) NSMutableArray *quickAmountArray;



@property (nonatomic, assign) NSInteger selectSection;

@end
@implementation UGActivityGoldView
@synthesize item;
//移除观察者

-(void)dealloc

{
    
    [self.contentWebView removeObserver:self forKeyPath:@"scrollView.contentSize" context:@"DJWebKitContext"];

    
}
#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"UGActivityGoldView" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        //初始化子视图
        [self initSubview];
        
        //初始化数据
        
        [self initData];
        
    }
    return self;
}

#pragma mark - 初始化数据


-(void)setDateUI{
    
    if (self.item) {
        _quickAmountArray = [NSMutableArray new];
        for (int i = 1 ; i<=12; i++) {
            NSString *str = [self.item valueForKey: [NSString stringWithFormat:@"quickAmount%d",i]];
            if (![CMCommon stringIsNull:str]) {
                
                float floatStr = [str floatValue];
                if (floatStr>0) {
                    [_quickAmountArray addObject:str];
                }
                
            }
        }
        
        NSLog(@"self.item.win_apply_content = %@",self.item.win_apply_content);
        
        
     
            // 需要在主线程执行的代码
            NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",self.size.width - 10,self.item.win_apply_content];
            [self.contentWebView loadHTMLString:str baseURL:nil];
            //监听webview
//            [self.contentWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.contentWebView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"DJWebKitContext"];
   
    }
}

#pragma mark - 初始化数据

- (void)initData{
    
    [self getImgVcode];
}
- (IBAction)imageButtonClicked:(id)sender {
     [self getImgVcode];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    self.layer.cornerRadius=5; 
    self.layer.masksToBounds = YES;

    
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(15.0);
        make.height.mas_equalTo(21.0);
    }];
    
    [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(44.0);
        make.width.mas_equalTo(self.size.width/2);
    }];
    
    [self.okView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(44.0);
        make.width.mas_equalTo(self.size.width/2);
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.okView);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(100);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.closeView);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(100);
    }];
    

    self.closeButton.layer.cornerRadius=5; 
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.borderWidth =1; 
    self.closeButton.layer.borderColor =  [UIColor blackColor].CGColor;
    self.okButton.layer.cornerRadius = 5; 
    self.okButton.layer.masksToBounds = YES;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);

    // UIScrollView 对四边left top bottom right 进行约束，值均为0，作为view 的子视图存在
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(44.0);
        make.bottom.equalTo(self.mas_bottom).offset(-44.0);
    }];
    

    
    //  标题
    [self.title1Label  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.mas_left).with.offset(10);
         make.right.equalTo(self.mas_right).with.offset(-10);
         make.height.mas_equalTo(21.0);
         make.top.mas_equalTo(10);
         
     }];
    
    [self.contentWebView setFrame:CGRectZero];
    self.contentWebView.delegate = self;
    self.contentWebView.scalesPageToFit = YES;
    self.contentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentWebView.scrollView.scrollEnabled = NO;
    //这个属性不加,webview会显示很大.
    self.contentWebView.delegate = self;
    
    self.contentWebView.scrollView.delegate = self;
    
    //-滚动面版======================================
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1; // 竖
    layout.minimumInteritemSpacing = 1; // 横
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"UGContentMoneyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGContentMoneyCollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [_myTextView setPlaceholderWithText:@"申请说明" Color:UGRGBColor(205, 205, 209)];
    _myTextView.layer.cornerRadius=5; 
    _myTextView.layer.masksToBounds=YES;
    _myTextView.layer.borderWidth=1;
    _myTextView.layer.borderColor =  UGRGBColor(239, 239, 239).CGColor;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    float htmlheight = [[self.contentWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];

    NSLog(@"htmlheight = %f",htmlheight);
    
    [self setUI:htmlheight];
}


-(void)setUI :(CGFloat ) webHeight{
    
#pragma mark - 设置自动布局
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        float  collectionViewHeight = 0.0 ;
        
        [self.contentWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(38);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.height.mas_equalTo(webHeight);
        }];
//            make.top.mas_equalTo(38);
        if (self.item.showWinAmount) {
            
            [self.title2Label  mas_remakeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(self.mas_left).with.offset(10);
                 make.right.equalTo(self.mas_right).with.offset(-10);
                 make.top.equalTo(self.contentWebView.mas_bottom).offset(0.0);
                 make.height.mas_equalTo(21.0);
             }];
            
            float  collectionViewHeight =  self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            
            [self.collectionView setHidden:NO];
            
            [self.collectionView  mas_remakeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(self.mas_left).with.offset(10);
                 make.right.equalTo(self.mas_right).with.offset(-10);
                 make.height.mas_equalTo(collectionViewHeight);
                 make.top.equalTo(self.title2Label.mas_bottom).offset(0);
                 
             }];
            [self.my1TextField setHidden:NO];
            [self.my1TextField  mas_remakeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(self.mas_left).with.offset(10);
                 make.right.equalTo(self.mas_right).with.offset(-10);
                 make.top.equalTo(self.collectionView.mas_bottom).offset(5.0);
                 make.height.mas_equalTo(30.0);
                 
             }];
            
            [self.myTextView setHidden:NO];
            [self.myTextView  mas_remakeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(self.mas_left).with.offset(10);
                 make.right.equalTo(self.mas_right).with.offset(-10);
                 make.top.equalTo(self.my1TextField.mas_bottom).offset(5.0);
                 make.height.mas_equalTo(100.0);
                 
             }];
        }
        else{
            
            [self.title2Label setHidden:YES];
            [self.collectionView setHidden:YES];
            [self.my1TextField setHidden:YES];
            
            [self.myTextView setHidden:NO];
            [self.myTextView  mas_remakeConstraints:^(MASConstraintMaker *make)
             {
                 make.left.equalTo(self.mas_left).with.offset(10);
                 make.right.equalTo(self.mas_right).with.offset(-10);
                 make.top.equalTo(self.contentWebView.mas_bottom).offset(5.0);
                 make.height.mas_equalTo(100.0);
                 
             }];
        }
    
         [self.my2TextField setHidden:NO];
        [self.my2TextField  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.mas_left).with.offset(10);
             
             make.top.equalTo(self.myTextView.mas_bottom).offset(5.0);
             make.height.mas_equalTo(30.0);
             make.width.mas_equalTo(self.size.width*2/3);
         }];
        
        [self.validationImageView  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.my2TextField.mas_right).with.offset(-40);
             
             make.top.equalTo(self.myTextView.mas_bottom).offset(5.0);
             make.height.mas_equalTo(30.0);
             make.width.mas_equalTo(self.size.width*1/3+40);
         }];
        
        [self.imageButton  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.my2TextField.mas_right).with.offset(-40);
             
             make.top.equalTo(self.myTextView.mas_bottom).offset(5.0);
             make.height.mas_equalTo(30.0);
             make.width.mas_equalTo(self.size.width*1/3+40);
         }];
        
        
        if (self.item.showWinAmount) {
            self->_myScrollView.contentSize = CGSizeMake(self.frame.size.width,290+collectionViewHeight+webHeight);
        }
        else{
            self->_myScrollView.contentSize = CGSizeMake(self.frame.size.width,270+webHeight);
        }
        
        
    });
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   
    
    if (!self.contentWebView.isLoading) {
        if([keyPath isEqualToString:@"scrollView.contentSize"]){
            
            CGPoint point = [change[@"new"] CGPointValue];
        
            CGFloat height = point.y;
            NSLog(@"point.y---%f",height);
        
            CGSize fittingSize = [self.contentWebView sizeThatFits:CGSizeZero];
        
            CGFloat webHeight = fittingSize.height;
        
        
            [self setUI:webHeight];
        }
    }
  
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
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
    NSString *nuberStr = [_quickAmountArray objectAtIndex:indexPath.row];
    self.my1TextField.text = nuberStr;
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


#pragma mark - 其他方法
- (IBAction)close:(id)sender {
    [self hiddenSelf];
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

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}
- (IBAction)okButtonClicked:(id)sender {
    [self activityApplyWinWithParams];
}
#pragma mark - 网络请求
- (void)getImgVcode{
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"accessToken":[OpenUDID value]
                             };
    
    [CMNetwork getImgVcodeWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        if (!err) {
            NSData *data = (NSData *)model;
            NSString *imageStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            imageStr = [imageStr substringFromIndex:22];
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            self.validationImageView.image = decodedImage;
        }else {
            
        }
        
    }];
}

//得到领取连续签到奖励数据
- (void)activityApplyWinWithParams {
    
    if ([CMCommon stringIsNull:_my1TextField.text]) {
       
        [self makeToast:@"申请金额不能为空"];
        
        return;
    }
    if ([CMCommon stringIsNull:_myTextView.text]) {
        
        [self makeToast:@"申请说明不能为空"];
        
        return;
    }
    if ([CMCommon stringIsNull:_my2TextField.text]) {
        
        [self makeToast:@"验证码不能为空"];
        
        return;
    }
    
    NSString *pid = self.item.mid;
     NSString *amount = [_my1TextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     NSString *userComment = [_myTextView.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     NSString *imgCode = [_my2TextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"id":pid,
                              @"amount":amount,
                              @"userComment":userComment,
                              @"imgCode":imgCode
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork activityApplyWinWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
              dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [SVProgressHUD showSuccessWithStatus:model.msg];
                  [self hiddenSelf];
            });
          
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}
@end
