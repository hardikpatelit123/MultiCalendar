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

@interface ViewController ()<EKEventEditViewDelegate>
// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;
@end

@implementation ViewController

@synthesize tblViewCalendar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the event store
    self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
    self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Check whether we are authorized to access Calendar
    [self checkEventStoreAccessForCalendar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // Enable the Add button
    

    
   arrayCalendar = [[NSMutableArray alloc]init];
    arrayCalendar = [self listCalendars];
     // Update the UI with the above events
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
    
    
  //  NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
   // NSMutableArray *arrayTemp = [[NSMutableArray alloc]initWithArray:calendars];
    return arrayTemp;
    
    
    
}



//- (NSDictionary *)listCalendars {
////    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
////    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
////    
////    for (int i=0; i<allCalendars.count; i++) {
////        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
////        if (currentCalendar.type == EKCalendarTypeLocal) {
////            [localCalendars addObject:currentCalendar];
////        }
////    }
////    
////    return (NSMutableArray *)localCalendars;
//    
//    
//    EKEventStore *eventDB = [[EKEventStore alloc] init];
//    NSArray * calendars = [eventDB calendars];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    NSString * typeString = @"";
//    
//    for (EKCalendar *thisCalendar in calendars) {
//        EKCalendarType type = thisCalendar.type;
//        if (type == EKCalendarTypeLocal) {
//            typeString = @"local";
//        }
//        if (type == EKCalendarTypeCalDAV) {
//            typeString = @"calDAV";
//        }
//        if (type == EKCalendarTypeExchange) {
//            typeString = @"exchange";
//        }
//        if (type == EKCalendarTypeSubscription) {
//            typeString = @"subscription";
//        }
//        if (type == EKCalendarTypeBirthday) {
//            typeString = @"birthday";
//        }
//        if (thisCalendar.allowsContentModifications) {
//            NSLog(@"The title is:%@", thisCalendar.title);
//            [dict setObject: typeString forKey: thisCalendar.title];
//        }
//    }
//    return dict;
//    
//}
//

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    ViewController * __weak weakSelf = self;
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // Re-fetch all events happening in the next 24 hours
                 weakSelf.eventsList = [self fetchEvents];
                 // Update the UI with the above events
                // [weakSelf.tableView reloadData];
             });
         }
     }];
}




// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    return self.defaultCalendar;
}

// Fetch all events happening in the next 24 hours
- (NSMutableArray *)fetchEvents
{
    NSDate *startDate = [NSDate date];
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;
    
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    // We will only search the default calendar for our events
    NSArray *calendarArray = [NSArray arrayWithObject:self.defaultCalendar];
    
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
    
    // Fetch all events that match the predicate
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
    return events;
}



#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (!self.tblCalendars.isEditing) {
//        return self.arrCalendars.count;
//    }
//    else{
    return [arrayCalendar count];
 //   }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    
//    if (self.tblCalendars.isEditing) {
//        if (indexPath.row == 0) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"idCellEdit"];
//            
//            UITextField *textfield = (UITextField *)[cell viewWithTag:10];
//            textfield.delegate = self;
//        }
//    }
//    
//    if (!self.tblCalendars.isEditing || (self.tblCalendars.isEditing && indexPath.row != 0)) {
//        NSInteger row = self.tblCalendars.isEditing ? indexPath.row - 1 : indexPath.row;
//        
//        EKCalendar *currentCalendar = [self.arrCalendars objectAtIndex:row];
    
    cell.textLabel.text = [arrayCalendar objectAtIndex:indexPath.row];
    
//        if (!self.tblCalendars.isEditing) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//            if (self.appDelegate.eventManager.selectedCalendarIdentifier.length > 0) {
//                if ([currentCalendar.calendarIdentifier isEqualToString:self.appDelegate.eventManager.selectedCalendarIdentifier]) {
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                }
//            }
//            else{
//                
//                if (indexPath.row == 0) {
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                }
//            }
//        }
//    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

@end
