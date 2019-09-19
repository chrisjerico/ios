//
//  UGMosaicGoldFinishView.m
//  ug
//
//  Created by ug on 2019/9/18.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGMosaicGoldFinishView.h"
#import "UITextView+Extension.h"
#import "UGMosaicGoldModel.h"

@interface UGMosaicGoldFinishView ()

@property (nonatomic, strong) UIScrollView *mUIScrollView;

@property (nonatomic , strong ) UILabel *nameLabel; // 活动内容

@property (nonatomic , strong ) UILabel *contentLabel; //内容

//按钮数组

@property (nonatomic , strong ) UILabel *buttonsTitleLabel; // 按钮数组标题

@property (nonatomic , strong ) UITextField *textField1; //

@property (nonatomic , strong ) UITextField *textField2; //

@property (nonatomic , strong ) UITextView *textView; //

@end
@implementation UGMosaicGoldFinishView

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
   
        
        //初始化子视图
        [self initSubview];
        
        //初始化数据
        
        [self initData];
        
    }
    return self;
}
#pragma mark - 初始化数据
- (void)setItem:(UGMosaicGoldParamModel *)item {
    //初始化子视图
    [self initSubview];
    
    _item = item;
 
    NSString *str = [NSString stringWithFormat:@"<head><style>img{width:%f !important;height:auto}</style></head>%@",UGScreenW - 10,self.item.win_apply_content];
    NSAttributedString *__block attStr = [[NSAttributedString alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        attStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
            [self configAutoLayout:attStr];
            
        });
    });
}

#pragma mark - 初始化数据

- (void)initData{
    
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //-滚动面版======================================
    if (_mUIScrollView == nil) {
        UIScrollView *mUIScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        mUIScrollView.showsHorizontalScrollIndicator = YES;//不显示水平拖地的条
        mUIScrollView.showsVerticalScrollIndicator=YES;//不显示垂直拖动的条
        mUIScrollView.bounces = NO;//到边了就不能再拖地
        //UIScrollView被push之后返回，会发生控件位置偏移，用下面的代码就OK
        //        self.automaticallyAdjustsScrollViewInsets = NO;
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        mUIScrollView.backgroundColor = UGRGBColor(239, 239, 244);
        mUIScrollView.contentInset = UIEdgeInsetsMake(5, 0, 120, 0);
        [self addSubview:mUIScrollView];
        self.mUIScrollView = mUIScrollView;
    }
    // 分数
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _nameLabel.text = @"+5";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self.mUIScrollView addSubview:_nameLabel];
        _nameLabel.backgroundColor = [UIColor redColor];
    }
    
  
    
    // 内容
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.mUIScrollView addSubview:_contentLabel];
         _contentLabel.backgroundColor = [UIColor yellowColor];
    }

    
    // 按钮
    if (!_buttonsTitleLabel) {
        _buttonsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _buttonsTitleLabel.text = @"按钮：";
        _buttonsTitleLabel.textColor = [UIColor blackColor];
        _buttonsTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        _buttonsTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.mUIScrollView addSubview:_buttonsTitleLabel];
        [self.buttonsTitleLabel setHidden:YES];
          _buttonsTitleLabel.backgroundColor = [UIColor blueColor];
    }
   
    
    //
    if (!_textField1) {
        _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _textField1.placeholder = @"请输入存款金额";
        _textField1.textColor = [UIColor blackColor];
        _textField1.font = [UIFont systemFontOfSize:14];
        _textField1.textAlignment = NSTextAlignmentLeft;
        _textField1.clearButtonMode = UITextFieldViewModeUnlessEditing;
        _textField1.borderStyle = UITextBorderStyleRoundedRect;
        [self.mUIScrollView addSubview:_textField1];
         _textField1.backgroundColor = [UIColor grayColor];
    }
  
    
    //
    if (!_textField2) {
        _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _textField2.placeholder = @"请输入存款金额======";
        _textField2.textColor = [UIColor blackColor];
        _textField2.font = [UIFont systemFontOfSize:14];
        _textField2.textAlignment = NSTextAlignmentLeft;
        _textField2.clearButtonMode = UITextFieldViewModeUnlessEditing;
        _textField2.borderStyle = UITextBorderStyleRoundedRect;
        [self.mUIScrollView addSubview:_textField2];
        _textField2.backgroundColor = [UIColor greenColor];
    }
    
    
    //
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_textView setPlaceholderWithText:@"234234234" Color:[UIColor grayColor] ];
        _textView.textColor = [UIColor blackColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textAlignment = NSTextAlignmentLeft;
        [self.mUIScrollView addSubview:_textView];
        _textView.backgroundColor = [UIColor orangeColor];
    }
  
}


#pragma mark - 设置自动布局

