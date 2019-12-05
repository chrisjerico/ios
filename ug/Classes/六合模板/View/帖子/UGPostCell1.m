//
//  UGPostCell1.m
//  ug
//
//  Created by fish on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPostCell1.h"
#import "MediaViewer.h"
#import "YYAnimatedImageView.h"
#import "YYText.h"

#define ActionPhotoWidth _CalWidth(82)
#define ActionPhotoMaxWidth _CalWidth(170)
#define ActionPhotoMinWidth _CalWidth(50)

@interface UGPostCell1 ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end


@implementation UGPostCell1

#pragma mark - 计算高度

+ (CGFloat)heightWithModel:(UGLHPostModel *)pm {
    CGFloat textH = ({
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:pm.content ? : @"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        string.lineSpacing = 6;
        textH = [string boundingRectWithSize:CGSizeMake(APP.Width-11-12, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil].size.height;
        textH + 20;
    });
    CGFloat collectionViewH = [UGPostCell1 collectionViewSizeWithModel:pm].height;
    CGFloat h = 125 + textH + 10 + collectionViewH + 70;
    return h;
}

+ (CGSize)collectionViewSizeWithModel:(UGLHPostModel *)pm {
    NSInteger count = pm.contentPic.count;
    if (count == 0)
        return CGSizeZero;
    
    CGSize size = CGSizeZero;
    if (count == 1)
        size = [self itemSizeWithModel:pm];
    
    else {
        CGFloat itemW = ActionPhotoWidth;

        // 单行
        if (count < 4) {
            CGFloat h = itemW;
            CGFloat w = h * count + 5 * (count - 1);
            size = CGSizeMake(w, h);
        }
        // 2行 - 正方形
        else if (count == 4) {
            CGFloat h = itemW * 2 + 5;
            CGFloat w = h;
            size = CGSizeMake(w, h);
        }
        // 2行
        else if (count < 7) {
            size = CGSizeMake(itemW * 3 + 10, itemW * 2 + 5);
        }
        // 3行
        else {
            CGFloat w = itemW * 3 + 10;
            CGFloat h = w;
            size = CGSizeMake(w, h);
        }
    }
    return size;
}

+ (CGSize)itemSizeWithModel:(UGLHPostModel *)pm {
    NSInteger photoCnt = pm.contentPic.count;
    if (photoCnt == 0)
        return CGSizeZero;
    
    CGSize size = CGSizeZero;
    if (photoCnt==1) {
        CGFloat max = ActionPhotoMaxWidth;
        CGFloat min = ActionPhotoMinWidth;
        
        if (pm.width <= 0 || pm.height <= 0) {
            size = CGSizeMake(max, max);
        }
        else if (pm.width > pm.height) {
            size = CGSizeMake(max, MAX((max/pm.width * pm.height), min));
        } else {
            size = CGSizeMake(MAX((max/pm.height * pm.width), min), max);
        }
    } else {
        CGFloat w = ActionPhotoWidth;
        size = CGSizeMake(w, w);
    }
    return size;
}


#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;

}

