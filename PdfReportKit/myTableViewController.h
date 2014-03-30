//
//  myTableViewController.h
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myDetailViewController.h"

@interface myTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISplitViewControllerDelegate>
@property (strong, nonatomic) myDetailViewController *detailViewController;
-(void)nextRoom;
@end
