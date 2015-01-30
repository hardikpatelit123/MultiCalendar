//
//  SourceViewController.m
//  MultiCalendar
//
//  Created by Pratik Shah on 30/01/15.
//  Copyright (c) 2015 Pratik Shah. All rights reserved.
//

#import "SourceViewController.h"

@interface SourceViewController ()<EKEventEditViewDelegate>
// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;
@property (nonatomic, strong) EKEventStore *eventStore;
@end

@implementation SourceViewController

@synthesize tblViewCalendar;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Check whether we are authorized to access Calendar
    [self checkEventStoreAccessForCalendar];
}

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
             SourceViewController * __weak weakSelf = self;
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
    appDelegate.array_src = [[NSMutableArray alloc]init];
    appDelegate.array_src = [self listCalendars];
    // Reload Table after getting Data
    [self.tblViewCalendar reloadData];
}

#pragma mark - Private method implementation
-(NSMutableArray *)listCalendars{
    EKEventStore * eventStore = [[EKEventStore alloc] init];
    EKEntityType type = EKEntityTypeEvent;// EKEntityTypeReminder or EKEntityTypeEvent
    NSArray * calendars = [eventStore calendarsForEntityType:type];
    NSMutableArray *arrayTemp = [[NSMutableArray alloc]init];
    
    for (EKCalendar *thisCalendar in calendars) {
        if (thisCalendar.allowsContentModifications)
        {
            [arrayTemp addObject:thisCalendar.title];
        }
    }
    return arrayTemp;
}




#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [appDelegate.array_src count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [appDelegate.array_src objectAtIndex:indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    appDelegate.array_dest = [[NSMutableArray alloc]init];
    
     [appDelegate.array_src removeObjectAtIndex:indexPath.row] ;
    appDelegate.array_dest = [appDelegate.array_src copy];
    [self performSegueWithIdentifier:@"moveToDestination" sender:self];
}



@end
