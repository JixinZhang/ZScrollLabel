//
//  ViewController.m
//  ZScrollLabelDemo
//
//  Created by WSCN on 23/08/2017.
//  Copyright © 2017 Jixin.com. All rights reserved.
//

#import "ViewController.h"
#import "ZScrollLabel.h"

@interface ViewController ()
@property (nonatomic, strong) ZScrollLabel *titleLabel;
@property (nonatomic, strong) ZScrollLabel *contentLabel;
@property (nonatomic, strong) ZScrollLabel *shortLabel;
@end

@implementation ViewController

- (ZScrollLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 100) / 2.0, 28, 100, 20)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.scrollDuration = 13;
    }
    return _titleLabel;
}

- (ZScrollLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 120) / 2.0, 80, 120, 20)];
        _contentLabel.textColor = [UIColor redColor];
        _contentLabel.font = [UIFont systemFontOfSize:18.0f];
        _contentLabel.scrollDuration = 13;
        _contentLabel.layer.borderWidth = 0.5;
        _contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentLabel.layer.cornerRadius = 3.0;
    }
    return _contentLabel;
}

- (ZScrollLabel *)shortLabel {
    if (!_shortLabel) {
        _shortLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 120) / 2.0, 120, 120, 20)];
        _shortLabel.textColor = [UIColor blackColor];
        _shortLabel.scrollDuration = 13;
        _shortLabel.layer.borderWidth = 0.5;
        _shortLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _shortLabel.layer.cornerRadius = 3.0;
    }
    return _shortLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleLabel.text = @"跑马灯label";
    [self.view addSubview:self.titleLabel];
    
    self.contentLabel.text = @"一身诗意千寻瀑，万古人间四月天";
    [self.view addSubview:self.contentLabel];
    
    self.shortLabel.text = @"Hello, world";
    [self.view addSubview:self.shortLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
