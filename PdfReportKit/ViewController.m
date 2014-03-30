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
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray * articles = [NSMutableArray array];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"class_list" ofType:@"csv"];
    NSString *testString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    
    NSArray *data = [testString componentsSeparatedByString:@"\n"];
    
    
    
    //articles = [NSMutableArray array];
    
    for(int count=0;count<[data count];count++)
    {
        NSArray *info = [[data objectAtIndex:count] componentsSeparatedByString:@","];
        NSArray *roomInfo = [[info objectAtIndex:0] componentsSeparatedByString:@" "];
        NSArray *countArray = [[info objectAtIndex:1] componentsSeparatedByString:@"/"];
        
        
        Classroom *c1 = [[Classroom alloc] init];
        c1.building = [roomInfo objectAtIndex:0];
        c1.roomNo = [roomInfo objectAtIndex:1];
        if([countArray count]==4)
        {
            c1.sc_count = [countArray objectAtIndex:0];
            c1.st_count = [countArray objectAtIndex:1];
            c1.ic_count = [countArray objectAtIndex:2];
            c1.it_count = [[countArray objectAtIndex:3]stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            c1.isIcCorrect = @"\u2713";
            c1.isItCorrect = @"\u2713";
            c1.isScCorrect = @"\u2713";
            c1.isStCorrect = @"\u2713";
            
        }
        else
        {
            
        }
        c1.isIC = TRUE;
        c1.isIT = TRUE;
        c1.isSC = TRUE;
        c1.isST = TRUE;
        //[string stringByAppendingFormat:@"%C", 0x2665];
        
        
        c1.endTime = @"6:30 PM";
        [articles addObject:c1];
    }
    
    
    defaultValues = @{
                      @"articles"  : articles,
                      @"date"      : @"03/26/2014",
                      @"completedBy": @"Nikhil M M",
                      };
    
    NSError * error;
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"template2" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"template2" templateURLString:templatePath itemsPerPage:100 totalItems: articles.count pageOrientation:PRKLandscapePage dataSource:self delegate:self error:&error];
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
    
    _IShide=!self.IShide;
    [self.splitViewController.view setNeedsLayout];
    self.splitViewController.delegate = nil;
    self.splitViewController.delegate = self;
    
    [self.splitViewController willRotateToInterfaceOrientation:[UIApplication    sharedApplication].statusBarOrientation duration:0];
    
    //also put your `MPMoviePlayerController` Fullscreen Method here
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:fileName]];
    [self.webView loadRequest:request];
}

@end
