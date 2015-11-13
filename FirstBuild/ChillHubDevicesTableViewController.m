//
//  ChillHubDevicesTableViewController.m
//  FirstBuild-Mobile
//
//  Created by Myles Caley on 12/18/14.
//  Copyright (c) 2014 FirstBuild. All rights reserved.
//

#ifdef CHILLHUB

#import "ChillHubDevicesTableViewController.h"
#import "FSTMilkyWeigh.h"
#import "FSTLedge.h"
#import "FSTBeerBank.h"
#import "ScaleViewController.h"
#import "LedgeViewController.h"
#import "BeerBankViewController.h"
#import "ChillHubDeviceTableViewCell.h"

@interface ChillHubDevicesTableViewController ()

@end

@implementation ChillHubDevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.products = [[NSMutableArray alloc] init];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FSTChillHubDevice* deviceSelected = (FSTChillHubDevice*)sender;
    if ([segue.destinationViewController isKindOfClass:[ScaleViewController class]] )
    {
        ScaleViewController* scale = (ScaleViewController*) segue.destinationViewController;
        scale.milkyWeigh = (FSTMilkyWeigh*)deviceSelected;
    }
    else if ([segue.destinationViewController isKindOfClass:[LedgeViewController class]] )
    {
        LedgeViewController* ledge = (LedgeViewController*) segue.destinationViewController;
        ledge.ledge = (FSTLedge*)deviceSelected;
    }
    else if ([segue.destinationViewController isKindOfClass:[BeerBankViewController class]] )
    {
        BeerBankViewController* bank = (BeerBankViewController*) segue.destinationViewController;
        bank.beerBank = (FSTBeerBank*)deviceSelected;
    }
}

-(void)viewWillAppear:(BOOL)animated
{

    //TODO: consider using another pattern here ...
    //putting the firebase setups stuff inside viewWillAppear
    //because prepareForSegue in the parent controller loads after
    //viewDidLoad
    //TODO: clean this up and make it more generic
    
    Firebase* ref = [self.chillhub.firebaseRef childByAppendingPath:@"milkyWeighs"];
    [ref removeAllObservers];
    [self.products removeAllObjects];
    [self.tableView reloadData];
    
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        {
                FSTMilkyWeigh* milkyWeigh = [FSTMilkyWeigh new];
                milkyWeigh.identifier = snapshot.key;
                milkyWeigh.firebaseRef = snapshot.ref;
                id rawVal = snapshot.value;
                if (rawVal != [NSNull null])
                {
//                    NSDictionary* val = rawVal;
//                    if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//                    {
                        milkyWeigh.online = YES;
//                    }
//                    else
//                    {
//                        milkyWeigh.online = NO;
//                    }
                }
                [self.products addObject:milkyWeigh];
                [self.tableView reloadData];
        }
        
    }];
    
    [ref observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        for (long i=self.products.count-1; i>-1; i--)
        {
            FSTMilkyWeigh* milkyWeigh = [self.products objectAtIndex:i];
            if ([milkyWeigh.identifier isEqualToString:snapshot.key])
            {
                [self.products removeObject:milkyWeigh];
                [self.tableView reloadData];
                break;
            }
            
        }
    }];
    
//    [ref observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
//        for (long i=self.products.count-1; i>-1; i--)
//        {
//            FSTChillHubDevice *chillhubDevice = [self.products objectAtIndex:i];
//            if ([chillhubDevice.identifier isEqualToString:snapshot.key])
//            {
//                id rawVal = snapshot.value;
//                if (rawVal != [NSNull null])
//                {
//                    NSDictionary* val = rawVal;
//                    if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//                    {
//                        chillhubDevice.online = YES;
//                    }
//                    else
//                    {
//                        chillhubDevice.online = NO;
//                    }
//                    [self.tableView reloadData];
//                }
//                break;
//            }
//        }
//    }];
    
    //hack...
    
    Firebase* ledgesRef = [self.chillhub.firebaseRef childByAppendingPath:@"ledges"];
    [ledgesRef removeAllObservers];
    
    [ledgesRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        {
            FSTLedge* ledge = [FSTLedge new];
            ledge.identifier = snapshot.key;
            ledge.firebaseRef = snapshot.ref;
            id rawVal = snapshot.value;
            if (rawVal != [NSNull null])
            {
//                NSDictionary* val = rawVal;
//                if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//                {
                    ledge.online = YES;
//                }
//                else
//                {
//                    ledge.online = NO;
//                }
            }
            [self.products addObject:ledge];
            [self.tableView reloadData];
        }
        
    }];
    
    [ledgesRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        for (long i=self.products.count-1; i>-1; i--)
        {
            FSTLedge* ledge = [self.products objectAtIndex:i];
            if ([ledge.identifier isEqualToString:snapshot.key])
            {
                [self.products removeObject:ledge];
                [self.tableView reloadData];
                break;
            }
            
        }
    }];
    
