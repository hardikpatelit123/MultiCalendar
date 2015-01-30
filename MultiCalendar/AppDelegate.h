//
//  AppDelegate.h
//  MultiCalendar
//
//  Created by Hardik patel on 29/01/15.
//  Copyright (c) 2015 Pratik Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *ruleName;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *ruleName;
@property (strong,nonatomic)  NSMutableArray *array_src;
@property (strong,nonatomic)  NSMutableArray *array_dest;


@end

