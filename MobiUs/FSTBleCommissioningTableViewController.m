//
//  FSTBleCommissioningTableViewController.m
//  FirstBuild
//
//  Created by Myles Caley on 6/19/15.
//  Copyright (c) 2015 FirstBuild. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

#import "FSTBleCommissioningTableViewController.h"
#import "FSTBleCentralManager.h"

@interface FSTBleCommissioningTableViewController ()

@end

@implementation FSTBleCommissioningTableViewController

//array that stores the data for the table view
NSMutableArray* _devices;

//observers
NSObject* _discoveryObserver;
NSObject* _undiscoveryObserver;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _devices = [[NSMutableArray alloc]init];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //since we are using self in the block callback below we need to create a weak
    //reference so ARC can actually dealloc when the view  unload (and observers can removed in dealloc)
    __weak typeof(self) weakSelf = self;
    
    _discoveryObserver = [center addObserverForName:FSTBleCentralManagerDeviceFound
                                                   object:nil
                                                    queue:nil
                                               usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)notification.object;
        BOOL found = NO;
        
        DLog("found a peripheral and was notified in ble commissioning %@", [peripheral.identifier UUIDString]);
        
        for (CBPeripheral* p in _devices)
        {
            if ([p isEqual:peripheral])
            {
                found = YES;
                return;
            }
        }
        
        if (found==NO)
        {
            DLog("peripheral doesn't exist adding to table");
            [_devices addObject:peripheral];
            [weakSelf.tableView reloadData];
        }
        else
        {
            DLog(@"peripheral already exists in table");
        }
    }];
    
    _discoveryObserver = [center addObserverForName:FSTBleCentralManagerDeviceUnFound
                                             object:nil
                                              queue:nil
                                         usingBlock:^(NSNotification *notification)
    {
        CBPeripheral* peripheral = (CBPeripheral*)notification.object;

        [_devices removeObject:peripheral];
        DLog(@"device undiscovered %@", [peripheral.identifier UUIDString]);
        [weakSelf.tableView reloadData];
    }];
    
    
    [[FSTBleCentralManager sharedInstance] scanForDevicesWithServiceUUIDString:@"e2779da7-0a82-4be7-b754-31ed3e727253"];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:_discoveryObserver];
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
    // Return the number of rows in the section.
    return _devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bleDeviceCell" forIndexPath:indexPath];
    
    CBPeripheral* peripheral = (CBPeripheral*)(_devices[indexPath.item]);
    NSString* label = [NSString stringWithFormat:@"%@,%@", peripheral.name, [peripheral.identifier UUIDString]];
    
    cell.textLabel.text = label;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
