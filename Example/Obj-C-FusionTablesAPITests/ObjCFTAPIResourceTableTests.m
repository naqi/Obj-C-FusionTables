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

//  ObjCFTAPIResourceTableTests.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
 Tests  Obj-C-FusionTables FT API Resources Base Operations
 * Fusion Table Styles: insert, list, delete
  
 Tests creating / lising / deletion of a Fusion Table Style,
 then restores the tested Google account to its initial state
 ****/

#import "FTTableResourceTestCaseBase.h"
#import "FTStyle.h"

@interface ObjCFTAPIResourceTableTests : FTTableResourceTestCaseBase

@end

@implementation ObjCFTAPIResourceTableTests

#pragma mark -  XCTestCases
- (void)testListTables {
    XCTestExpectation *listTableExpectation = [self expectationWithDescription:@"listTableExpectation"];
    [self.ftTableResource listFusionTablesWithCompletionHandler: ^(NSData *data, NSError *error) {
        if (error) {
            NSString *errorStr = [GoogleServicesHelper remoteErrorDataString:error];
            XCTFail (@"Error Fetching Fusion Tables: %@", errorStr);
        } else {
            NSDictionary *ftItems = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions error:nil];            
            NSArray *ftTableObjects = [NSMutableArray arrayWithArray:ftItems[@"items"]];
            NSLog(@"Fusion Tables: %@", ftTableObjects);
            for (NSDictionary *ftTable in ftTableObjects) {
                XCTAssertNotNil(ftTable[@"name"], @"Loaded Fusion Table Name should not be nil");
                XCTAssertNotNil(ftTable[@"tableId"], @"Loaded Fusion Table ID should not be nil");
            }
        }
        [listTableExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
