//
//  myDetailViewController.m
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "myDetailViewController.h"
#import "ViewController.h"
#define kTabBarHeight 50
@interface myDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) Classroom *classRoom;
@property BOOL keyboardIsShown;
@property (weak, nonatomic) IBOutlet UITextView *remarksView;
@property (nonatomic,strong) NSString *zone,*typeOfReport;
@property BOOL isHidden;
@property (nonatomic,weak) UIView*reportSelectionView,*zoneView;

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
    if (self.typeOfReport==nil) {
        [self displayTypeOfReportSectionScreen];
    }
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

-(void)displayTypeOfReportSectionScreen{
    [self hideMaster:self];
    UIView *view =  [[NSBundle mainBundle] loadNibNamed:@"reportTypeSelection" owner:self options:nil][0];
    self.reportSelectionView=view;
    UIButton *closingButton,*openingbutton;
    closingButton=[view subviews][1];
    openingbutton =[view subviews][0];
    [closingButton addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
    [openingbutton addTarget:self action:@selector(openPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:view];
}
-(IBAction)closePressed:(id)sender{
    self.typeOfReport=@"Close";
    [self showZoneSelectionView];
}
-(IBAction)openPressed:(id)sender{
    self.typeOfReport=@"Open";
    [self showZoneSelectionView];
}
-(void)showZoneSelectionView{
    [UIView beginAnimations:@"curlup" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [self.reportSelectionView removeFromSuperview];
    [UIView commitAnimations];
    
    UIView *view =  [[NSBundle mainBundle] loadNibNamed:@"zoneSelectionView" owner:self options:nil][0];
    self.zoneView = view;
    NSArray *zones=[self readZonesFromFile];
    for (int i=0; i<zones.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:zones[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(300,700-((i+1)*80), 150, 50.0);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [button.layer setBorderWidth:5];
        [view addSubview:button];
        [button addTarget:self action:@selector(zonePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:view];
}

-(IBAction)zonePressed:(UIButton*)button{
    self.zone=button.titleLabel.text;
    [UIView beginAnimations:@"curlup" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [self.zoneView removeFromSuperview];
    [self unhideMaster:self];
    [UIView commitAnimations];
    
}

-(NSArray*)readZonesFromFile{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zones" ofType:@"csv"];
    NSString *testString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *data = [testString componentsSeparatedByString:@"\n"];
    return data;
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

-(void)hideMaster:(id)hideState
{
    self.isHidden=YES;
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = self;
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
    //also put your `MPMoviePlayerController` Fullscreen Method here
}
-(void)unhideMaster:(id)hideState
{
    self.isHidden=NO;
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = self;
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
    //also put your `MPMoviePlayerController` Fullscreen Method here
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    if(!self.isHidden)
        return orientation==UIInterfaceOrientationMaskPortrait;
    return YES;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ViewController *report=segue.destinationViewController;
    report.rooms=self.rooms;
}
@end
