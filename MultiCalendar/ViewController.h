//
//  ViewController.h
//  MultiCalendar
//
//  Created by Pratik Shah on 29/01/15.
//  Copyright (c) 2015 Hardik Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblViewCalendar;
    NSMutableArray *arrayCalendar;
}

@property(nonatomic,strong)IBOutlet UITableView *tblViewCalendar;

@end

