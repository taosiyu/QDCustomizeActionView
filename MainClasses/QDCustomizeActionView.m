//
//  QDCustomizeActionView.m
//  QDCustomizeAction
//
//  Created by Assassin on 2019/11/13.
//  Copyright © 2019 com.tencent.demo. All rights reserved.
//

#import "QDCustomizeActionView.h"
#import "QDCustomizeViewButton.h"
#import "QDCustomizeActionCell.h"
#import "QDCustomizeShadowView.h"
#import "QDWindowsObserver.h"
#import "QDCustomizeActionViewController.h"

#define CANCELBUTTONTITLE @"取消"

NSString * _Nonnull const QDAlertViewActionNotification      = @"QDAlertViewActionNotification";
NSString * _Nonnull const QDAlertViewCancelNotification      = @"QDAlertViewCancelNotification";

NSString * _Nonnull const QDAlertViewDidDismissAfterActionNotification      = @"QDAlertViewDidDismissAfterActionNotification";
NSString * _Nonnull const QDAlertViewDidDismissAfterCancelNotification      = @"QDAlertViewDidDismissAfterCancelNotification";

typedef enum {
    QDCustomizeViewTypeDefault      = 0,
    QDCustomizeViewTypeTextFields   = 1
}
QDCustomizeViewType;

@interface QDCustomizeActionView() <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (readwrite) QDAlertViewStyle style;
@property (readwrite) NSString         *title;
@property (readwrite) UIView           *innerView;
@property (readwrite) NSString         *message;
@property (readwrite) NSString         *cancelButtonTitle;
@property (readwrite) BOOL             showing;

@property (assign, nonatomic, getter=isExists) BOOL exists;

@property (assign, nonatomic) CGFloat keyboardHeight;

@property (strong, nonatomic) QDCustomizeActionCell *heightCell;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) QDCustomizeActionViewController *viewController;
@property (strong, nonatomic) UIVisualEffectView *backgroundView;
@property (assign, nonatomic, getter=isInitialized) BOOL initialized;

//action多于2个时，列表显示
@property (strong ,nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *separatorHorizontalView;
@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIVisualEffectView *blurCancelView;
@property (strong, nonatomic) QDCustomizeShadowView *shadowView;
@property (strong, nonatomic) QDCustomizeViewButton *cancelButton;

@property (strong, nonatomic) QDCustomizeShadowView *shadowCancelView;

@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UILabel           *messageLabel;
@property (strong, nonatomic) UIView            *innerContainerView;

@property (assign, nonatomic) CGPoint scrollViewCenterShowed;
@property (assign, nonatomic) CGPoint scrollViewCenterHidden;

@property (assign, nonatomic) CGPoint cancelButtonCenterShowed;
@property (assign, nonatomic) CGPoint cancelButtonCenterHidden;

/**
 过滤style == cancel ，剩下所有的按钮
 */
@property (nonatomic, strong) NSMutableArray <QDCustomizeViewButton *> *buttonsArray;

/**
 style == cancel 的所有按钮 注：一般只会设置一个
 */
@property (nonatomic, strong) NSMutableArray <QDCustomizeViewButton *> *cancelButtons;

@property (nonatomic, strong) NSMutableArray <QDCustomizeViewButton *> *actionArray;

@end

@implementation QDCustomizeActionView

- (nonnull instancetype)initWithViewAndTitle:(nullable NSString *)title
                                       style:(QDAlertViewStyle)style{
    if (self = [super init]) {
        self.style = style;
        self.title = title;
        [self configSetting];
        [self setupDefaults];
    }
    return self;
}

- (void)configSetting
{
    _buttonsArray = [NSMutableArray array];
}

- (void)addAction:(QDCustomizeViewButton *)action
{
    if (!action || !_buttonsArray) {
        return;
    }
    
    if (action.style == QDAlertActionStyleCancel) {
        self.cancelButton = action;
        [self cancelButtonInit];
        return;
    }
    
    [_buttonsArray addObject:action];
}

#pragma mark - Class load

+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [[QDWindowsObserver sharedInstance] startObserving];
    });
}

#pragma mark - Dealloc

- (void)dealloc {
    [self removeObservers];
}

