//
//  MJSwitchView.h
//  MJSwitchView
//
//  Created by 刘鹏 on 2018/4/27.
//  Copyright © 2018年 musjoy. All rights reserved.
//  开关按钮

#import <UIKit/UIKit.h>
@class MJSwitchView;

@protocol MJSwitchViewDelegate <NSObject>
// 开关状态改变
- (void)mjSwitchView:(MJSwitchView *)switchView statusChange:(BOOL)on;
@end

IB_DESIGNABLE
@interface MJSwitchView : UIView
@property (nonatomic, assign) IBInspectable BOOL on;  ///< 开关
@property (nonatomic, assign) IBInspectable BOOL enabled; ///< 是否有效（默认YES）

@property (nonatomic, strong) IBInspectable UIColor *colorCloseViewBg;    ///< 关闭状态背景视图颜色
@property (nonatomic, strong) IBInspectable UIColor *colorOpenViewBg;     ///< 打开状态背景视图颜色
@property (nonatomic, strong) IBInspectable UIColor *colorThumbViewBg;    ///< 拇指按钮背景视图颜色

@property (nonatomic, strong) IBInspectable UIImage *imgCloseViewBg;      ///< 关闭状态背景图片
@property (nonatomic, strong) IBInspectable UIImage *imgOpenViewBg;       ///< 打开状态背景图片
@property (nonatomic, strong) IBInspectable UIImage *imgThumbView;        ///< 拇指按钮图片

@property (nonatomic, strong) IBOutlet UILabel *lblClose;                 ///< 关闭状态文案
@property (nonatomic, strong) IBOutlet UILabel *lblOpen;                  ///< 打开状态文案

@property (nonatomic, strong) IBInspectable UIColor *colorLblClose;       ///< 关闭状态文案颜色
@property (nonatomic, strong) IBInspectable UIColor *colorLblOpen;        ///< 打开状态文案颜色

@property (nonatomic, assign) IBInspectable CGFloat fontLblClose;         ///< 关闭状态文案字体
@property (nonatomic, assign) IBInspectable CGFloat fontLblOpen;          ///< 打开状态文案字体

@property (nonatomic, weak) IBOutlet id<MJSwitchViewDelegate> delegate;  ///< 事件代理
@end
