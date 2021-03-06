//
//  ImageManagerVC.m
//  UG图片管理器
//
//  Created by fish on 2020/11/24.
//

#import "ImageManagerVC.h"

#import "ImageItem.h"
#import "TagItem.h"
#import "DragFileView.h"

#import "ImageModel.h"


@interface ImageManagerVC ()<NSCollectionViewDelegate>
@property (weak) IBOutlet NSCollectionView *tagCollectionView;  /**<   标签CollectionView */
@property (weak) IBOutlet NSCollectionView *imgCollectionView;  /**<   图片CollectionView */

@property (weak) IBOutlet NSSegmentedControl *timeSegmentedControl; /**<   筛选时间 */
@property (weak) IBOutlet NSSegmentedControl *tagSegmentedControl;  /**<   筛选标签 */

@property (weak) IBOutlet NSTextField *tagTextField;
@property (weak) IBOutlet NSTextField *tipsLabel;
@property (weak) IBOutlet NSTextField *countLabel;
@property (nonatomic, strong) NSMutableArray <ImageModel *>*resultIMs;
@property (nonatomic, strong) NSMutableArray <ImageModel *>*selectedIMs;
@property (nonatomic, strong) NSArray <TagModel *>*allTags;
@property (nonatomic, strong) NSMutableArray <TagModel *>*selectedTags;
@end

@implementation ImageManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _resultIMs = ImageModel.allImages;
    _selectedIMs = @[].mutableCopy;
    _selectedTags = @[].mutableCopy;
    _allTags = [ImageModel getAllTags];
    [_imgCollectionView registerClass:[ImageItem class] forItemWithIdentifier:@"cell"];
    [_tagCollectionView registerClass:[TagItem class] forItemWithIdentifier:@"cell"];
    _tipsLabel.hidden = true;
    
    __weakSelf_(__self);
    __block BOOL __dragging = false;
    ((DragFileView *)self.view).didDragging = ^(BOOL inOrOut) {
        if (!__dragging && !__self.tipsLabel.hidden) return;
        __dragging = inOrOut;
        __self.imgCollectionView.hidden = inOrOut;
        __self.tipsLabel.hidden = !inOrOut;
        __self.tipsLabel.stringValue = @"\n拖拽到这里导入图片";
    };
    ((DragFileView *)self.view).didDragFiles = ^(NSArray<NSString *> * _Nonnull urls) {
        __self.imgCollectionView.hidden = false;
        __self.tipsLabel.hidden = true;
        __dragging = false;
        [__self addImagesWithURLs:({
            NSMutableArray *temp = @[].mutableCopy;
            for (NSString *url in urls) {
                [temp addObject:[NSURL fileURLWithPath:url]];
            }
            temp;
        })];
    };
    [self onFilterSegmentedControlsClick:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)refreshTags {
    NSArray *temp = _selectedTags.copy;
    [_selectedTags removeAllObjects];
    _allTags = [ImageModel getAllTags];
    for (TagModel *tm in temp) {
        [_selectedTags addObject:[_allTags objectWithValue:tm.title keyPath:@"title"]];
    }
    [_tagCollectionView reloadData];
}

- (void)addImagesWithURLs:(NSArray <NSURL *>*)urls {
    NSMutableArray *imgs = @[].mutableCopy;
    for (NSURL *url in urls) {
        NSLog(@"--->%@",url);
        //这个url是文件的路径
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSImage *img = [NSImage sd_imageWithData:data];
        if (img) {
            [imgs addObject:@{
                @"size":NSStringFromSize(img.size),
                @"img":[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength],
                @"url":url,
            }];
        }
    }
    _tipsLabel.hidden = false;
    _tipsLabel.stringValue = @"\n正在上传图片...";
    
    __weakSelf_(__self);
    NSMutableArray *existeds = @[].mutableCopy;
    NSMutableArray *fails = @[].mutableCopy;
    void (^upload)(void) = nil;
    void (^__block __next)(void) = upload = ^{
        NSDictionary *dict = imgs.firstObject;
        [imgs removeObject:dict];
        if (!dict) {
            [__self refreshTags];
            [__self onFilterSegmentedControlsClick:nil];
            __self.tipsLabel.stringValue = ({
                NSMutableString *tips = @"\n添加完毕".mutableCopy;
                if (existeds.count)
                    [tips appendFormat:@"，其中%d张已存在", (int)existeds.count];
                if (fails.count)
                    [tips appendFormat:@"，其中%d张上传失败", (int)fails.count];
                tips;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __self.tipsLabel.hidden = true;
            });
            return;
        }
        [NetworkManager1 uploadImage:dict[@"img"]].completionBlock = ^(CCSessionModel *sm, id resObject, NSError *err) {
            NSString *url = resObject[@"data"][@"url"];
            if (url.length) {
                if (![ImageModel.allImages containsValue:url keyPath:@"originalURL"]) {
                    ImageModel *im = [ImageModel new];
                    im.originalURL = url;
                    im.updateTime = im.createTime = [[NSDate date] timeIntervalSince1970];
                    im.size = dict[@"size"];
                    im.tags = @{@"未分类":@1}.mutableCopy;
                    [ImageModel.allImages addObject:im];
                } else {
                    [existeds addObject:url];
                }
            } else {
                [fails addObject:dict[@"url"]];
            }
            NSLog(@"res = %@", [resObject mj_keyValues]);
            __next();
        };
    };
    upload();
}


