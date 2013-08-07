//
//  SampleViewController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 23/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedTableViewController.h"

#define SAMPLE_FUSION_TABLE_PREFIX (@"ObjC-API_Sample_FT_")

@interface SampleViewController : GroupedTableViewController

@property (nonatomic, strong) NSString *fusionTableID;
@property (nonatomic, strong) NSString *fusionTableName;

@end