- (nonnull instancetype)initAsAppearance {
    self = [super init];
    if (self) {
        _heightCell = [[QDCustomizeActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        _windowLevel = QDAlertViewWindowLevelAboveStatusBar;

        _tintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        _coverColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        _coverBlurEffect = nil;
        _coverAlpha = 1.0;
        _backgroundColor = UIColor.whiteColor;
        _backgroundBlurEffect = nil;
        _separatorsColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        _showsVerticalScrollIndicator = NO;
        _offsetVertical = 8.0;
        _cancelButtonOffsetY = 8.0;
        if (isIPhoneXSeries()) {
            //iphonex等机型底部需要增加高度
            _cancelButtonOffsetY = [QDCustomizeActionHelper homeIndicatorHeight];
        }
        _cancelButtonTitle = CANCELBUTTONTITLE;
        _heightMax = NSNotFound;
        _width = NSNotFound;

        _animationDuration = 0.5;
        _initialScale = 1.2;
        _finalScale = 0.95;
        
        _layerCornerRadius = 12.0;
        _layerBorderColor = nil;
        _layerBorderWidth = 0.0;
        _layerShadowColor = nil;
        _layerShadowRadius = 0.0;
        _layerShadowOffset = CGPointZero;

        _titleTextColor = nil;
        _titleTextAlignment = NSTextAlignmentCenter;
        _titleFont = nil;

        _messageTextColor = nil;
        _messageTextAlignment = NSTextAlignmentCenter;
        _messageFont = [UIFont systemFontOfSize:14.0];

        _buttonsEnabled = YES;
        _buttonsIconPosition = QDAlertViewButtonIconPositionLeft;

        _cancelButtonTitleColor = self.tintColor;
        _cancelButtonEnabled = YES;

    }
    return self;
}

- (void)setupDefaults
{
    QDCustomizeActionView *appearance = [QDCustomizeActionView appearance];

    _heightCell = appearance.heightCell;
    
    _windowLevel = appearance.windowLevel;
    _tag = NSNotFound;

    _tintColor = appearance.tintColor;
    _coverColor = appearance.coverColor;
    _coverBlurEffect = appearance.coverBlurEffect;
    _coverAlpha = appearance.coverAlpha;
    _backgroundColor = appearance.backgroundColor;
    _backgroundBlurEffect = appearance.backgroundBlurEffect;
    _buttonsHeight = 56;
    _offsetVertical = appearance.offsetVertical;
    _cancelButtonOffsetY = appearance.cancelButtonOffsetY;
    _cancelButtonTitle = appearance.cancelButtonTitle;
    _heightMax = appearance.heightMax;
    _width = appearance.width;
    
    _layerCornerRadius = appearance.layerCornerRadius;
    _layerBorderColor = appearance.layerBorderColor;
    _layerBorderWidth = appearance.layerBorderWidth;
    _layerShadowColor = appearance.layerShadowColor;
    _layerShadowRadius = appearance.layerShadowRadius;
    _layerShadowOffset = appearance.layerShadowOffset;

    _separatorsColor = appearance.separatorsColor;
    _showsVerticalScrollIndicator = appearance.showsVerticalScrollIndicator;

    _animationDuration = appearance.animationDuration;
    _initialScale = appearance.initialScale;
    _finalScale = appearance.finalScale;

    _titleTextColor = UIColor.grayColor;

    _titleTextAlignment = appearance.titleTextAlignment;
    _titleFont = [UIFont boldSystemFontOfSize:14.0];

    _messageTextColor = UIColor.blackColor;
    
    _messageTextAlignment = appearance.messageTextAlignment;
    _messageFont = appearance.messageFont;


    _buttonsEnabled = appearance.buttonsEnabled;
    _buttonsIconPosition = appearance.buttonsIconPosition;

    _cancelButtonTitleColor = appearance.cancelButtonTitleColor;
    _cancelButtonEnabled = appearance.cancelButtonEnabled;

    self.view = [UIView new];
    self.view.backgroundColor = UIColor.clearColor;
    self.view.userInteractionEnabled = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.backgroundView = [[UIVisualEffectView alloc] initWithEffect:self.coverBlurEffect];
    self.backgroundView.alpha = 0.0;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.backgroundView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
    tapGesture.delegate = self;
    [self.backgroundView addGestureRecognizer:tapGesture];

    self.viewController = [[QDCustomizeActionViewController alloc] initWithActionView:self view:self.view];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.hidden = YES;
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    self.window.backgroundColor = UIColor.clearColor;
    self.window.rootViewController = self.viewController;

    self.initialized = YES;
}

- (void)cancelAction:(id)sender {
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        [(UIButton *)sender setSelected:YES];
    }

    if (self.cancelHandler) {
        self.cancelHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewCancelled:)]) {
        [self.delegate alertViewCancelled:self];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:QDAlertViewCancelNotification object:self userInfo:nil];

    [self dismissAnimated:YES completionHandler:^{

        if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDismissAfterCancelled:)]) {
            [self.delegate alertViewDidDismissAfterCancelled:self];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:QDAlertViewDidDismissAfterCancelNotification object:self userInfo:nil];
    }];
}

