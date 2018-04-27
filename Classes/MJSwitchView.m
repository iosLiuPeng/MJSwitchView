//
//  MJSwitchView.m
//  MJSwitchView
//
//  Created by 刘鹏 on 2018/4/27.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "MJSwitchView.h"

@interface MJSwitchView ()
@property (weak, nonatomic) IBOutlet UIView *viewClose;         ///< 关闭状态背景视图
@property (weak, nonatomic) IBOutlet UIView *viewOpen;          ///< 打开状态背景视图
@property (weak, nonatomic) IBOutlet UIView *viewThumb;         ///< 拇指按钮视图

@property (weak, nonatomic) IBOutlet UIImageView *imgViewClose; ///< 关闭状态图片视图
@property (weak, nonatomic) IBOutlet UIImageView *imgViewOpen;  ///< 打开状态图片视图
@property (weak, nonatomic) IBOutlet UIImageView *imgViewThumb; ///< 拇指按钮图片

@property (weak, nonatomic) IBOutlet UIView *viewCover; ///< 遮罩，按钮无效时显示
@property (nonatomic, assign) CGRect thumbOriginalFrame;///< 拖动前，拇指视图的初始位置
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lytThumbRight;   ///< 拇指按钮约束
@end


@implementation MJSwitchView
#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViewFromXib];
        
        [self configView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configView];
}

- (void)loadViewFromXib
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
    UIView *contentView = [nib instantiateWithOwner:self options:nil].firstObject;
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

#pragma mark - Subjoin
- (void)configView
{
    //默认有效
    self.enabled = YES;
    
    self.colorLblOpen = [UIColor whiteColor];
    self.colorLblClose = [UIColor whiteColor];
    self.fontLblOpen = 17.0;
    self.fontLblClose = 17.0;
}

#pragma mark - set & get
- (void)setOn:(BOOL)on
{
    if (_on == on) {
        return;
    }
    _on = on;
    
    // 更改UI
    _viewClose.hidden = on;
    _viewOpen.hidden = !on;
    
    _lytThumbRight.active = !on;
    // 阻尼效果动画
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:4.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

-(void)setEnabled:(BOOL)enabled
{
    //控件无效时不响应
    if (_enabled == enabled) {
        return;
    }
    
    _enabled = enabled;
    _viewCover.hidden = enabled;
}
#pragma mark - Action
/// 点击拇指视图
- (IBAction)tapThumbView:(UITapGestureRecognizer *)sender {
    //无效时不响应
    if (_enabled == NO) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.on = !self.on;
        // 状态传出
        if ([_delegate respondsToSelector:@selector(mjSwitchView:statusChange:)]) {
            [_delegate mjSwitchView:self statusChange:self.on];
        }
    }
}

/// 拖动拇指视图
- (IBAction)dragThumbView:(UIPanGestureRecognizer *)sender {
    //无效时不响应
    if (_enabled == NO) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 记录初始位置
        _thumbOriginalFrame = _viewThumb.frame;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        // 可移动的最大距离
        CGFloat maxOffset = self.bounds.size.width - self.bounds.size.height;
        // 视图必须保持宽度大于高度
        if (maxOffset <= 0) {
            return;
        }
        // 相对于初始位置的移动值
        CGPoint translation = [sender translationInView:self];
        if (_on) {
            // 开启状态，拇指视图在右边
            if (translation.x < 0 && translation.x >= -maxOffset) {
                CGRect frame = _thumbOriginalFrame;
                frame.origin.x += translation.x;
                _viewThumb.frame = frame;
            }
        } else {
            // 关闭状态，拇指视图在左边
            if (translation.x > 0 && translation.x <= maxOffset) {
                CGRect frame = _thumbOriginalFrame;
                frame.origin.x += translation.x;
                _viewThumb.frame = frame;
            }
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint tranlation = [sender translationInView:self];
        // 移动的距离，绝对值
        CGFloat offset = fabs(tranlation.x);
        // 可移动的最大距离
        CGFloat maxOffset = self.bounds.size.width - self.bounds.size.height;
        // 视图必须保持宽度大于高度
        if (maxOffset <= 0) {
            return;
        }
        
        if (offset >= maxOffset / 2.0) {
            // 超过一半则切换开关状态
            self.on = !self.on;
            
            // 状态传出
            if ([_delegate respondsToSelector:@selector(mjSwitchView:statusChange:)]) {
                [_delegate mjSwitchView:self statusChange:self.on];
            }
        } else {
            // 否则还原位置
            [UIView animateWithDuration:0.1 animations:^{
                self.viewThumb.frame = self.thumbOriginalFrame;
            }];
        }
    }
}

/// 点击背景视图
- (IBAction)tapBackroundView:(UITapGestureRecognizer *)sender {
    //无效时不响应
    if (_enabled == NO) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.on = !self.on;
        // 状态传出
        if ([_delegate respondsToSelector:@selector(mjSwitchView:statusChange:)]) {
            [_delegate mjSwitchView:self statusChange:self.on];
        }
    }
}

#pragma mark - CALayerDelegate
- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    self.layer.cornerRadius = self.layer.bounds.size.height / 2.0;
    self.layer.masksToBounds = YES;
    
    _viewThumb.layer.bounds = CGRectMake(0, 0, self.layer.bounds.size.height - 10, self.layer.bounds.size.height - 10);
    _viewThumb.layer.cornerRadius =  _viewThumb.layer.bounds.size.height / 2.0;
}

#pragma mark - Set & Get
- (void)setColorCloseViewBg:(UIColor *)colorCloseViewBg
{
    _colorCloseViewBg = colorCloseViewBg;
    _viewClose.backgroundColor = colorCloseViewBg;
}

- (void)setColorOpenViewBg:(UIColor *)colorOpenViewBg
{
    _colorOpenViewBg = colorOpenViewBg;
    _viewOpen.backgroundColor = colorOpenViewBg;
}

- (void)setColorThumbViewBg:(UIColor *)colorThumbViewBg
{
    _colorThumbViewBg = colorThumbViewBg;
    _viewThumb.backgroundColor = colorThumbViewBg;
}

- (void)setImgCloseViewBg:(UIImage *)imgCloseViewBg
{
    _imgCloseViewBg = imgCloseViewBg;
    _imgViewClose.image = imgCloseViewBg;
}

- (void)setImgOpenViewBg:(UIImage *)imgOpenViewBg
{
    _imgOpenViewBg = imgOpenViewBg;
    _imgViewOpen.image = imgOpenViewBg;
}

- (void)setImgThumbView:(UIImage *)imgThumbView
{
    _imgThumbView = imgThumbView;
    _imgViewThumb.image = imgThumbView;
}

- (void)setColorLblClose:(UIColor *)colorLblClose
{
    _colorLblClose = colorLblClose;
    _lblClose.textColor = colorLblClose;
}

- (void)setColorLblOpen:(UIColor *)colorLblOpen
{
    _colorLblOpen = colorLblOpen;
    _lblOpen.textColor = colorLblOpen;
}

- (void)setFontLblClose:(CGFloat)fontLblClose
{
    _fontLblClose = fontLblClose;
    _lblClose.font = [UIFont systemFontOfSize:fontLblClose];
}

- (void)setFontLblOpen:(CGFloat)fontLblOpen
{
    _fontLblOpen = fontLblOpen;
    _lblOpen.font = [UIFont systemFontOfSize:fontLblOpen];
}

@end
