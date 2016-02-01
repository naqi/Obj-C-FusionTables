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

//  FTResourceTestBase.h
//  Obj-C-FusionTables
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.

/****
    Base class for  all Obj-C-FusionTables Tests
****/

#import <XCTest/XCTest.h>

@interface FTResourceTestCaseBase : XCTestCase

#pragma mark - Helper Methods
- (void)checkGoogleConnection;
- (void)waitForSemaphore:(dispatch_semaphore_t)semaphore WithTimeout:(NSTimeInterval)timeoutInSeconds DEPRECATED_MSG_ATTRIBUTE("As of XCode 6, should use Apple Asynchronous Testing API instead");

@end
