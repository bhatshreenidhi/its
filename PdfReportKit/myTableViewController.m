//
//  myTableViewController.m
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "myTableViewController.h"
#import "Classroom.h"
@interface myTableViewController ()
@property (nonatomic,retain) NSMutableArray *articles;
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
   
    
    NSArray *data = [testString componentsSeparatedByString:@"\n"];
    
    
    
    self.articles = [NSMutableArray array];
    
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
            c1.SC = [countArray objectAtIndex:0];
            c1.ST = [countArray objectAtIndex:1];
            c1.IC = [countArray objectAtIndex:2];
            c1.IT = [[countArray objectAtIndex:3]stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            
        }
        c1.isIC = TRUE;
        c1.isIT = TRUE;
        c1.isSC = TRUE;
        c1.isST = TRUE;
        c1.endTime = @"6:30 PM";
        [self.articles addObject:c1];
    }
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=((Classroom*)self.articles[indexPath.row]).roomNo;
    cell.detailTextLabel.text=((Classroom*)self.articles[indexPath.row]).building;
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
