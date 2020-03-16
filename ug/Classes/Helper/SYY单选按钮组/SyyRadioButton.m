//
//  SyyRadioButton.m
//  QRadioButtonDemo
//
//  Created by 火炬信息 on 16/9/1.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SyyRadioButton.h"

static NSMutableDictionary *_sygroupRadioDic = nil;

@implementation SyyRadioButton
@synthesize delegate = _delegate;
@synthesize checked  = _checked;


- (void)initWithDelegate:(id)delegate groupId:(NSString*)groupId {
  
    if (self) {

        _delegate = delegate;
        _groupId = [groupId copy];
        
        [self addToGroup];
        
        self.exclusiveTouch = YES;
        

        [self addTarget:self action:@selector(radioBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
   
}

- (void)addToGroup {
    if(!_sygroupRadioDic){
        _sygroupRadioDic = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *_gRadios = [_sygroupRadioDic objectForKey:_groupId];
    if (!_gRadios) {
        _gRadios = [NSMutableArray array];
    }
    [_gRadios addObject:self];
    [_sygroupRadioDic setObject:_gRadios forKey:_groupId];
}

- (void)removeFromGroup {
    if (_sygroupRadioDic) {
        NSMutableArray *_gRadios = [_sygroupRadioDic objectForKey:_groupId];
        if (_gRadios) {
            [_gRadios removeObject:self];
            if (_gRadios.count == 0) {
                [_sygroupRadioDic removeObjectForKey:_groupId];
            }
        }
    }
}
/**
 *  syy 对外释放方法
 */
- (void)removeFromGroupGroupId :(NSString *)groupId{
    if (_sygroupRadioDic) {
        NSMutableArray *_gRadios = [_sygroupRadioDic objectForKey:groupId];
        if (_gRadios) {
            [_gRadios removeObject:self];
            if (_gRadios.count == 0) {
                [_sygroupRadioDic removeObjectForKey:groupId];
            }
        }
    }
}

- (void)uncheckOtherRadios {
    NSMutableArray *_gRadios = [_sygroupRadioDic objectForKey:_groupId];
    
    NSLog(@"_gRadios .=%lu",(unsigned long)_gRadios.count);
    if (_gRadios.count > 0) {
        for (SyyRadioButton *_radio in _gRadios) {
            int count = 0;
            if (_radio.checked ) {
                count++;
            }
            NSLog(@"_radio.checked = %d",count);
            
            int count2 = 0;
            if (![_radio isEqual:self] ) {
                count2++;
            }
            NSLog(@"![_radio isEqual:self] = %d",count2);
            
            if (_radio.checked && ![_radio isEqual:self]) {
                _radio.checked = NO;
            }
        }
    }
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [_delegate didSelectedRadioButton:self groupId:_groupId];
    }
}

- (void)radioBtnChecked {
    if (_checked) {
        return;
    }
    
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [_delegate didSelectedRadioButton:self groupId:_groupId];
        
    }
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_RADIO_ICON_WH)/2.0, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(Q_RADIO_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
//                      CGRectGetWidth(contentRect) - Q_RADIO_ICON_WH - Q_ICON_TITLE_MARGIN,
//                      CGRectGetHeight(contentRect));
//}

-(void)remove{
    [self removeFromGroup];
}

- (void)dealloc {
    [self removeFromGroup];

}


@end

