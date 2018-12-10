//
//  MainViewController.m
//  CalendarDemo - Graphical Calendars Library for iOS
//
//  Copyright (c) 2014-2015 Julien Martin. All rights reserved.
//

#import "MainViewController.h"
#import "MonthViewController.h"
#import "NSCalendar+MGCAdditions.h"
#import "WeekViewController.h"

@interface MainViewController ()<WeekViewControllerDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) EKCalendarChooser *calendarChooser;
@property (nonatomic) BOOL firstTimeAppears;
@property (nonatomic) WeekViewController *weekViewController;

@end


@implementation MainViewController

#pragma mark - UIViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    NSString *calID = [[NSUserDefaults standardUserDefaults]stringForKey:@"calendarIdentifier"];
    self.calendar = [NSCalendar mgc_calendarFromPreferenceString:calID];
    
    NSUInteger firstWeekday = [[NSUserDefaults standardUserDefaults]integerForKey:@"firstDay"];
    if (firstWeekday != 0) {
        self.calendar.firstWeekday = firstWeekday;
    } else {
        [[NSUserDefaults standardUserDefaults]registerDefaults:@{ @"firstDay" : @(self.calendar.firstWeekday) }];
    }
    
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.calendar = self.calendar;
	
    self.calendarViewController = self.weekViewController;
	[self addChildViewController:self.weekViewController];
	[self.view addSubview:self.weekViewController.view];
	self.weekViewController.view.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight-200);
	[self.weekViewController didMoveToParentViewController:self];
    self.firstTimeAppears = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppears) {
        NSDate *date = [self.calendar mgc_startOfWeekForDate:[NSDate date]];
        [self.calendarViewController moveToDate:date animated:NO];
        self.firstTimeAppears = NO;
    }
}



- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UINavigationController *nc = (UINavigationController*)self.presentedViewController;
    if (nc) {
        BOOL hide = (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular && self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular);
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSettings:)];
        nc.topViewController.navigationItem.rightBarButtonItem = hide ? nil : doneButton;
    }
}

#pragma mark - Private

- (WeekViewController*)weekViewController
{
    if (_weekViewController == nil) {
        _weekViewController = [[WeekViewController alloc]initWithEventStore:self.eventStore];
        _weekViewController.calendar = self.calendar;
        _weekViewController.delegate = self;
    }
    return _weekViewController;
}

-(void)moveToNewController:(CalendarViewController*)newController atDate:(NSDate*)date
{
    [self.calendarViewController willMoveToParentViewController:nil];
    [self addChildViewController:newController];
    
    [self transitionFromViewController:self.calendarViewController toViewController:newController duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^
     {
         newController.view.frame = self.view.bounds;
         newController.view.hidden = YES;
     } completion:^(BOOL finished)
     {
         [self.calendarViewController removeFromParentViewController];
         [newController didMoveToParentViewController:self];
         self.calendarViewController = newController;
         [newController moveToDate:date animated:NO];
         newController.view.hidden = NO;
     }];
}

#pragma mark - Actions


- (IBAction)showCalendars:(id)sender
{
    if ([self.calendarViewController respondsToSelector:@selector(visibleCalendars)]) {
        self.calendarChooser = [[EKCalendarChooser alloc]initWithSelectionStyle:EKCalendarChooserSelectionStyleMultiple displayStyle:EKCalendarChooserDisplayAllCalendars eventStore:self.eventStore];
        self.calendarChooser.delegate = self;
        self.calendarChooser.showsDoneButton = YES;
        self.calendarChooser.selectedCalendars = self.calendarViewController.visibleCalendars;
    }
    
    if (self.calendarChooser) {
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:self.calendarChooser];
        self.calendarChooser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(calendarChooserStartEdit)];
        nc.modalPresentationStyle = UIModalPresentationPopover;
 
        [self showDetailViewController:nc sender:self];
        
        UIPopoverPresentationController *popController = nc.popoverPresentationController;
        popController.barButtonItem = (UIBarButtonItem*)sender;
    }
}


- (void)dismissSettings:(UIBarButtonItem*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)calendarChooserStartEdit
{
    self.calendarChooser.editing = YES;
    self.calendarChooser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(calendarChooserEndEdit)];
}

- (void)calendarChooserEndEdit
{
    self.calendarChooser.editing = NO;
    self.calendarChooser.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(calendarChooserStartEdit)];
}


#pragma mark - CalendarViewControllerDelegate

- (void)calendarViewController:(CalendarViewController*)controller didShowDate:(NSDate*)date
{
    [self.dateFormatter setDateFormat:@"MMMM yyyy"];
    
//    NSString *str = [self.dateFormatter stringFromDate:date];
//    self.currentDateLabel.text = str;
//    [self.currentDateLabel sizeToFit];
}

- (void)calendarViewController:(CalendarViewController*)controller didSelectEvent:(EKEvent*)event
{
    //NSLog(@"calendarViewController:didSelectEvent");
}

#pragma mark - EKCalendarChooserDelegate

- (void)calendarChooserSelectionDidChange:(EKCalendarChooser*)calendarChooser
{
    if ([self.calendarViewController respondsToSelector:@selector(setVisibleCalendars:)]) {
        self.calendarViewController.visibleCalendars = calendarChooser.selectedCalendars;
    }
}

- (void)calendarChooserDidFinish:(EKCalendarChooser*)calendarChooser
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
