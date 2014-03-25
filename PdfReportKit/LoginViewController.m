//
//  LoginViewController.m
//  PdfReportKit
//
//  Created by Hemanth on 25/03/14.
//  Copyright (c) 2014 apexnet. All rights reserved.
//

#import "LoginViewController.h"
#import "myTableViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)loginPressed:(id)sender {

    if ([self.login1.text isEqualToString:@"1" ] && [self.login2.text isEqualToString:@"2" ] && [self.login3.text isEqualToString:@"3" ]&& [self.login4.text isEqualToString:@"4"]) {
        myTableViewController *con = [[myTableViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    }
    NSLog(@"%d %d",[self.login1.text isEqualToString:@"1" ] && [self.login2.text isEqualToString:@"2" ] && [self.login3.text isEqualToString:@"3" ]&& [self.login4.text isEqualToString:@"4"],[self.login4.text isEqualToString:@"4"]);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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

@end
