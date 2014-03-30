//
//  myDetailViewController.m
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "myDetailViewController.h"

@interface myDetailViewController ()

@end

@implementation myDetailViewController

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
    self.sc_count.text=self.ic_count.text=self.it_count.text=self.st_count.text=@"";
    self.is_all.on= self.is_ic.on = self.is_it.on = self.is_sc.on = self.is_st.on = NO;
    [self.is_all addTarget:self action:@selector(allChanged:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forceReload)
                                                 name:@"reloadRequest"
                                               object:nil];
    // Do any additional setup after loading the view.
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)swipeLeft:(id)sender {

    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        NSNotification *notif = [NSNotification notificationWithName:@"nextRequest" object:self];
                        [[NSNotificationCenter defaultCenter] postNotification:notif];
                    }
                    completion:NULL];
//    [self .splitViewController.viewControllers]
}
- (IBAction)swipeRight:(id)sender {
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        NSNotification *notif = [NSNotification notificationWithName:@"prevRequest" object:self];
                        [[NSNotificationCenter defaultCenter] postNotification:notif];
                    }
                    completion:NULL];
//    NSNotification *notif = [NSNotification notificationWithName:@"prevRequest" object:self];
//    [[NSNotificationCenter defaultCenter] postNotification:notif];
    //    [self .splitViewController.viewControllers]
}
- (IBAction)allChanged:(UISwitch*)sender {
    [self.is_st setOn:sender.on animated:YES];
    [self.is_sc setOn:sender.on animated:YES];
    [self.is_it setOn:sender.on animated:YES];
    [self.is_ic setOn:sender.on animated:YES];    
}

-(void)allChanged{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void) updateViewWithObject:(Classroom *) classRoom{

    
    self.buildingName.text = classRoom.building;
    self.className.text=classRoom.roomNo;
    self.sc_count.text= classRoom.sc_count;
    self.ic_count.text=classRoom.ic_count;
    self.it_count.text=classRoom.it_count;
    self.st_count.text=classRoom.st_count;


}

@end