#pragma mark - Observers

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisibleChanged:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowVisibleChanged:) name:UIWindowDidBecomeVisibleNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
}

#pragma mark - Window notifications

- (void)windowVisibleChanged:(NSNotification *)notification {
    if (notification.object == self.window) {
        [self.viewController.view setNeedsLayout];
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardVisibleChanged:(NSNotification *)notification {
    if (!self.isShowing || self.window.isHidden || !self.window.isKeyWindow) return;

    [QDCustomizeActionHelper
     keyboardAnimateWithNotificationUserInfo:notification.userInfo
     animations:^(CGFloat keyboardHeight) {
         if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
             self.keyboardHeight = keyboardHeight;
         }
         else {
             self.keyboardHeight = 0.0;
         }

         [self layoutValidateWithSize:self.view.bounds.size];
     }];
}

- (void)keyboardFrameChanged:(NSNotification *)notification {
    if (!self.isShowing ||
        self.window.isHidden ||
        !self.window.isKeyWindow ||
        [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] != 0.0) {
        return;
    }

    self.keyboardHeight = CGRectGetHeight([notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]);
}

#pragma mark - Setter and Getter

- (CGFloat)width {
    CGSize size = QDCustomizeActionHelper.appWindow.bounds.size;

    if (_width != NSNotFound) {
        CGFloat result = MIN(size.width, size.height);

        if (_width < result) {
            result = _width;
        }

        return result;
    }

    // If we try to get width of appearance object
    if (!self.isInitialized) return NSNotFound;

    if (self.style == QDAlertViewStyleAlert) {
        return 280.0; // 320.0 - (20.0 * 2.0)
    }
    return MIN(size.width, size.height) - 16.0; // MIN(size.width, size.height) - (8.0 * 2.0)
}

#pragma mark - Callbacks

- (void)willDismissCallback {
    if (self.willDismissHandler) {
        self.willDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
        [self.delegate alertViewWillDismiss:self];
    }
}

- (void)didDismissCallback {
    if (self.didDismissHandler) {
        self.didDismissHandler(self);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDismiss:)]) {
        [self.delegate alertViewDidDismiss:self];
    }
}

- (void)didShowCallback {

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidShow:)]) {
        [self.delegate alertViewDidShow:self];
    }

}

#pragma mark - Show

- (void)showAnimated:(BOOL)animated completionHandler:(QDAlertViewCompletionHandler)completionHandler {
    [self showAnimated:animated hidden:NO completionHandler:completionHandler];
}

- (void)showAnimated {
    [self showAnimated:YES completionHandler:nil];
}

- (void)show {
    [self showAnimated:NO completionHandler:nil];
}

- (void)showAnimated:(BOOL)animated hidden:(BOOL)hidden completionHandler:(QDAlertViewCompletionHandler)completionHandler {
    if (!self.isValid || self.isShowing) return;

    self.window.windowLevel = UIWindowLevelStatusBar + (self.windowLevel == QDAlertViewWindowLevelAboveStatusBar ? 1 : -1);
    self.view.userInteractionEnabled = NO;

    [self subviewsValidateWithSize:CGSizeZero];
    [self layoutValidateWithSize:CGSizeZero];

    self.showing = YES;

    UIWindow *keyWindow = QDCustomizeActionHelper.keyWindow;

    [keyWindow endEditing:YES];

    if (!hidden && keyWindow != QDCustomizeActionHelper.appWindow) {
        keyWindow.hidden = YES;
    }

    [self.window makeKeyAndVisible];

    [self addObservers];


    if (hidden) {
        self.scrollView.hidden = YES;
        self.backgroundView.hidden = YES;
        self.shadowView.hidden = YES;
        self.blurView.hidden = YES;

        if ([QDCustomizeActionHelper isCancelButtonSeparate:self]) {
            self.cancelButton.hidden = YES;
            self.shadowCancelView.hidden = YES;
            self.blurCancelView.hidden = YES;
        }
    }

    if (animated) {
        [QDCustomizeActionHelper
         animateWithDuration:self.animationDuration
         animations:^(void) {
             [self showAnimations];
         }
         completion:^(BOOL finished) {
             if (!hidden) {
                 [self showComplete];
             }

             if (completionHandler) {
                 completionHandler();
             }
         }];
    }
    else {
        [self showAnimations];

        if (!hidden) {
            [self showComplete];
        }

        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)showAnimations {
    self.backgroundView.alpha = self.coverAlpha;

    if (self.style == QDAlertViewStyleAlert) {
        self.scrollView.transform = CGAffineTransformIdentity;
        self.scrollView.alpha = 1.0;

        self.shadowView.transform = CGAffineTransformIdentity;
        self.shadowView.alpha = 1.0;

        self.blurView.transform = CGAffineTransformIdentity;
        self.blurView.alpha = 1.0;
    }
    else {
        self.scrollView.center = self.scrollViewCenterShowed;

        self.shadowView.center = self.scrollViewCenterShowed;

        self.blurView.center = self.scrollViewCenterShowed;
    }

    if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterShowed;

        self.shadowCancelView.center = self.cancelButtonCenterShowed;

        self.blurCancelView.center = self.cancelButtonCenterShowed;
    }
}

