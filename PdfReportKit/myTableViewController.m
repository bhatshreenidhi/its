//
//  myTableViewController.m
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "myTableViewController.h"
#import "Classroom.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface myTableViewController ()
@property (nonatomic,strong) NSMutableArray *articles;

@end

@implementation myTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"class_list" ofType:@"csv"];
    NSString *testString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.splitViewController.delegate=self;
    
    NSArray *data = [testString componentsSeparatedByString:@"\n"];
    
    self.articles = [NSMutableArray array];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.articleArray = self.articles;
    
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
            
        }
        //        c1.isIC = TRUE;
        //        c1.isIT = TRUE;
        //        c1.isSC = TRUE;
        //        c1.isST = TRUE;
        //c1.endTime = @"6:30 PM";
        [self.articles addObject:c1];
    }
    [self.tableView reloadData];
    self.detailViewController = (myDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nextRoom)
                                                 name:@"nextRequest"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(prevRoom)
                                                 name:@"prevRequest"
                                               object:nil];
    
    //select first cell
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *index=[NSIndexPath indexPathForItem:0 inSection:0] ;
        [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:index];
        [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:self.tableView didSelectRowAtIndexPath:index];
    });
    
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation==UIDeviceOrientationPortrait) {
        return YES;
    }
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.splitViewController.delegate=self;
}

-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Classroom *classRoom=self.articles[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=classRoom.roomNo;
    cell.detailTextLabel.text=classRoom.building;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.detailViewController updateViewWithObject:self.articles[indexPath.row]];
}

-(void)nextRoom{
    NSIndexPath *oldIndex = self.tableView.indexPathForSelectedRow;
    NSIndexPath *newIndex;
    if(oldIndex.row+1>=self.articles.count)
        newIndex = [NSIndexPath  indexPathForRow:0 inSection:oldIndex.section];
    else
        newIndex = [NSIndexPath  indexPathForRow:(oldIndex.row+1%self.articles.count) inSection:oldIndex.section];
    [self.tableView selectRowAtIndexPath:newIndex animated:YES scrollPosition:newIndex];
    [self tableView:self.tableView didSelectRowAtIndexPath:newIndex];
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:newIndex animated:YES];
}


-(void)prevRoom{
    //  NSLog(@"prev room: %@",self.tableView.indexPathForSelectedRow);
    NSInteger newLast = [self.tableView.indexPathForSelectedRow indexAtPosition:self.tableView.indexPathForSelectedRow.length-1]-1 % self.articles.count;
    // hack cos mod of -ve is -ve in objective c
    if( newLast < 0 ) newLast += self.articles.count;
    NSIndexPath* indexPath = [[self.tableView.indexPathForSelectedRow indexPathByRemovingLastIndex] indexPathByAddingIndex:newLast];
    //NSLog(@"prev room: %@",indexPath);
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:indexPath];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:indexPath animated:YES];
}

-(void) generateReport{
    
}

@end
