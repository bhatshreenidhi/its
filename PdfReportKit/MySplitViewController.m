//
//  MySplitViewController.m
//  PdfReportKit
//
//  Created by Hemanth on 19/05/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "MySplitViewController.h"

@interface MySplitViewController ()

@end

@implementation MySplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    const CGFloat kMasterViewWidth = 240.0;
    
    UIViewController *masterViewController = [self.viewControllers objectAtIndex:0];
    UIViewController *detailViewController = [self.viewControllers objectAtIndex:1];
    
    if (detailViewController.view.frame.origin.x > 0.0) {
        // Adjust the width of the master view
        CGRect masterViewFrame = masterViewController.view.frame;
        CGFloat deltaX = masterViewFrame.size.width - kMasterViewWidth;
        masterViewFrame.size.width -= deltaX;
        masterViewController.view.frame = masterViewFrame;
        
        // Adjust the width of the detail view
        CGRect detailViewFrame = detailViewController.view.frame;
        detailViewFrame.origin.x -= deltaX;
        detailViewFrame.size.width += deltaX;
        detailViewController.view.frame = detailViewFrame;
        
        [masterViewController.view setNeedsLayout];
        [detailViewController.view setNeedsLayout];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