- (void)showComplete {
    [self didShowCallback];

    self.view.userInteractionEnabled = YES;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buttonsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QDCustomizeActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    [self configCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void)configCell:(QDCustomizeActionCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    QDCustomizeViewButton *model = self.buttonsArray[indexPath.row];

    QDActionButtonLayout *properties = nil;

    if (model) {
        properties = model.buttonLayout;
    }
    
    cell.textLabel.text             = model.title;

    cell.titleColor                 = properties.titleColor;
    cell.titleColorHighlighted      = properties.titleColorHighlighted;
    cell.titleColorDisabled         = properties.titleColorHighlighted;
    cell.backgroundColorNormal      = properties.backgroundColor;
    cell.backgroundColorHighlighted = properties.backgroundColorHighlighted;
    cell.backgroundColorDisabled    = properties.backgroundColorDisabled;

    UIImage *image = nil;

    if (properties.isUserIconImage) {
        image = properties.iconImage;
    }

    cell.image = image;

    UIImage *imageHighlighted = nil;

    if (properties.isUserIconImageHighlighted) {
        imageHighlighted = properties.iconImageHighlighted;
    }

    cell.imageHighlighted = imageHighlighted;

    UIImage *imageDisabled = nil;

    if (properties.isUserIconImageDisabled) {
        imageDisabled = properties.iconImageDisabled;
    }

    cell.imageDisabled = imageDisabled;
    cell.iconPosition  = properties.iconPosition ? properties.iconPosition : self.buttonsIconPosition;

    cell.separatorView.hidden                = (indexPath.row == self.buttonsArray.count - 1);
    cell.separatorView.backgroundColor       = self.separatorsColor;
    cell.textLabel.textAlignment             = properties.textAlignment;
    cell.textLabel.font                      = properties.font;
    cell.textLabel.numberOfLines             = properties.numberOfLines;
    cell.textLabel.lineBreakMode             = properties.lineBreakMode;
    cell.textLabel.adjustsFontSizeToFitWidth =  properties.adjustsFontSizeToFitWidth;
    cell.textLabel.minimumScaleFactor        = properties.minimumScaleFactor;

}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configCell:self.heightCell forRowAtIndexPath:indexPath];

    CGSize size = [self.heightCell sizeThatFits:CGSizeMake(CGRectGetWidth(tableView.bounds), CGFLOAT_MAX)];

    if (size.height < self.buttonsHeight) {
        size.height = self.buttonsHeight;
    }

    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cancelButtonTitle && ![QDCustomizeActionHelper isCancelButtonSeparate:self]) {
        [self cancelAction:nil];
    }
    else {
        NSUInteger index = indexPath.row;
        
        if (index >= self.buttonsArray.count) {
            return;
        }
        QDCustomizeViewButton *selectedButton = self.buttonsArray[index];

        [self actionActionAtIndex:index button:selectedButton];
    }
}

#pragma mark - Action

- (void)actionActionAtIndex:(NSUInteger)index button:(QDCustomizeViewButton *)button {
    if (self.actionHandler) {
        self.actionHandler(self, index, button.title);
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:title:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:index title:button.title];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:QDAlertViewActionNotification
                                                        object:self
                                                      userInfo:@{@"title": button.title,
                                                                 @"index": @(index)}];
    
    QDAlertActionHandler handler = button.handler;

    [self dismissAnimated:YES completionHandler:^{
        
        if (handler) {
            handler(button);
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:didDismissAfterClickedButtonAtIndex:title:)]) {
            [self.delegate alertView:self didDismissAfterClickedButtonAtIndex:index title:button.title];
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:QDAlertViewDidDismissAfterActionNotification
                                                            object:self
                                                          userInfo:@{@"title": button.title,
                                                                     @"index": @(index)}];
    }];
}

#pragma mark - Dismiss

