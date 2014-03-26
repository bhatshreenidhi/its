//
//  myDetailViewController.h
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  myTableViewController;
#import "Classroom.h"
@interface myDetailViewController : UIViewController <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *buildingName;
- (void) updateViewWithObject:(Classroom *) classRoom;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *sc_count;
@property (weak, nonatomic) IBOutlet UILabel *ic_count;
@property (weak, nonatomic) IBOutlet UILabel *it_count;
@property (weak, nonatomic) IBOutlet UILabel *st_count;
@property (weak, nonatomic) IBOutlet UISwitch *is_sc;
@property (weak, nonatomic) IBOutlet UISwitch *is_ic;
@property (weak, nonatomic) IBOutlet UISwitch *is_it;
@property (weak, nonatomic) IBOutlet UISwitch *is_st;
@property (weak, nonatomic) IBOutlet UISwitch *is_all;
@end