#pragma mark - IBAction

// 合并Git并提交
- (IBAction)onMergeToGitBtnClick:(NSButton *)sender {
    NSLog(@"提交打包日志");
    _tipsLabel.hidden = false;
    _tipsLabel.stringValue = @"\n从Git拉取最新图片。。。";
    __weakSelf_(__self);
    NSString *projectDir = RNPack.logFile.stringByDeletingLastPathComponent;
    NSString *logFile = [NSString stringWithFormat:@"%@/Images.json", projectDir];
    [ShellHelper pullCode:projectDir branch:@"img/images" completion:^(GitModel * _Nonnull _) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __self.tipsLabel.stringValue = @"\n正在合并。。。";
        });
        NSData *data = [NSData dataWithContentsOfFile:logFile];
        if (data) {
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *addArray = @[].mutableCopy;
            for (NSDictionary *dict in array) {
                ImageModel *git = [ImageModel mj_objectWithKeyValues:dict];
                ImageModel *cur = [ImageModel.allImages objectWithValue:git.originalURL keyPath:@"originalURL"];
                
                if (!cur) {
                    [addArray addObject:git];
                } else if (git.updateTime > cur.updateTime) {
                    [cur setValuesWithDictionary:dict];
                }
            }
            if (addArray.count) {
                [ImageModel.allImages addObjectsFromArray:addArray];
            } else {
                [ImageModel save];
            }
        }
        
        NSMutableArray *temp = @[].mutableCopy;
        for (ImageModel *im in ImageModel.allImages) {
            [temp addObject:im.mj_keyValues];
        }
        [temp sortUsingComparator:^NSComparisonResult(ImageModel * obj1, ImageModel * obj2) {
            return obj1.updateTime > obj2.updateTime;
        }];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [jsonString writeToFile:logFile atomically:true encoding:NSUTF8StringEncoding error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            __self.tipsLabel.stringValue = @"\n正在提交到Git。。。";
        });
        [ShellHelper pushCode:projectDir title:@"更新图片资源" completion:^{
            NSLog(@"提交图片成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                __self.tipsLabel.hidden = true;
            });
        }];
    }];
}

// 导出图片
- (IBAction)onExportBtnClick:(NSButton *)sender {
    
}

// 添加图片
- (IBAction)onAddImageBtnClick:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];//是否能选择文件file
    [panel setCanChooseDirectories:YES];//是否能打开文件夹
    [panel setAllowsMultipleSelection:YES];//是否允许多选file
    NSInteger finded = [panel runModal]; //获取panel的响应
    
    if (finded == NSModalResponseOK) {
        // NSFileHandlingPanelCancelButton = NSModalResponseCancel； NSFileHandlingPanelOKButton = NSModalResponseOK,
        [self addImagesWithURLs:[panel URLs]];
    }
}

// 筛选图片
- (IBAction)onFilterSegmentedControlsClick:(NSSegmentedControl *)sender {
    [self onClearSelectedIMsBtnClick:nil];
    
    BOOL isExclude = _tagSegmentedControl.selectedSegment;
    NSMutableArray *temp = @[].mutableCopy;
    for (ImageModel *im in ImageModel.allImages) {
        BOOL ignore = false;
        if (isExclude) {
            for (NSString *tag in im.tags) {
                if ([_selectedTags containsValue:tag keyPath:@"title"]) {
                    ignore = true;
                    break;
                }
            }
        } else {
            for (TagModel *tag in _selectedTags) {
                if (!im.tags[tag.title]) {
                    ignore = true;
                    break;
                }
            }
        }
        
        if (ignore)
            continue;
        [temp addObject:im];
    }
    __weakSelf_(__self);
    [temp sortUsingComparator:^NSComparisonResult(ImageModel *obj1, ImageModel *obj2) {
        if (__self.timeSegmentedControl.selectedSegment) {
            return obj1.createTime > obj2.createTime;
        } else {
            return obj1.createTime < obj2.createTime;
        }
    }];
    _resultIMs = temp;
    [_imgCollectionView reloadData];
    _countLabel.stringValue = [NSString stringWithFormat:@"筛选出%ld张，已选中%ld张", (long)_resultIMs.count, (long)_selectedIMs.count];
}

