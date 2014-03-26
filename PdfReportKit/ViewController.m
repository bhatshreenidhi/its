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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray * articles = [NSMutableArray array];
    /*NSFileManager *filemanager = [[NSFileManager alloc] init];
    NSString *path= @"/Users/shreenidhibhat/projGithub/PdfReportKit/1.csv";
    
    if([filemanager fileExistsAtPath:path]){
        
        NSLog(@"File exists");
    }
    else{
        NSLog(@"Does not exists");
    }
    
    NSData *data = [filemanager contentsAtPath:path];
    */
    
       defaultValues = @{
        @"articles"  : articles,
        @"date"      : @"03/30/2014",
        @"completedBy": @"Nikhil M M",
        };
    
    NSError * error;    
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"template2" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"template2" templateURLString:templatePath itemsPerPage:100 totalItems:articles.count pageOrientation:PRKLandscapePage dataSource:self delegate:self error:&error];
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

- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data
{
    NSString * basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * fileName = [basePath stringByAppendingPathComponent:@"report.pdf"];
    
    [data writeToFile:fileName atomically:YES];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:fileName]];
    [self.webView loadRequest:request];
}

@end
