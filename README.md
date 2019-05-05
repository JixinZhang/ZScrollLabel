# iOS 跑马灯Label
## 一、跑马灯Label的设计
* 当UILabel限定只能显示一行时，如果文字超过Label的width就会被省略；
* 跑马灯Label所要做的就是当文字超过Label的width时自动滚动。
* 有如下特点：
	* 文字长度小于Label的width时，不滚动；
	* 文字长度大于Label的width时，自动滚动；
	* 当文字完全滚动显示后停止一段时间再滚动。

## 二、成果展示
### [Github 传送门](https://github.com/JixinZhang/ZScrollLabel)


![ZScollLabel.gif](http://upload-images.jianshu.io/upload_images/2409226-8572157df5f5a596.gif?imageMogr2/auto-orient/strip)

## 三、接入使用
### 1.接入

直接将[我的项目中](https://github.com/JixinZhang/ZScrollLabel)中的ZScrollLabel文件夹中的内容添加到工程中即可。

### 2.使用

```
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentLabel.text = @"一身诗意千寻瀑，万古人间四月天";
    [self.view addSubview:self.contentLabel];
}


```

### 3.注意事项

如果使用ZScollLabel的ViewControler有NavigationController，那么请务必要在`-(void)viewDidLoad`方法中添加`self.automaticallyAdjustsScrollViewInsets = NO;`让ZScrollLabel的Frame计算从屏幕顶部开始，而不是从导航栏的底部开始。

## 四、实现原理

* 在contentView(UIView)上添加两个UILabel，左右排列。当文字长度超过contentView的宽度时，展示两个Label，添加动画；当文字长度小于contentView的宽度时，将右侧的Label隐藏，不添加动画；
* 向左的滚动动画：使用UIView的UIViewAnimation做属性动画，更改contgentView的frame的x值；
* 滚动结束后，延迟若干秒再次调用滚动动画；
* 当app进入后台，动画会取消，再进入前台时动画不会恢复，所以需要添加通知在app再次进入前台时开启动画。
* 当更新Label的文字的时候，需要先停止动画再计算是否需要开启动画。

###滚动动画的代码

```
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
```