//    [ledgesRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
//        for (long i=self.products.count-1; i>-1; i--)
//        {
//            FSTChillHubDevice *chillhubDevice = [self.products objectAtIndex:i];
//            if ([chillhubDevice.identifier isEqualToString:snapshot.key])
//            {
//                id rawVal = snapshot.value;
//                if (rawVal != [NSNull null])
//                {
//                    NSDictionary* val = rawVal;
//                    if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//                    {
//                        chillhubDevice.online = YES;
//                    }
//                    else
//                    {
//                        chillhubDevice.online = NO;
//                    }
//                    [self.tableView reloadData];
//                }
//                break;
//            }
//        }
//    }];

    //more hack....
    
    Firebase* beerBankRef = [self.chillhub.firebaseRef childByAppendingPath:@"beerbanks"];
    [beerBankRef removeAllObservers];
    
    [beerBankRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        {
            FSTBeerBank* bank = [FSTBeerBank new];
            bank.identifier = snapshot.key;
            bank.firebaseRef = snapshot.ref;
            id rawVal = snapshot.value;
            if (rawVal != [NSNull null])
            {
//                NSDictionary* val = rawVal;
//                if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//                {
                    bank.online = YES;
//                }
//                else
//                {
//                    bank.online = NO;
//                }
            }
            [self.products addObject:bank];
            [self.tableView reloadData];
        }
        
    }];
    
    [beerBankRef observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        for (long i=self.products.count-1; i>-1; i--)
        {
            FSTBeerBank* bank = [self.products objectAtIndex:i];
            if ([bank.identifier isEqualToString:snapshot.key])
            {
                [self.products removeObject:bank];
                [self.tableView reloadData];
                break;
            }
            
        }
    }];
    
//    [beerBankRef observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
//        for (long i=self.products.count-1; i>-1; i--)
//        {
//            FSTChillHubDevice *chillhubDevice = [self.products objectAtIndex:i];
//            if ([chillhubDevice.identifier isEqualToString:snapshot.key])
//            {
//                id rawVal = snapshot.value;
//                if (rawVal != [NSNull null])
//                {
//                    NSDictionary* val = rawVal;
//                    if ( [(NSString*)[val objectForKey:@"status"] isEqualToString:@"connected"] )
//                    {
//                        chillhubDevice.online = YES;
//                    }
//                    else
//                    {
//                        chillhubDevice.online = NO;
//                    }
//                    [self.tableView reloadData];
//                }
//                break;
//            }
//        }
//    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSTProduct * product = self.products[indexPath.row];
    ChillHubDeviceTableViewCell *productCell;
    
    if ( [product isKindOfClass:[FSTMilkyWeigh class]])
    {
        productCell = [tableView dequeueReusableCellWithIdentifier:@"milkyWeighCell" forIndexPath:indexPath];
    }
    else if ([product isKindOfClass:[FSTLedge class]])
    {
        productCell = [tableView dequeueReusableCellWithIdentifier:@"ledgeCell" forIndexPath:indexPath];
    }
    else if ([product isKindOfClass:[FSTBeerBank class]])
    {
        productCell = [tableView dequeueReusableCellWithIdentifier:@"beerBankCell" forIndexPath:indexPath];
    }

    productCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (product.online)
    {
        productCell.userInteractionEnabled = YES;
        productCell.disabledView.hidden = YES;
        productCell.detailsButton.hidden = NO;
    }
    else
    {
        productCell.userInteractionEnabled = NO;
        productCell.disabledView.hidden = NO;
        productCell.detailsButton.hidden = YES;
    }
    
    return productCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FSTChillHubDevice * product = self.products[indexPath.row];
    NSLog(@"selected %@", product.identifier);
    
    if ([product isKindOfClass:[FSTMilkyWeigh class]])
    {
        [self performSegueWithIdentifier:@"segueMilkyWeigh" sender:product];
    }
    else if ([product isKindOfClass:[FSTLedge class]])
    {
        [self performSegueWithIdentifier:@"segueLedge" sender:product];
    }
    else if ([product isKindOfClass:[FSTBeerBank class]])
    {
        [self performSegueWithIdentifier:@"segueBeerBank" sender:product];
    }
}


@end

#endif
