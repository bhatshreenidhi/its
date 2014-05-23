//
//  ViewController.m
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import "ViewController.h"
#import "PRKGenerator.h"
#import "PRKRenderHtmlOperation.h"
#import "InvoiceItem.h"
#import "Classroom.h"

@interface ViewController ()
@property BOOL IShide;
@property (nonatomic, weak) IBOutlet UILabel *feedbackMsg;
@property (nonatomic,retain) NSString * fileName;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    defaultValues = @{
                      @"articles"  : self.rooms,
                      @"date"      : @"03/26/2014",
                      @"completedBy": @"Nikhil M M",
                      };
    NSError * error;
    for (int i=0; i<self.rooms.count; i++) {
        Classroom *c=self.rooms[i];
        c.isScCorrect=c.isSC ? @"\u2713" : @"\u2715";
        c.isIcCorrect=c.isIC ? @"\u2713" : @"\u2715";
        c.isItCorrect=c.isIT ? @"\u2713" : @"\u2715";
        c.isStCorrect=c.isST ? @"\u2713" : @"\u2715";
        c.problem = c.isSC&&c.isIC&&c.isIT&&c.isST ? @"":@"problem";
    }
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"template2" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"template2" templateURLString:templatePath itemsPerPage:100 totalItems: self.rooms.count pageOrientation:PRKLandscapePage dataSource:self delegate:self error:&error];
}
- (IBAction)composeMail:(id)sender {
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    [vc setSubject:@"Report"];
    vc.mailComposeDelegate=self;
    NSData *myData = [NSData dataWithContentsOfFile:self.fileName];
    [vc addAttachmentData:myData mimeType:@"application/pdf" fileName:@"Report.pdf"];
    [self presentViewController:vc animated:YES completion:NULL];
}

-(void)viewDidAppear:(BOOL)animated{
    [self hideMaster:self];
    [super viewDidAppear:animated];
}
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return self.IShide;
}

-(void)hideMaster:(id)hideState
{
    
    self.IShide=!self.IShide;
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = nil;
    self.splitViewController.delegate = self;
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication    sharedApplication].statusBarOrientation duration:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber offset:(NSUInteger)offset itemsCount:(NSUInteger)itemsCount
{
    if ([tagName isEqualToString:@"articles"])
    {
        NSUInteger count = itemsCount;
        if (offset + count > [[defaultValues valueForKey:tagName] count])
        {
            count = [[defaultValues valueForKey:tagName] count] - offset;
        }
        
        return [[defaultValues valueForKey:tagName] subarrayWithRange:NSMakeRange(offset, count)];
    }
    
    return [defaultValues valueForKey:tagName];
}

- (IBAction)done:(id)sender {
    [self hideMaster:self];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data
{
    NSString * basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * fileName = [basePath stringByAppendingPathComponent:@"report.pdf"];
    
    [data writeToFile:fileName atomically:YES];
    self.fileName=fileName;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:fileName]];
    [self.webView loadRequest:request];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            self.feedbackMsg.text = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            self.feedbackMsg.text = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            self.feedbackMsg.text = @"Result: Mail sent";
            break;
        case MFMailComposeResultFailed:
            self.feedbackMsg.text = @"Result: Mail sending failed";
            break;
        default:
            self.feedbackMsg.text = @"Result: Mail not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:2.0
                         animations:^{self.feedbackMsg.hidden=YES;}
                         completion:^(BOOL finished){ self.feedbackMsg.hidden=YES; }];
    }];
}

@end
