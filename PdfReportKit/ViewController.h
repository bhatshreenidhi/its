//
//  ViewController.h
//  PdfReportKit
//
//  Created by Antonio Scandurra on 11/21/12.
//  Copyright (c) 2012 apexnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRKGeneratorDataSource.h"
#import "PRKGeneratorDelegate.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController<PRKGeneratorDataSource, PRKGeneratorDelegate,UISplitViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    NSDictionary * defaultValues;
}
@property(nonatomic,strong) IBOutlet UIWebView *webView;
//@property(nonatomic,strong) NSMutableArray * articles;
@end
