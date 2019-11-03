//
//  UGSkinViewController.m
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGSkinViewController.h"
#import "UGSkinCollectionViewCell.h"
#import "UIImage+YYgradientImage.h"
#import "UGSkinManagers.h"


@interface UGSkinViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

//@property (nonatomic, strong) UIScrollView *mUIScrollView;
@property (nonatomic, strong) UICollectionView *collectionView ;
@property (nonatomic, strong) NSMutableArray<UIColor *> *colorDataArray;
@property (nonatomic, strong)UILabel *tiplabel;

@property (nonatomic, strong)UIButton *default_button;
@property (nonatomic, strong)UIButton *simple_button;

@property (nonatomic, strong)UIButton *seret_button;
@end

@implementation UGSkinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.view setBackgroundColor:[UIColor whiteColor]];
    _colorDataArray = [NSMutableArray new];
    
//        UIColor *color1 = kUIColorFromRGB(0x609AC5);
//        UIColor *color2 = kUIColorFromRGB(0x609AC5);
//        UIColor *color3 = kUIColorFromRGB(0x7E503C);
//        UIColor *color4 = RGBA(108, 169, 159, 1);
//
//        UIColor *color5 = RGBA(226,78, 122, 1);
//        UIColor *color6 = RGBA(227, 84, 79, 1);
//        UIColor *color7 = RGBA(197, 52, 61, 1);
//        UIColor *color8 = RGBA(238, 146, 69, 1);
//
//        UIColor *color9 = RGBA(225,85, 79, 1);
//        UIColor *color10 = RGBA(227, 81, 79, 1);
//        UIColor *color11 = RGBA(261, 235, 96, 1);
//        UIColor *color12 = RGBA(245, 195, 68, 1);
//
//        UIColor *color13 = RGBA(234,99, 55, 1);
//        UIColor *color14 = RGBA(236, 120, 809, 1);
//        UIColor *color15 = RGBA(242, 174, 150, 1);
//        UIColor *color16 = RGBA(222, 82, 65, 1);
//
//        UIColor *color17 =RGBA(125,218, 195, 1);
//        UIColor *color18 =RGBA(91, 166, 224, 1);
//        UIColor *color19 =RGBA(103, 191, 204, 1);
//        UIColor *color20 =RGBA(46, 65, 169, 1);
    
    UIColor *color1 = RGBA(114, 204, 250, 1);
    UIColor *color2 = RGBA(145, 131, 247, 1);
    UIColor *color3 = RGBA(121, 185, 126, 1);
    UIColor *color4 = RGBA(108, 169, 159, 1);

    UIColor *color5 = RGBA(226,78, 122, 1);
    UIColor *color6 = RGBA(227, 84, 79, 1);
    UIColor *color7 = RGBA(197, 52, 61, 1);
    UIColor *color8 = RGBA(238, 146, 69, 1);

    UIColor *color9 = RGBA(225,85, 79, 1);
    UIColor *color10 = RGBA(227, 81, 79, 1);
    UIColor *color11 = RGBA(261, 235, 96, 1);
    UIColor *color12 = RGBA(245, 195, 68, 1);

    UIColor *color13 = RGBA(234,99, 55, 1);
    UIColor *color14 = RGBA(236, 120, 809, 1);
    UIColor *color15 = RGBA(242, 174, 150, 1);
    UIColor *color16 = RGBA(222, 82, 65, 1);

    UIColor *color17 =RGBA(125,218, 195, 1);
    UIColor *color18 =RGBA(91, 166, 224, 1);
    UIColor *color19 =RGBA(103, 191, 204, 1);
    UIColor *color20 =RGBA(46, 65, 169, 1);
    
    [_colorDataArray addObject:color1];
    [_colorDataArray addObject:color2];
    [_colorDataArray addObject:color3];
    [_colorDataArray addObject:color4];
    [_colorDataArray addObject:color5];
    [_colorDataArray addObject:color6];
    [_colorDataArray addObject:color7];
    [_colorDataArray addObject:color8];
    [_colorDataArray addObject:color9];
    [_colorDataArray addObject:color10];
    [_colorDataArray addObject:color11];
    [_colorDataArray addObject:color12];
    [_colorDataArray addObject:color13];
    [_colorDataArray addObject:color14];
    [_colorDataArray addObject:color15];
    [_colorDataArray addObject:color16];
    [_colorDataArray addObject:color17];
    [_colorDataArray addObject:color18];
    [_colorDataArray addObject:color19];
    [_colorDataArray addObject:color20];
    
    [self initUICollectionView];
    
    float height =   self.collectionView.collectionViewLayout.collectionViewContentSize.height;

    UIImage *backImage = [UIImage gradientImageWithBounds:CGRectMake(0, 0, UGScreenW ,UGScerrnH) andColors:@[kUIColorFromRGB(0x7E9296) ,kUIColorFromRGB(0x5184B1)] andGradientType:GradientDirectionLeftToRight];
    
    UIColor *bgColor = [UIColor colorWithPatternImage:backImage];
    [self.view setBackgroundColor:bgColor];
    
}