- (void)configAutoLayout:(NSAttributedString *) string{
    
    // name
    [self.nameLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.mas_left).with.offset(0);
         make.right.equalTo(self.mas_right).with.offset(0);
         make.height.mas_equalTo(26.0);
         make.top.equalTo(self.mas_top).offset(20.0);
         
     }];
  
    
    // 分数
    
    [self.contentLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.mas_left).with.offset(0);
         make.right.equalTo(self.mas_right).with.offset(0);
         make.top.equalTo(self.nameLabel.mas_bottom).offset(5.0);
         
     }];
     self.contentLabel.attributedText = string;
    [self.contentLabel sizeToFit];
    NSLog(@"%@",NSStringFromCGRect(self.contentLabel.frame));    // 天数
    
   
    
    
    if (self.item.showWinAmount) {
        [self.buttonsTitleLabel setHidden:NO];
        // 描述
        [self.buttonsTitleLabel  mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.mas_left).with.offset(0);
             make.height.mas_equalTo(26.0);
             make.width.mas_equalTo(50.0);
             make.top.equalTo(self.contentLabel.mas_bottom).offset(5.0);
             
         }];
        
        NSMutableArray *quickAmountArray = [NSMutableArray new];
        for (int i = 1 ; i<=12; i++) {
           NSString *str = [self.item valueForKey: [NSString stringWithFormat:@"quickAmount%d",i]];
            if (![CMCommon stringIsNull:str]) {
                [quickAmountArray addObject:str];
            }
        }
        
        
        
        
        NSInteger beginX = 55.0;
        NSInteger beginY = CGRectGetMaxY(_buttonsTitleLabel.frame)+8;
        float buttonSpaceX = 5.0;
        for (int i = 0; i< quickAmountArray.count; i++) {  //已经选择的标签
          UIButton *button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
            // 按钮的正常状态
            [button setTitle:[quickAmountArray objectAtIndex:i] forState:UIControlStateNormal];
            // 设置按钮的背景色
            button.backgroundColor = [UIColor blueColor];
            // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            // titleLabel：UILabel控件
            button.titleLabel.font = [UIFont systemFontOfSize:9];
            [button addTarget:self action:@selector(buttonClock:) forControlEvents:UIControlEventTouchUpInside];
            
            CALayer *layer= button.layer;
            //是否设置边框以及是否可见
            [layer setMasksToBounds:YES];
            //设置边框圆角的弧度
            [layer setCornerRadius:3];
            
            button.tag = i;
           
            CGRect frame = button.frame;
            frame.size.width = [CMCommon getLabelWidthWithText:[quickAmountArray objectAtIndex:i] stringFont:[UIFont systemFontOfSize:9.0] allowHeight:15] + 20;
            frame.origin.x = beginX;
            frame.origin.y = beginY;
            frame.size.height = 15.0;
            
            button.frame = frame;
            
            
            if (beginX+CGRectGetWidth(button.frame)+buttonSpaceX>=CGRectGetMaxX(self.frame)-buttonSpaceX) {
                beginY = buttonSpaceX +15+CGRectGetMaxY(_buttonsTitleLabel.frame)+8;
                
                beginX = 55.0;
                
                button.frame = frame;
            }
            else{
                 beginX = buttonSpaceX + CGRectGetMaxX(button.frame);
            }
           
      
          
            [self addSubview:button];
        }
    }
    //
    
     if (self.item.showWinAmount) {
         
         [self.textField1  mas_remakeConstraints:^(MASConstraintMaker *make)
          {
              make.left.equalTo(self.mas_left).with.offset(0);
              make.right.equalTo(self.mas_right).with.offset(0);
              make.top.equalTo(self.buttonsTitleLabel.mas_bottom).offset(5.0);
              make.height.mas_equalTo(40.0);
              
          }];
     }
     else{
         [self.textField1  mas_remakeConstraints:^(MASConstraintMaker *make)
          {
              make.left.equalTo(self.mas_left).with.offset(0);
              make.right.equalTo(self.mas_right).with.offset(0);
              make.top.equalTo(self.contentLabel.mas_bottom).offset(5.0);
              make.height.mas_equalTo(40.0);
              
          }];
     }

    //
    [self.textField2  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.mas_left).with.offset(0);
         make.right.equalTo(self.mas_right).with.offset(0);
         make.top.equalTo(self.textField1.mas_bottom).offset(5.0);
         make.height.mas_equalTo(40.0);
         
     }];
    //
    [self.textView  mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.mas_left).with.offset(0);
         make.right.equalTo(self.mas_right).with.offset(0);
         make.top.equalTo(self.textField2.mas_bottom).offset(5.0);
         make.height.mas_equalTo(60.0);
         
     }];
    
    //======
    if (self.item.showWinAmount) {
        _mUIScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentLabel.frame), CGRectGetHeight(_buttonsTitleLabel.frame)+CGRectGetHeight(self.nameLabel.frame)+CGRectGetHeight(self.contentLabel.frame)+CGRectGetHeight(self.buttonsTitleLabel.frame)+CGRectGetHeight(self.textField1.frame)+CGRectGetHeight(self.textField2.frame)+CGRectGetHeight(self.textView.frame)+30);
        
    }
    else{
        _mUIScrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetHeight(_buttonsTitleLabel.frame)+CGRectGetHeight(self.nameLabel.frame)+CGRectGetHeight(self.contentLabel.frame)+CGRectGetHeight(self.textField1.frame)+CGRectGetHeight(self.textField2.frame)+CGRectGetHeight(self.textView.frame)+30);
        
    }
    
   
}


-(void)buttonClock:(UIButton *)sender{
    
}
#pragma mark - 打开按钮点击事件

- (void)openButtonAction:(UIButton *)sender{
    
    [LEEAlert closeWithCompletionBlock:^{
        
        // 打开XXX
        
    }];
    
}

#pragma mark - 关闭按钮点击事件

- (void)closeButtonAction:(UIButton *)sender{
    
    if (self.closeBlock) self.closeBlock();
}

@end
