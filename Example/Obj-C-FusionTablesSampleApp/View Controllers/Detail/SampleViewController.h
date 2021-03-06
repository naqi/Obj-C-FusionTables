/* Copyright (c) 2013 Arseniy Kuznetsov
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//  SampleViewController.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Shows usage of Obj-C-FusionTables for 
    setting Fusion Table Map Styles and Templates, as well as for base Fusion Tables rows ops.
    For the sake data safety, changes are allowed only for Fusion Tables created in this app.
 
    SampleViewController is using GroupedUITableViews (https://github.com/akpw/GroupedUITableViews),
    isolating the logic of Fusion Table ops in small dedicated UITableView sections controller classes.
****/

#import <UIKit/UIKit.h>
#import "GroupedTableViewController.h"

#define SAMPLE_FUSION_TABLE_PREFIX (@"ObjC-API_Sample_FT_")
#define START_FT_SHARING_NOTIFICATION (@"StartFTSharingNotification")

@interface SampleViewController : GroupedTableViewController

@property (nonatomic, strong) NSString *fusionTableID;
@property (nonatomic, strong) NSString *fusionTableName;

@end
