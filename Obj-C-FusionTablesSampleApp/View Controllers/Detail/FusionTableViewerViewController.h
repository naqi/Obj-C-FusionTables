//
//  FusionTableViewerViewController.h
//  Obj-C-FusionTables
//
//  Created by Arseniy on 31/12/14.
//  Copyright (c) 2014 Arseniy Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FusionTableViewerViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *ftDataURL;
@property (strong, nonatomic) NSString *ftMapURL;

@end