- (void)setPm:(UGLHPostModel *)pm {
    _pm = pm;
    FastSubViewCode(self);
    
    // 动态信息
    {
        [subImageView(@"头像ImageView") sd_setImageWithURL:[NSURL URLWithString:pm.headImg]];
        subImageView(@"精品ImageView").hidden = !pm.isHot;
        subImageView(@"置顶ImageView").hidden = !pm.isTop;
        subLabel(@"期数Label").text = pm.periods;
        subLabel(@"昵称Label").text = pm.nickname;
        subLabel(@"时间Label").text = pm.createTime;
        subLabel(@"标题Label").text = pm.title;
        UILabel *contentLabel = subLabel(@"内容Label");
        contentLabel.attributedText = ({
            UIFont *font = [UIFont systemFontOfSize:16];
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:pm.content attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:APP.TextColor1}];
            for (YYImage *image in UGLHPostModel.allEmoji) {
                NSString *key = [UGLHPostModel keyWithImage:image];
                if ([pm.content containsString:key]) {
                    NSRange range = NSMakeRange(0, mas.length);
                    NSRange r;
                    while ((r = [mas.string rangeOfString:key options:NSLiteralSearch range:range]).length) {
                        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
                        NSAttributedString *attachText = [NSAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                        [mas replaceCharactersInRange:r withAttributedString:attachText];
                        range.location = r.location + attachText.length;
                        range.length = mas.length - range.location;
                    }
                }
            }
            NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
            ps.lineSpacing = 6;
            ps.lineBreakMode = NSLineBreakByCharWrapping;
            ps.alignment = NSTextAlignmentCenter;
            [mas addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, mas.string.length)];
            mas;
        });
        contentLabel.cc_constraints.height.constant =  [YYTextLayout layoutWithContainerSize:CGSizeMake(APP.Width-50, MAXFLOAT) text:contentLabel.attributedText].textBoundingSize.height;
    }
    
    // 点赞、浏览、评论
    {
        [subButton(@"评论Button") setTitle:pm.replyCount ? @(pm.replyCount).stringValue : @"" forState:UIControlStateNormal];
        [subButton(@"浏览Button") setTitle:pm.viewNum ? @(pm.viewNum).stringValue : @"" forState:UIControlStateNormal];
        [subButton(@"点赞Button") setTitle:pm.likeNum ? @(pm.likeNum).stringValue : @"" forState:UIControlStateNormal];
        subButton(@"点赞Button").selected = pm.isLike;
    }
    
    // 图片
    {
        CGFloat collectionViewW = [UGPostCell1 collectionViewSizeWithModel:pm].width;
        CGFloat collectionViewH = [UGPostCell1 collectionViewSizeWithModel:pm].height;
        _collectionView.hidden = !pm || !pm.contentPic.count;
        _collectionView.cc_constraints.width.constant = collectionViewW + 4;
        _collectionView.cc_constraints.height.constant = collectionViewH + 4;
        ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize = [UGPostCell1 itemSizeWithModel:_pm];
        [_collectionView reloadData];
    }
}


#pragma mark - IBAction

// 点赞
- (IBAction)onLikeBtnClick:(UIButton *)sender {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return ;
    }
    __weakSelf_(__self);
    BOOL like = !sender.selected;
    [NetworkManager1 lhcdoc_likePost:_pm.cid type:1 likeFlag:like].completionBlock = ^(CCSessionModel *sObj) {
        UGLHPostModel *pm = __self.pm;
        BOOL ok = false;
        if (!sObj.error) {
            pm.likeNum += like ? 1 : -1;
            pm.isLike = like;
            ok = true;
        } else if (sObj.error.code == -2) { // 已点赞
            sObj.noShowErrorHUD = true;
            pm.isLike = like;
            ok = true;
        }
        if (ok) {
            FastSubViewCode(__self);
            [subButton(@"点赞Button") setTitle:pm.likeNum ? @(pm.likeNum).stringValue : @"" forState:UIControlStateNormal];
//            [subButton(@"点赞Button") setTitleColor:pm.isLike ? Skin1.navBarBgColor : Skin1.textColor2 forState:UIControlStateNormal];
            subButton(@"点赞Button").selected = pm.isLike;
        }
    };
}

// 点击评论
- (IBAction)onReplyBtnClick:(UIButton *)sender {
    if (_didCommentBtnClick)
        _didCommentBtnClick(_pm);
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(_pm.contentPic.count, 9);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [(UIImageView *)[cell viewWithTagString:@"图片ImageView"] sd_setImageWithURL:[NSURL URLWithString:_pm.contentPic[indexPath.item]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imgView = [[collectionView cellForItemAtIndexPath:indexPath] viewWithTagString:@"图片ImageView"];
    UGLHPostModel *pm = _pm;
    
    void (^showMediaViewer)(NSArray <MediaModel *>*) = ^(NSArray *models) {
        MediaViewer *vpView = _LoadView_from_nib_(@"MediaViewer");
        vpView.frame = APP.Bounds;
        vpView.models = models;
        vpView.index = indexPath.item;
        [TabBarController1.view addSubview:vpView];
        
        {
            // 入场动画
            CGRect rect = [imgView convertRect:imgView.bounds toView:APP.Window];
            [vpView showEnterAnimations:rect image:imgView.image];
            
            // 退场动画
            vpView.exitAnimationsBlock = ^CGRect (MediaViewer *mv) {
                UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:mv.index inSection:0]];
                UIImageView *imgV = [cell viewWithTagString:@"图片ImageView"];
                return [imgV convertRect:imgV.bounds toView:APP.Window];
            };
        }
    };
    
    // 初始化 MediaModel
    showMediaViewer(({
        NSMutableArray <MediaModel *>*models = @[].mutableCopy;
        for (NSString *pic in pm.contentPic) {
            MediaModel *mm = [MediaModel new];
            mm.imgUrl = [NSURL URLWithString:pic];
            [models addObject:mm];
        }
        models;
    }));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UGPostCell1 itemSizeWithModel:_pm];
}

@end
