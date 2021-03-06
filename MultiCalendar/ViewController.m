//
//  ViewController.m
//  MultiCalendar
//
//  Created by Hardik Patel on 29/01/15.
//  Copyright (c) 2015 Pratik Shah. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "AppDelegate.h"


@interface ViewController ()<EKEventEditViewDelegate>
// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation ViewController

@synthesize tblViewRules;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the event store
    self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
    self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"multical.sqlite"];
    NSString *qry_getrules = [NSString stringWithFormat:@"select * from rules"]; ;
    [self getRulesList:qry_getrules];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Check whether we are authorized to access Calendar
    //[self checkEventStoreAccessForCalendar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//$(SRCROOT)/MyPrefixHeader.pch

#pragma mark -
#pragma mark Access Calendar

// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             ViewController * __weak weakSelf = self;
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                 [weakSelf accessGrantedForCalendar];
             });
         }
     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    // Let's get the default calendar associated with our event store
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    
    //get Data for the Total Listed Calander
   arrayRules = [[NSMutableArray alloc]init];
    
    
  //  arrayRules = [[NSMutableArray alloc]initWithObjects:@"Rule1",@"Rule2",@"Rule3",@"Rule4", nil];
   // arrayRules = [self listCalendars];
     // Reload Table after getting Data
    [self.tblViewRules reloadData];
}



#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayRules count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    NSInteger indexOfruleid = [self.dbManager.arrColumnNames indexOfObject:@"rule_id"];
    NSInteger indexOfrulename = [self.dbManager.arrColumnNames indexOfObject:@"rule_name"];
    
    // Set the loaded data to the appropriate cell labels.
    NSString *strRulesName = @"";
    strRulesName = [[arrayRules objectAtIndex:indexPath.row] objectAtIndex:indexOfrulename];
    
    cell.textLabel.text = strRulesName;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

#pragma mark -button action

-(IBAction)moveToCreateRule:(id)sender{
    NSLog(@"Go to Next View");
      [self performSegueWithIdentifier:@"moveToAddName" sender:self];
}

#pragma mark -General Function
-(void)getRulesList:(NSString *)strData{
    arrayRules  = [[NSMutableArray alloc]initWithArray:[self.dbManager loadDataFromDB:strData]];
    [tblViewRules reloadData];
    //[self.dbManager loadDataFromDB:strData];
}
@end
