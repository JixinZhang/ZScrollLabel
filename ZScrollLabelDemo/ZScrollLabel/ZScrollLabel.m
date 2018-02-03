//
//  ZScrollLabel.m
//  WeexDemo
//
//  Created by WSCN on 09/05/2017.
//  Copyright © 2017 wallstreetcn.com. All rights reserved.
//

#import "ZScrollLabel.h"

#define kDefaultScrollDuration 10
#define kDefaultSrollVelocity 37.5
#define kDefaultPauseTime 3.0
#define kDefaultPadding 20.0
#define kDefaultDelay 3.0

@interface ZScrollLabel()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelCopy;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL manualStop;

@end

@implementation ZScrollLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupZScrollLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupZScrollLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupZScrollLabel];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupZScrollLabel {
    self.layer.masksToBounds = YES;
    self.label = [self customLabel];
    self.labelCopy = [self customLabel];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.labelCopy];
    [self addSubview:self.contentView];
    
    _scrollDuration = kDefaultScrollDuration;
    _scrollVelocity = kDefaultSrollVelocity;
    _pauseInterval = kDefaultPauseTime;
    _delayInterval = kDefaultDelay;
    _paddingBetweenLabels = kDefaultPadding;
    _autoBeginScroll = YES;
    _manualStop = NO;
    _labelAlignment = ZScrollLabelAlignmentCenter;
    self.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldAutoScollLabel)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UILabel *)customLabel {
    UILabel *commenLabel = [[UILabel alloc] init];
    commenLabel.backgroundColor = [UIColor clearColor];
    [commenLabel sizeToFit];
    return commenLabel;
}

#pragma mark - setter

- (void)setText:(NSString *)text {
    _text = text;
    self.label.text = text;
    self.labelCopy.text = text;
    [self stopScrollAnimation];
    [self setLabelsFrame];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.label.textColor = textColor;
    self.labelCopy.textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.label.font = font;
    self.labelCopy.font = font;
}

- (void)setScrollVelocity:(CGFloat)scrollVelocity {
    if (scrollVelocity <= 0) {
        scrollVelocity = kDefaultSrollVelocity;
    }
    _scrollVelocity = scrollVelocity;
}

- (void)setLabelAlignment:(ZScrollLabelAlignment)labelAlignment {
    _labelAlignment = labelAlignment;
    [self setLabelsFrame];
}

#pragma mark - Private

/**
 设置UILabel的Frame
 */
- (void)setLabelsFrame {
    [self.label sizeToFit];
    [self.labelCopy sizeToFit];
    
    //label
    CGPoint center = CGPointMake(self.label.center.x, self.center.y - self.frame.origin.y);
    self.label.center = center;
    if (self.label.frame.size.width > self.frame.size.width) {
        CGRect labelFrame = self.label.frame;
        labelFrame.origin.x = 0;
        self.label.frame = labelFrame;
    }
    
    //labelCopy
    CGPoint copyCenter= CGPointMake(self.labelCopy.center.x, self.center.y - self.frame.origin.y);
    self.labelCopy.center = copyCenter;
    CGRect frame = self.labelCopy.frame;
    frame.origin.x = CGRectGetMaxX(self.label.frame) + _paddingBetweenLabels;
    self.labelCopy.frame = frame;
    
    CGSize size;
    if (self.label.frame.size.width > self.frame.size.width) {
        size.width = CGRectGetWidth(self.label.frame) + CGRectGetWidth(self.frame) + _paddingBetweenLabels;
    } else {
        size.width = CGRectGetWidth(self.frame);
    }
    size.height = self.frame.size.height;
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (self.label.frame.size.width > self.frame.size.width) {
        self.scrollDuration = self.label.frame.size.width / self.scrollVelocity;
        self.label.hidden = NO;
        self.labelCopy.hidden = NO;
        if (self.autoBeginScroll) {
            [self startScrollAnimation];
        }
    } else {
        self.scrolling = NO;
        self.labelCopy.hidden = YES;
        CGPoint center = self.label.center;
        if (self.labelAlignment == ZScrollLabelAlignmentLeft) {
            center.x = self.label.frame.size.width / 2.0;
        } else if (self.labelAlignment == ZScrollLabelAlignmentCenter) {
            center.x = self.center.x - self.frame.origin.x;
        } else {
            center.x = self.frame.size.width - self.label.frame.size.width / 2.0;
        }
        self.label.center = center;
    }
}

- (void)shouldAutoScollLabel {
    if (self.scrolling) {
        return;
    }
    self.scrolling = YES;
    
    CGSize size;
    size.height = self.frame.size.height;
    if (self.label.frame.size.width > self.frame.size.width) {
        size.width = CGRectGetWidth(self.label.frame) + CGRectGetWidth(self.frame) + _paddingBetweenLabels;
    } else {
        size.width = CGRectGetWidth(self.frame);
    }
    self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    
    [UIView beginAnimations:@"scrollLabel" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:self.scrollDuration];
    
    if (self.label.frame.size.width > self.frame.size.width) {
        self.contentView.frame = CGRectMake(-(self.label.frame.size.width + _paddingBetweenLabels), 0, size.width, size.height);
    } else {
        self.contentView.frame = CGRectMake(0, 0, size.width, size.height);
    }
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    self.scrolling = NO;
    if (self.label.frame.size.width > self.frame.size.width){
        __weak typeof (self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.pauseInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf && !weakSelf.manualStop) {
                [weakSelf shouldAutoScollLabel];
            }
        });
    } else {
        [self setLabelsFrame];
    }
}

- (void)startScrollAnimation {
    self.manualStop = NO;
    __weak typeof (self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf) {
            [weakSelf shouldAutoScollLabel];
        }
    });
}

- (void)stopScrollAnimation {
    [self.contentView.layer removeAllAnimations];
    self.scrolling = NO;
    self.manualStop = YES;
}

@end