// 重置标签
- (IBAction)onSetupTagBtnClick:(NSButton *)sender {
    NSMutableDictionary *dict = @{}.mutableCopy;
    for (NSString *tag in [_tagTextField.stringValue componentsSeparatedByString:@","]) {
        dict[tag] = @1;
    }
    for (ImageModel *im in _selectedIMs) {
        switch (sender.tag) {
            case 0:
                im.tags = dict.mutableCopy;
                break;
            case 1:
                [im.tags addEntriesFromDictionary:dict];
                if (im.tags.count > 1) {
                    im.tags[@"未分类"] = nil;
                }
                break;
            case 2:
                [im.tags removeObjectsForKeys:dict.allKeys];
                if (!im.tags.count) {
                    im.tags[@"未分类"] = @1;
                }
                break;
                
            default:;
        }
        im.updateTime = [[NSDate date] timeIntervalSince1970];
    }
    [ImageModel save];
    
    _tagTextField.stringValue = @"";
    [self refreshTags];
    [self onFilterSegmentedControlsClick:nil];
    [self onClearSelectedIMsBtnClick:nil];
}

- (IBAction)onClearSelectedIMsBtnClick:(NSButton *)sender {
    for (ImageModel *im in _selectedIMs) {
        [_imgCollectionView itemAtIndex:[_resultIMs indexOfObject:im]].textField.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0];
    }
    [_selectedIMs removeAllObjects];
    _tagTextField.stringValue = @"";
    _countLabel.stringValue = [NSString stringWithFormat:@"筛选出%ld张，已选中%ld张", (long)_resultIMs.count, (long)_selectedIMs.count];
}


#pragma mark - NSCollectionViewDelegate

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _imgCollectionView) {
        return _resultIMs.count;
    } else {
        return _allTags.count;
    }
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    __weakSelf_(__self);
    if (collectionView == _imgCollectionView) {
        ImageItem *item = [collectionView makeItemWithIdentifier:@"cell" forIndexPath:indexPath];
        ImageModel *im = _resultIMs[indexPath.item];
        item.im = im;
        item.didClick = ^{
            [__self collectionView:__self.imgCollectionView didSelectItemsAtIndexPaths:[NSSet setWithObject:[NSIndexPath indexPathForItem:[__self.resultIMs indexOfObject:im] inSection:0]]];
        };
        item.didCopy = ^{
            __self.tipsLabel.backgroundColor = [NSColor.blackColor colorWithAlphaComponent:0.2];
            __self.tipsLabel.hidden = false;
            __self.tipsLabel.stringValue = @"\n已拷贝";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __self.tipsLabel.backgroundColor = [NSColor.blackColor colorWithAlphaComponent:0.6];
                __self.tipsLabel.hidden = true;
            });
        };
        return item;
    } else {
        TagItem *item = [collectionView makeItemWithIdentifier:@"cell" forIndexPath:indexPath];
        TagModel *tm = _allTags[indexPath.item];
        item.button.title = [NSString stringWithFormat:@"%@(%ld)", tm.title, (long)tm.cnt];
        item.aSelected = [_selectedTags containsObject:tm];
        item.didClick = ^(BOOL selected) {
            if (selected) {
                [__self.selectedTags addObject:tm];
            } else {
                [__self.selectedTags removeObject:tm];
            }
            [__self onFilterSegmentedControlsClick:nil];
        };
        return item;
    }
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    if (collectionView != _imgCollectionView) return;
    
    BOOL isSelect = false;
    for (NSIndexPath *ip in indexPaths.allObjects) {
        ImageModel *im = _resultIMs[ip.item];
        if (![_selectedIMs containsObject:im])
            isSelect = true;
    }
    for (NSIndexPath *ip in indexPaths.allObjects) {
        ImageModel *im = _resultIMs[ip.item];
        if (!isSelect) {
            [collectionView itemAtIndexPath:ip].textField.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0];
            [_selectedIMs removeObject:im];
        } else {
            [collectionView itemAtIndexPath:ip].textField.backgroundColor = [[NSColor blackColor] colorWithAlphaComponent:0.5];
            [_selectedIMs addObject:im];
        }
    }
    
    // 列出选中图片的所有标签
    NSMutableDictionary *dict = @{}.mutableCopy;
    for (ImageModel *im in _selectedIMs) {
        [dict addEntriesFromDictionary:im.tags];
    }
    _tagTextField.stringValue = [[dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }] componentsJoinedByString:@","];
    
    // 选中数量
    _countLabel.stringValue = [NSString stringWithFormat:@"筛选出%ld张，已选中%ld张", (long)_resultIMs.count, (long)_selectedIMs.count];
}

@end