-(void)initUICollectionView{
    
    if (self.collectionView==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((self.view.frame.size.width-15-40) / 3, 35);
        layout.minimumLineSpacing = 5.0; // 竖
        layout.minimumInteritemSpacing = 5.0; // 横
        layout.sectionInset = UIEdgeInsetsMake(5, 20, 5, 20);
        
        UICollectionView *collectionView = ({
            
            collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 20, UGScreenW  , 300) collectionViewLayout:layout];
//            collectionView.backgroundColor = [UIColor whiteColor];
//            collectionView.backgroundColor = [UIColor redColor];
            
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [collectionView registerNib:[UINib nibWithNibName:@"UGSkinCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UGSkinCollectionViewCell"];
            
            collectionView;
            
        });
//        [self.mUIScrollView addSubview:collectionView ];
        self.collectionView = collectionView;
        [self.view addSubview:collectionView];
    }
    
    if (self.tiplabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 100, 25)];
        label.textAlignment = NSTextAlignmentLeft;
        //        label.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        label.numberOfLines = 1;
        label.text = @"切换模板";
        [self.view addSubview:label];
        
        [self.view addSubview:label ];
        self.tiplabel = label;
    }
    
    if (self.default_button == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 325, 80, 35);
        // 按钮的正常状态
        [button setTitle:@"默认版" forState:UIControlStateNormal];
        // 设置按钮的背景色
        button.backgroundColor = RGBA(114, 204, 250, 1);
        
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置按下状态文字的颜色
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // 设置按钮的风格颜色,只有titleColor没有设置的时候才有用
        [button setTintColor:[UIColor whiteColor]];
        
        // titleLabel：UILabel控件
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button addTarget:self action:@selector(default_buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *layer= button.layer;
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:5];
        
        [self.view addSubview:button ];
        self.default_button = button;
    }
    
    if (self.simple_button == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(UGScreenW-100, 325, 80, 35);
        // 按钮的正常状态
        [button setTitle:@"简洁版" forState:UIControlStateNormal];
        // 设置按钮的背景色
        button.backgroundColor = RGBA(121, 185, 126, 1);
        
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置按下状态文字的颜色
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // 设置按钮的风格颜色,只有titleColor没有设置的时候才有用
        [button setTintColor:[UIColor whiteColor]];
        
        // titleLabel：UILabel控件
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button addTarget:self action:@selector(simple_buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *layer= button.layer;
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:5];
        
        [self.view addSubview:button ];
        self.simple_button = button;
    }
    
    if (self.seret_button == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 380, UGScreenW -40, 35);
        // 按钮的正常状态
        [button setTitle:@"重置" forState:UIControlStateNormal];
        // 设置按钮的背景色
        button.backgroundColor = RGBA(114, 204, 250, 1);
        
        // 设置正常状态下按钮文字的颜色，如果不写其他状态，默认都是用这个文字的颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // 设置按下状态文字的颜色
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // 设置按钮的风格颜色,只有titleColor没有设置的时候才有用
        [button setTintColor:[UIColor whiteColor]];
        
        // titleLabel：UILabel控件
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button addTarget:self action:@selector(seret_buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        CALayer *layer= button.layer;
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:5];
        
        [self.view addSubview:button ];
        self.simple_button = button;
    }
}



#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _colorDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UGSkinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UGSkinCollectionViewCell" forIndexPath:indexPath];
    UIColor *selColor  = (UIColor *)[_colorDataArray objectAtIndex:indexPath.row];
    
    [cell.myLabel setBackgroundColor:selColor];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem", indexPath.section, indexPath.row);
    UIColor *selColor  = (UIColor *) [_colorDataArray objectAtIndex:indexPath.row];
    
    // 设置按钮的背景色
    _default_button.backgroundColor = selColor;
    // 设置按钮的背景色
    _simple_button.backgroundColor = selColor;
    // 设置按钮的背景色
    _seret_button.backgroundColor = selColor;
    
//  [self.navigationController.navigationBar navBarBackGroundColor:selColor image:nil isOpaque:YES];//颜色
//    [[UITabBar appearance] setBackgroundImage:[CMCommon imageWithColor:selColor]];
    
    NSString * str = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
//    [[UGSkinManagers shareInstance] resetNavbarAndTabBarBgColor:str];
//    
//     SANotificationEventPost(UGNotificationWithSkinSuccess, nil);

}

#pragma mark -其他方法
-(void)default_buttonAction{
    
}

-(void)simple_buttonAction{
    
}

-(void)seret_buttonAction{
    
}

@end
