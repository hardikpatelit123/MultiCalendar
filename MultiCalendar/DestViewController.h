//
//  DestViewController.h
//  MultiCalendar
//
//  Created by Pratik Shah on 30/01/15.
//  Copyright (c) 2015 Pratik Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *tblViewDestCalendar;
}

@property(nonatomic,retain)  IBOutlet UITableView *tblViewDestCalendar;

@end