- (void)dismissAnimated:(BOOL)animated completionHandler:(QDAlertViewCompletionHandler)completionHandler
{
    if (!self.isShowing) return;

       if (self.window.isHidden) {
           [self dismissComplete];
           return;
       }

        self.view.userInteractionEnabled = NO;
    
        self.showing = NO;

       [self.view endEditing:YES];

       [self willDismissCallback];

       if (animated) {
           [QDCustomizeActionHelper
            animateWithDuration:self.animationDuration
            animations:^(void) {
                [self dismissAnimations];

            }
            completion:^(BOOL finished) {
                [self dismissComplete];

                if (completionHandler) {
                    completionHandler();
                }
            }];
       }
       else {
           [self dismissAnimations];

           [self dismissComplete];

           if (completionHandler) {
               completionHandler();
           }
       }
}

- (void)dismissAnimations {
    self.backgroundView.alpha = 0.0;

    if (self.style == QDAlertViewStyleAlert) {
        CGAffineTransform transform = CGAffineTransformMakeScale(self.finalScale, self.finalScale);
        CGFloat alpha = 0.0;

        self.scrollView.transform = transform;
        self.scrollView.alpha = alpha;

        self.shadowView.transform = transform;
        self.shadowView.alpha = alpha;

        self.blurView.transform = transform;
        self.blurView.alpha = alpha;
    }
    else {
        self.scrollView.center = self.scrollViewCenterHidden;

        self.shadowView.center = self.scrollViewCenterHidden;

        self.blurView.center = self.scrollViewCenterHidden;
    }

    if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
        self.cancelButton.center = self.cancelButtonCenterHidden;

        self.shadowCancelView.center = self.cancelButtonCenterHidden;

        self.blurCancelView.center = self.cancelButtonCenterHidden;
    }
}

- (void)dismissComplete {
    [self removeObservers];

    self.window.hidden = YES;

    [self didDismissCallback];

    self.view = nil;
    self.viewController = nil;
    self.window = nil;
    self.delegate = nil;
}


#pragma mark - Transition


- (void)layoutValidateWithSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.viewController.view.bounds.size;
    }

    CGFloat width = self.width;

    self.view.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    self.backgroundView.frame = CGRectMake(0.0, 0.0, size.width, size.height);

    CGFloat heightMax = size.height - self.keyboardHeight - (self.offsetVertical * 2.0);
    CGFloat tempHeight = heightMax;

    if (self.windowLevel == QDAlertViewWindowLevelBelowStatusBar) {
        heightMax -= QDCustomizeActionHelper.statusBarHeight;
    }
    
    //减去地步安全区域
    if (heightMax > kStatusBarAndNavigationBarHeight()) {
        heightMax -= kStatusBarAndNavigationBarHeight();
    }

    if (self.heightMax != NSNotFound && self.heightMax < heightMax) {
        heightMax = self.heightMax;
    }

    if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
        heightMax -= self.buttonsHeight + self.cancelButtonOffsetY;
    }
    else if (!self.cancelButtonTitle && size.width < width + (self.buttonsHeight * 2.0)) {
        heightMax -= self.buttonsHeight * 2.0;
    }

    if (self.scrollView.contentSize.height < heightMax) {
        heightMax = self.scrollView.contentSize.height;
    }

    CGRect scrollViewFrame = CGRectZero;
    CGAffineTransform scrollViewTransform = CGAffineTransformIdentity;
    CGFloat scrollViewAlpha = 1.0;

    if (self.style == QDAlertViewStyleAlert) {
        scrollViewFrame = CGRectMake((size.width - width) / 2.0, (size.height - self.keyboardHeight - heightMax) / 2.0, width, heightMax);

        if (self.windowLevel == QDAlertViewWindowLevelBelowStatusBar) {
            scrollViewFrame.origin.y += QDCustomizeActionHelper.statusBarHeight / 2.0;
        }

        if (!self.isShowing) {
            scrollViewAlpha = 0.0;
        }
    }
    else
    {
        CGFloat bottomShift = self.offsetVertical;

        if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
            bottomShift += self.buttonsHeight+self.cancelButtonOffsetY;
        }

        scrollViewFrame = CGRectMake((size.width - width) / 2.0, size.height - bottomShift - heightMax, width, heightMax);
    }

    if (self.style == QDAlertViewStyleActionSheet) {
        CGRect cancelButtonFrame = CGRectZero;

        if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
            cancelButtonFrame = CGRectMake((size.width - width) / 2.0, size.height - self.cancelButtonOffsetY - self.buttonsHeight, width, self.buttonsHeight);
        }

        self.scrollViewCenterShowed = CGPointMake(CGRectGetMinX(scrollViewFrame) + (CGRectGetWidth(scrollViewFrame) / 2.0),
                                                  CGRectGetMinY(scrollViewFrame) + (CGRectGetHeight(scrollViewFrame) / 2.0));

        self.cancelButtonCenterShowed = CGPointMake(CGRectGetMinX(cancelButtonFrame) + (CGRectGetWidth(cancelButtonFrame) / 2.0),
                                                    CGRectGetMinY(cancelButtonFrame) + (CGRectGetHeight(cancelButtonFrame) / 2.0));

        CGFloat commonHeight = CGRectGetHeight(scrollViewFrame) + self.offsetVertical;

        if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
            commonHeight += self.buttonsHeight + self.cancelButtonOffsetY;
        }

        self.scrollViewCenterHidden = CGPointMake(CGRectGetMinX(scrollViewFrame) + (CGRectGetWidth(scrollViewFrame) / 2.0),
                                                  CGRectGetMinY(scrollViewFrame) + (CGRectGetHeight(scrollViewFrame) / 2.0) + commonHeight + self.layerBorderWidth + self.layerShadowRadius);

        self.cancelButtonCenterHidden = CGPointMake(CGRectGetMinX(cancelButtonFrame) + (CGRectGetWidth(cancelButtonFrame) / 2.0),
                                                    CGRectGetMinY(cancelButtonFrame) + (CGRectGetHeight(cancelButtonFrame) / 2.0) + commonHeight);

        if (!self.isShowing) {
            scrollViewFrame.origin.y += commonHeight;

            if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
                cancelButtonFrame.origin.y += commonHeight;
            }
        }

        if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButton) {
            self.cancelButton.frame = cancelButtonFrame;

            CGFloat offset = self.layerBorderWidth + self.layerShadowRadius;
            self.shadowCancelView.frame = CGRectInset(cancelButtonFrame, -offset, -offset);
            [self.shadowCancelView setNeedsDisplay];

            self.blurCancelView.frame = CGRectInset(cancelButtonFrame, -self.layerBorderWidth, -self.layerBorderWidth);
        }
    }

    scrollViewFrame = CGRectIntegral(scrollViewFrame);

    if (CGRectGetHeight(scrollViewFrame) - self.scrollView.contentSize.height == 1.0) {
        scrollViewFrame.size.height -= 2.0;
    }

    self.scrollView.frame = scrollViewFrame;
    self.scrollView.transform = scrollViewTransform;
    self.scrollView.alpha = scrollViewAlpha;

    CGFloat offset = self.layerBorderWidth + self.layerShadowRadius;
    self.shadowView.frame = CGRectInset(scrollViewFrame, -offset, -offset);
    self.shadowView.transform = scrollViewTransform;
    self.shadowView.alpha = scrollViewAlpha;
    [self.shadowView setNeedsDisplay];

    self.blurView.frame = CGRectInset(scrollViewFrame, -self.layerBorderWidth, -self.layerBorderWidth);
    self.blurView.transform = scrollViewTransform;
    self.blurView.alpha = scrollViewAlpha;
}

