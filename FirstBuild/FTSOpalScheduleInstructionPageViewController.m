//
//  FTSOpalScheduleInstructionPageViewController.m
//  FirstBuild
//
//  Created by Gina on 11/07/2016.
//  Copyright © 2016 FirstBuild. All rights reserved.
//

#import "FTSOpalScheduleInstructionPageViewController.h"

@interface FTSOpalScheduleInstructionPageViewController ()

@end

@implementation FTSOpalScheduleInstructionPageViewController {
  
  NSArray *_pages;
  UIPageControl *_control;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.delegate = self;
  self.dataSource = self;
  
  UIViewController *page1 = [self.storyboard
                             instantiateViewControllerWithIdentifier:@"instruction#1"];
  UIViewController *page2 = [self.storyboard
                             instantiateViewControllerWithIdentifier:@"instruction#2"];
  UIViewController *page3 = [self.storyboard
                             instantiateViewControllerWithIdentifier:@"instruction#3"];
  UIViewController *page4 = [self.storyboard
                             instantiateViewControllerWithIdentifier:@"instruction#4"];
  UIViewController *page5 = [self.storyboard
                             instantiateViewControllerWithIdentifier:@"instruction#5"];
  UIViewController *page6 = [self.storyboard
                             instantiateViewControllerWithIdentifier:@"instruction#6"];
  
  
  _pages = @[page1, page2, page3, page4, page5, page6];
  
  [self setViewControllers:@[page1]
                 direction:UIPageViewControllerNavigationDirectionForward
                  animated:NO completion:nil];
  
  _control = [[UIPageControl alloc] init];
  
  UIPageControl *pageControl = [UIPageControl appearance];
  pageControl.pageIndicatorTintColor = [UIColor colorWithRed:239.0f/255.0f green:237.0f/255.0f blue:238.0f/255.0f alpha:1];[UIColor grayColor];
  pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:252.0f/255.0f green:88.0f/255.0f blue:45.0f/255.0f alpha:1];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
  return _pages[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  
  NSUInteger currentIndex = [_pages indexOfObject:viewController];
  
  if(currentIndex > 0){
    --currentIndex;
    currentIndex = currentIndex % (_pages.count);
    
    return [_pages objectAtIndex:currentIndex];
  }
  else {
    return nil;
  }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  NSUInteger currentIndex = [_pages indexOfObject:viewController];
  
  if(currentIndex < _pages.count-1) {
    ++currentIndex;
    currentIndex = currentIndex % (_pages.count);
    return [_pages objectAtIndex:currentIndex];
  }
  else {
    return nil;
  }
}

- (NSInteger)presentationCountForPageViewController: (UIPageViewController *)pageViewController {
  return _pages.count;
}

- (NSInteger)presentationIndexForPageViewController: (UIPageViewController *)pageViewController
{
  return 0;
}
@end
