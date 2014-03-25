//
//  DDGSlideOverMenuController.m
//  DuckDuckGo
//
//  Created by Mic Pringle on 25/03/2014.
//
//

#import "DDGSlideOverMenuController.h"

@interface DDGSlideOverMenuController ()

@property (nonatomic, assign, readwrite, getter = isAnimating) BOOL animating;
@property (nonatomic, assign, readwrite, getter = isShowingMenu) BOOL showingMenu;

@end

@implementation DDGSlideOverMenuController

#pragma mark - DDGSlideOverMenuController

- (void)setContentViewController:(UIViewController *)contentViewController
{
    if (_contentViewController) {
        [_contentViewController.view removeFromSuperview];
        [_contentViewController willMoveToParentViewController:nil];
        [_contentViewController removeFromParentViewController];
    }
    _contentViewController = contentViewController;
    if (contentViewController) {
        [self addChildViewController:contentViewController];
        [contentViewController.view setFrame:[self.view bounds]];
        if (self.menuViewController) {
            [self.view insertSubview:contentViewController.view belowSubview:[self.menuViewController view]];
        } else {
            [self.view addSubview:contentViewController.view];
        }
        [contentViewController didMoveToParentViewController:self];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    if (!self.isAnimating) {
        CGRect frame = [self frameForMenuViewController];
        if (_menuViewController) {
            [_menuViewController.view removeFromSuperview];
            [_menuViewController willMoveToParentViewController:nil];
            [_menuViewController removeFromParentViewController];
        }
        _menuViewController = menuViewController;
        if (menuViewController) {
            [self addChildViewController:menuViewController];
            [menuViewController.view setFrame:frame];
            [self.view addSubview:menuViewController.view];
            [menuViewController didMoveToParentViewController:self];
        }
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Attempted to change the menu view controller whilst animating"];
    }
}

#pragma mark - UIViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
    self = [super initWithNibName:name bundle:bundle];
    if (self) {
        [self setup];
    }
    return self;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self endChildAppearanceTransition];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self endChildAppearanceTransition];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginChildAppearanceTransition:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self beginChildAppearanceTransition:NO animated:animated];
}

#pragma mark - Private

- (void)beginChildAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated
{
    if (self.menuViewController && self.isShowingMenu) {
        [self.menuViewController beginAppearanceTransition:isAppearing animated:animated];
    } else if (self.contentViewController) {
        [self.contentViewController beginAppearanceTransition:isAppearing animated:animated];
    }
}

- (void)endChildAppearanceTransition
{
    if (self.menuViewController && self.isShowingMenu) {
        [self.menuViewController endAppearanceTransition];
    } else if (self.contentViewController) {
        [self.contentViewController endAppearanceTransition];
    }
}

- (CGRect)frameForMenuViewController
{
    CGRect frame = CGRectZero;
    if (self.menuViewController) {
        frame = [[self.menuViewController view] frame];
    } else {
        frame = [self.view frame];
        frame.origin.x -= CGRectGetWidth(frame);
    }
    return frame;
}

- (void)setup
{
    self.animating = NO;
    self.showingMenu = NO;
}

@end