- (void)subviewsValidateWithSize:(CGSize)size {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = self.viewController.view.bounds.size;
    }

    CGFloat width = self.width;
    
    if (!self.isExists) {
        self.exists = YES;

        self.backgroundView.backgroundColor = self.coverColor;
        self.backgroundView.effect = self.coverBlurEffect;

        self.shadowView = [QDCustomizeShadowView new];
        self.shadowView.clipsToBounds = YES;
        self.shadowView.userInteractionEnabled = NO;
        self.shadowView.cornerRadius = self.layerCornerRadius;
        self.shadowView.strokeColor = self.layerBorderColor;
        self.shadowView.strokeWidth = self.layerBorderWidth;
        self.shadowView.shadowColor = self.layerShadowColor;
        self.shadowView.shadowBlur = self.layerShadowRadius;
        self.shadowView.shadowOffset = self.layerShadowOffset;
        [self.view addSubview:self.shadowView];

        self.blurView = [[UIVisualEffectView alloc] initWithEffect:self.backgroundBlurEffect];
        self.blurView.contentView.backgroundColor = self.backgroundColor;
        self.blurView.clipsToBounds = YES;
        self.blurView.layer.cornerRadius = self.layerCornerRadius;
        self.blurView.layer.borderWidth = self.layerBorderWidth;
        self.blurView.layer.borderColor = self.layerBorderColor.CGColor;
        self.blurView.userInteractionEnabled = NO;
        [self.view addSubview:self.blurView];

        self.scrollView = [UIScrollView new];
        self.scrollView.backgroundColor = UIColor.clearColor;
        self.scrollView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator;
        self.scrollView.alwaysBounceVertical = NO;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.layer.cornerRadius = self.layerCornerRadius - self.layerBorderWidth - (self.layerBorderWidth ? 1.0 : 0.0);
        [self.view addSubview:self.scrollView];

        CGFloat offsetY = 0.0;

        if (self.title) {
            self.titleLabel = [UILabel new];
            self.titleLabel.text = self.title;
            self.titleLabel.textColor = self.titleTextColor;
            self.titleLabel.textAlignment = self.titleTextAlignment;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.backgroundColor = UIColor.clearColor;
            self.titleLabel.font = self.titleFont;

            CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(width - QDAlertViewPaddingWidth * 2.0, CGFLOAT_MAX)];
            CGRect titleLabelFrame = CGRectMake(QDAlertViewPaddingWidth, self.innerMarginHeight, width - QDAlertViewPaddingWidth * 2.0, titleLabelSize.height);

            self.titleLabel.frame = titleLabelFrame;
            [self.scrollView addSubview:self.titleLabel];

            offsetY = CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame);
        }

        if (self.message) {
            self.messageLabel = [UILabel new];
            self.messageLabel.text = self.message;
            self.messageLabel.textColor = self.messageTextColor;
            self.messageLabel.textAlignment = self.messageTextAlignment;
            self.messageLabel.numberOfLines = 0;
            self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.messageLabel.backgroundColor = UIColor.clearColor;
            self.messageLabel.font = self.messageFont;

            if (!offsetY) {
                offsetY = self.innerMarginHeight / 2.0;
            }
            else if (self.style == QDAlertViewStyleActionSheet) {
                offsetY -= self.innerMarginHeight / 3.0;
            }

            CGSize messageLabelSize = [self.messageLabel sizeThatFits:CGSizeMake(width - QDAlertViewPaddingWidth * 2.0, CGFLOAT_MAX)];
            CGRect messageLabelFrame = CGRectMake(QDAlertViewPaddingWidth, offsetY + self.innerMarginHeight / 2.0, width-QDAlertViewPaddingWidth * 2.0, messageLabelSize.height);

            self.messageLabel.frame = messageLabelFrame;
            [self.scrollView addSubview:self.messageLabel];

            offsetY = CGRectGetMinY(self.messageLabel.frame) + CGRectGetHeight(self.messageLabel.frame);
        }
        
        if ([QDCustomizeActionHelper isCancelButtonSeparate:self] && self.cancelButtonTitle) {
            self.shadowCancelView = [QDCustomizeShadowView new];
            self.shadowCancelView.clipsToBounds = YES;
            self.shadowCancelView.userInteractionEnabled = NO;
            self.shadowCancelView.cornerRadius = self.layerCornerRadius;
            self.shadowCancelView.strokeColor = self.layerBorderColor;
            self.shadowCancelView.strokeWidth = self.layerBorderWidth;
            self.shadowCancelView.shadowColor = self.layerShadowColor;
            self.shadowCancelView.shadowBlur = self.layerShadowRadius;
            self.shadowCancelView.shadowOffset = self.layerShadowOffset;
            [self.view insertSubview:self.shadowCancelView belowSubview:self.scrollView];

            self.blurCancelView = [[UIVisualEffectView alloc] initWithEffect:self.backgroundBlurEffect];
            self.blurCancelView.contentView.backgroundColor = self.backgroundColor;
            self.blurCancelView.clipsToBounds = YES;
            self.blurCancelView.layer.cornerRadius = self.layerCornerRadius;
            self.blurCancelView.layer.borderWidth = self.layerBorderWidth;
            self.blurCancelView.layer.borderColor = self.layerBorderColor.CGColor;
            self.blurCancelView.userInteractionEnabled = NO;
            [self.view insertSubview:self.blurCancelView aboveSubview:self.shadowCancelView];

            self.cancelButton.layer.masksToBounds = YES;
            self.cancelButton.layer.cornerRadius = self.layerCornerRadius - self.layerBorderWidth - (self.layerBorderWidth ? 1.0 : 0.0);
            [self.view insertSubview:self.cancelButton aboveSubview:self.blurCancelView];
        }

        if (self.innerView) {
            self.innerContainerView = [UIView new];
            self.innerContainerView.backgroundColor = UIColor.clearColor;

            CGRect innerContainerViewFrame = CGRectMake(0.0, offsetY + self.innerMarginHeight, width, CGRectGetHeight(self.innerView.bounds));


            self.innerContainerView.frame = innerContainerViewFrame;
            [self.scrollView addSubview:self.innerContainerView];

            CGRect innerViewFrame = CGRectMake((width / 2.0) - (CGRectGetWidth(self.innerView.bounds) / 2.0),
                                               0.0,
                                               CGRectGetWidth(self.innerView.bounds),
                                               CGRectGetHeight(self.innerView.bounds));

            self.innerView.frame = innerViewFrame;
            [self.innerContainerView addSubview:self.innerView];

            offsetY = CGRectGetMinY(self.innerContainerView.frame) + CGRectGetHeight(self.innerContainerView.frame);
        }

        if (![QDCustomizeActionHelper isCancelButtonSeparate:self]) {
            self.cancelButton = nil;
        }

        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.clipsToBounds = NO;
        self.tableView.backgroundColor = UIColor.clearColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
        [self.tableView registerClass:[QDCustomizeActionCell class] forCellReuseIdentifier:@"cell"];
        self.tableView.frame = CGRectMake(0.0, 0.0, width, CGFLOAT_MAX);
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];

        if (!offsetY) {
            offsetY = -self.innerMarginHeight;
        }else{
            self.separatorHorizontalView = [UIView new];
            self.separatorHorizontalView.backgroundColor = self.separatorsColor;

            CGRect separatorTitleViewFrame = CGRectMake(0.0, 0.0, width, QDCustomizeActionHelper.separatorHeight);

            self.separatorHorizontalView.frame = separatorTitleViewFrame;
            self.tableView.tableHeaderView = self.separatorHorizontalView;
        }
    
        [self.scrollView addSubview:self.tableView];

        CGRect tableViewFrame = CGRectMake(0.0, offsetY + self.innerMarginHeight, width, self.tableView.contentSize.height);

        self.tableView.frame = tableViewFrame;

        offsetY = CGRectGetMinY(self.tableView.frame) + CGRectGetHeight(self.tableView.frame);
    
        self.scrollView.contentSize = CGSizeMake(width, offsetY);
    }
        
}


