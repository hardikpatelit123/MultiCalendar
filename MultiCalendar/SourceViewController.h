//
//  SourceViewController.h
//  MultiCalendar
//
//  Created by Pratik Shah on 30/01/15.
//  Copyright (c) 2015 Pratik Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface SourceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tblViewCalendar;
    NSMutableArray *arrayCalendar;
}
@property(nonatomic,strong)IBOutlet UITableView *tblViewCalendar;

@end
