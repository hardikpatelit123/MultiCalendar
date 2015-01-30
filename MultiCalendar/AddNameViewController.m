//
//  AddNameViewController.m
//  MultiCalendar
//
//  Created by Pratik Shah on 30/01/15.
//  Copyright (c) 2015 Pratik Shah. All rights reserved.
//

#import "AddNameViewController.h"

@interface AddNameViewController ()

@end



@implementation AddNameViewController

@synthesize txtRuleName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -button action
-(IBAction)clickNext:(id)sender{
    appDelegate.ruleName = txtRuleName.text;
      [self performSegueWithIdentifier:@"moveToSource" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
