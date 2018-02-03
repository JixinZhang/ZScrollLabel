//
//  ZScrollLabel.h
//  WeexDemo
//
//  Created by WSCN on 09/05/2017.
//  Copyright © 2017 wallstreetcn.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZScrollLabelAlignment) {
    ZScrollLabelAlignmentLeft = 0,
    ZScrollLabelAlignmentCenter,
    ZScrollLabelAlignmentRight
};

/**
 *  跑马灯Label
 *  当Text对应的Width超过了Frame宽度，滚动显示效果自动开启；
 *  当Text对应的Width未超过Frame宽度，无滚动显示效果。
 */
@interface ZScrollLabel : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) CGFloat scrollDuration;                   //滚动总时长，默认为10秒
@property (nonatomic, assign) CGFloat scrollVelocity;                   //滚动速率，默认为37.5(pt/s)。赋值必须大于0，否则速率默认为37.5
@property (nonatomic, assign) CGFloat paddingBetweenLabels;             //两个label之间的距离，默认为20
@property (nonatomic, assign) ZScrollLabelAlignment labelAlignment;     //当文字长度未超过Frame宽度时的对齐方式：左，中，右。默认为居中对齐。

@property (nonatomic, assign) CGFloat delayInterval;                    //延迟开始第一次滚动(单位：秒)， 默认为3秒
@property (nonatomic, assign) CGFloat pauseInterval;                    //循环滚动时，中间停止的时长(单位：秒)， 默认为3秒

@property (nonatomic, assign) BOOL autoBeginScroll;                     //是否自动开始滚动，默认为YES
@property (nonatomic, assign, getter=isScrolling) BOOL scrolling;       //是否在滚动

/**
 *  开始动画
 *  当调用 - (void)stopScrollAnimation 方法停止动画后，如果需要再开始动画时调用此方法，否则滚动将不会继续。
 */
- (void)startScrollAnimation;

/**
 *  停止动画
 */
- (void)stopScrollAnimation;

@end