- (void)cancelButtonInit {
    if (!self.cancelButton) {
        return;
    }
    
    self.cancelButtonTitle = self.cancelButton.title;
    self.cancelButton.titleLabel.numberOfLines = self.cancelButton.buttonLayout.numberOfLines;
    self.cancelButton.titleLabel.lineBreakMode = self.cancelButton.buttonLayout.lineBreakMode;
    self.cancelButton.titleLabel.adjustsFontSizeToFitWidth = self.cancelButton.buttonLayout.adjustsFontSizeToFitWidth;
    self.cancelButton.titleLabel.minimumScaleFactor = self.cancelButton.buttonLayout.minimumScaleFactor;
    self.cancelButton.titleLabel.font = self.cancelButton.buttonLayout.font;
    self.cancelButton.titleLabel.textAlignment = self.cancelButton.buttonLayout.textAlignment;
    self.cancelButton.iconPosition = self.cancelButton.buttonLayout.iconPosition;
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];

    [self.cancelButton setTitleColor:self.cancelButton.buttonLayout.titleColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.cancelButton.buttonLayout.titleColorHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setTitleColor:self.cancelButton.buttonLayout.titleColorDisabled forState:UIControlStateDisabled];

    [self.cancelButton setBackgroundColor:self.cancelButton.buttonLayout.backgroundColor forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:self.cancelButton.buttonLayout.backgroundColorHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setBackgroundColor:self.cancelButton.buttonLayout.backgroundColorDisabled forState:UIControlStateDisabled];
    
    [self.cancelButton setImage:self.cancelButton.buttonLayout.iconImage forState:UIControlStateNormal];
    [self.cancelButton setImage:self.cancelButton.buttonLayout.iconImageHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setImage:self.cancelButton.buttonLayout.iconImageDisabled forState:UIControlStateDisabled];

    if (self.cancelButton.buttonLayout.textAlignment == NSTextAlignmentLeft) {
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else if (self.cancelButton.buttonLayout.textAlignment == NSTextAlignmentRight) {
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }

    if (self.cancelButton.imageView.image && self.cancelButton.titleLabel.text.length) {
        self.cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                                             QDAlertViewButtonImageOffsetFromTitle / 2.0,
                                                             0.0,
                                                             QDAlertViewButtonImageOffsetFromTitle / 2.0);
    }

    self.cancelButton.enabled = self.cancelButtonEnabled;
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UIAppearance

+ (instancetype)appearance {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)appearanceWhenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class<UIAppearanceContainer>)ContainerClass, ... {
    return [self sharedAlertViewForAppearance];
}

+ (instancetype)sharedAlertViewForAppearance {
    static QDCustomizeActionView *actionView;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        actionView = [[QDCustomizeActionView alloc] initAsAppearance];
    });

    return actionView;
}

#pragma mark - Helpers

- (BOOL)isAlertViewValid:(QDCustomizeActionView *)alertView {
    NSAssert(alertView.isInitialized, @"You need to use one of \"- initWith...\" or \"+ alertViewWith...\" methods to initialize LGAlertView");

    return YES;
}

- (BOOL)isValid {
    return [self isAlertViewValid:self];
}

- (CGFloat)innerMarginHeight {
    return self.style == QDAlertViewStyleAlert ? 16.0 : 12.0;
}

@end
