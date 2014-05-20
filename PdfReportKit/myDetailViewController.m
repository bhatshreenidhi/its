//
//  myDetailViewController.m
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "myDetailViewController.h"
#define kTabBarHeight 50
@interface myDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) Classroom *classRoom;
@property BOOL keyboardIsShown;
@property (weak, nonatomic) IBOutlet UITextView *remarksView;
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
    //self.is_all.on= self.is_ic.on = self.is_it.on = self.is_sc.on = self.is_st.on = NO;
    [self.is_all addTarget:self action:@selector(allChanged:) forControlEvents:UIControlEventValueChanged];
    [self.is_ic addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
    [self.is_it addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
    [self.is_sc addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
    [self.is_st addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    self.keyboardIsShown = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    self.remarksView.delegate=self;
}

- (void)orientationChanged:(NSNotification *)notification{
    [self.view endEditing:YES];
}
- (void)keyboardWillHide:(NSNotification *)n
{
    if (!([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) {
        return;
    }
    NSDictionary* userInfo = [n userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += (keyboardSize.width - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    self.keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    if (self.keyboardIsShown) {
        return;
    }
    if (!([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= (keyboardSize.width - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    self.keyboardIsShown = YES;
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
}

- (IBAction)allChanged:(UISwitch*)sender {
    if (sender==self.is_all) {
        [self.is_st setOn:sender.on animated:YES];
        [self.is_sc setOn:sender.on animated:YES];
        [self.is_it setOn:sender.on animated:YES];
        [self.is_ic setOn:sender.on animated:YES];
        [self swChanged:self];
    }
}

-(IBAction)swChanged:(id)sender{
    self.classRoom.isIC=self.is_ic.on;
    self.classRoom.isIT=self.is_it.on;
    self.classRoom.isSC=self.is_sc.on;
    self.classRoom.isST=self.is_st.on;
    [self.is_all setOn:(self.classRoom.isIC&&self.classRoom.isIT&&self.classRoom.isSC&&self.classRoom.isST) animated:YES];
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
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.classRoom.remarks=textView.text;
}
- (void) updateViewWithObject:(Classroom *) classRoom{
    self.classRoom=classRoom;
    self.buildingName.text = classRoom.building;
    self.className.text=classRoom.roomNo;
    self.sc_count.text= classRoom.sc_count;
    self.ic_count.text=classRoom.ic_count;
    self.it_count.text=classRoom.it_count;
    self.st_count.text=classRoom.st_count;
    self.is_ic.on=classRoom.isIC;
    self.is_it.on=classRoom.isIT;
    self.is_sc.on=classRoom.isSC;
    self.is_st.on=classRoom.isST;
    self.is_all.on=classRoom.isIC&&classRoom.isIT&&classRoom.isSC&&classRoom.isST;
    self.remarksView.text=classRoom.remarks;
}

@end
