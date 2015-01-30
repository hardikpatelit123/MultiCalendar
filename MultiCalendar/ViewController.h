//
//  ViewController.h
//  MultiCalendar
//
//  Created by Pratik Shah on 29/01/15.
//  Copyright (c) 2015 Hardik Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DBManager.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblViewRules;
    NSMutableArray *arrayRules;
}

@property(nonatomic,strong)IBOutlet UITableView *tblViewRules;
-(IBAction)moveToCreateRule:(id)sender;

@end

