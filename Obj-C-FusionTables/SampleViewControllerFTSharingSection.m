//
//  SampleViewControllerStartStopTickingButtonSection.m
//  Obj-C-FusionTables
//
//  Created by Arseniy on 20/7/13.
//  Copyright (c) 2013 Arseniy Kuznetsov. All rights reserved.
//


#import "SampleViewControllerFTSharingSection.h"
#import "AppDelegate.h"
#import "AppIconsController.h"

// Defines rows in section
enum SampleViewControllerFTSharingSectionRows {
    kSampleViewControllerFTSharingRowSection = 0,
    SampleViewControllerFTSharingSectionNumRows
};

// FTable sharing states
typedef NS_ENUM (NSUInteger, FTSharingStates) {
    kFTStateIdle = 0,
    kFTStateSharing,
    kFTStateShorteningURL
};

@interface SampleViewControllerFTSharingSection ()
    @property (nonatomic, strong) NSString *sharingURL;
@end

@implementation SampleViewControllerFTSharingSection {
    FTSharingStates ftSharingRowState;
}

#pragma mark - GroupedTableSectionsController Table View Data Source
- (NSUInteger)numberOfRows {
    return SampleViewControllerFTSharingSectionNumRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView CellForRow:(NSUInteger)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.defaultCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:self.defaultCellIdentifier];
    }
    return cell;
}
- (void)configureCell:(UITableViewCell *)cell ForRow:(NSUInteger)row {
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = @"Share Fusion Table";
    
    cell.backgroundView = [[UIImageView alloc] init];
    cell.selectedBackgroundView = [[UIImageView alloc] init];
    
    ((UIImageView *)cell.backgroundView).image =
                    [AppIconsController cellGenericBtnImage][IconsControllerIconTypeNormal];
    ((UIImageView *)cell.selectedBackgroundView).image =
                    [AppIconsController cellGenericBtnImage][IconsControllerIconTypeHighlighted];
}
- (void)tableView:(UITableView *)tableView DidSelectRow:(NSInteger)row {
    [self shareFusionTableWithCompletionHandler:^{
        [self shortenURLWithCompletionHandler:^{
            [self reloadSection];
            [self showFTShareActionSheet];
        }];
    }];
}
- (void)shareFusionTableWithCompletionHandler:(void_completion_handler_block)completionHandler {
    ftSharingRowState = kFTStateSharing;
    [self reloadSection];
    
    [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
    [[SimpleGoogleServiceHelpers sharedInstance] setPublicSharingForFileWithID:[self ftTableID]
                                                         WithCompletionHandler:^(NSData *data, NSError *error) {
    [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
        ftSharingRowState = kFTStateIdle;
        if (error) {
            NSData *data = [[error userInfo] valueForKey:@"data"];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[SimpleGoogleServiceHelpers sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error Sharing Fusion Table: %@", str]];
        } else {
            completionHandler ();
        }
     }];
}

- (void)shortenURLWithCompletionHandler:(void_completion_handler_block)completionHandler {
    ftSharingRowState = kFTStateShorteningURL;
    [self reloadSection];
    
    [[SimpleGoogleServiceHelpers sharedInstance] incrementNetworkActivityIndicator];
    [[SimpleGoogleServiceHelpers sharedInstance] shortenURL:[self longShareURL]
                                      WithCompletionHandler:^(NSData *data, NSError *error) {
         [[SimpleGoogleServiceHelpers sharedInstance] decrementNetworkActivityIndicator];
         ftSharingRowState = kFTStateIdle;
         if (error) {
             NSData *data = [[error userInfo] valueForKey:@"data"];
             NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             [[SimpleGoogleServiceHelpers sharedInstance]
                    showAlertViewWithTitle:@"Fusion Tables Error"
                    AndText: [NSString stringWithFormat:@"Error Sharing Fusion Table: %@", str]];
         } else {
             NSDictionary *lines = [NSJSONSerialization
                                    JSONObjectWithData:data options:kNilOptions error:nil];
             NSLog(@"%@", lines);
             self.sharingURL = lines[@"id"];
             completionHandler ();
         }
     }];
}
- (NSString *)longShareURL {
    return [NSString stringWithFormat:
                @"https://www.google.com/fusiontables/embedviz?q=select+col9+from+%@&viz=MAP"
                "&h=false&lat=50.088555878607316&lng=14.429294793701292&t=1&z=15&l=col9&noCache=%@",
                [self ftTableID],
                [[SimpleGoogleServiceHelpers sharedInstance] random4DigitNumberString]];
}
#pragma mark - GroupedTableSectionsController Table View Delegate
- (NSString *)titleForFooterInSection {
    NSString *footerString = nil;
    switch (ftSharingRowState) {
        case kFTStateSharing:
            footerString = @"Sharing Fusion Table...";
            break;
        case kFTStateShorteningURL:
            footerString = @"Shortening the sharing URL...";
            break;
        default:
            break;
    }
    return footerString;
}
- (CGFloat)heightForFooterInSection {
    return 40.0f;
}
- (float)heightForRow:(NSInteger)row {
    return 50.0f;
}

#pragma mark - Sharing ActionSheets Handlers

#pragma mark Device Clipboard
#define QUICK_SHARE_TO_CLIPBOARD (@"Copy to Clipboard")
#define QUICK_SHARE_TO_EMAIL (@"Send via Email")
#define QUICK_SHARE_TO_SAFARI (@"Open in Safari")
- (void)showFTShareActionSheet {
    if (self.sharingURL) {
        UIActionSheet *quickShareActionSheet = [[UIActionSheet alloc]
                                                initWithTitle:@"Share Fusion Table"
                                                delegate:self
                                                cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                otherButtonTitles:nil];
        [quickShareActionSheet addButtonWithTitle:QUICK_SHARE_TO_EMAIL];
        [quickShareActionSheet addButtonWithTitle:QUICK_SHARE_TO_CLIPBOARD];
        [quickShareActionSheet addButtonWithTitle:QUICK_SHARE_TO_SAFARI];
        quickShareActionSheet.cancelButtonIndex = [quickShareActionSheet addButtonWithTitle:@"Cancel"];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [quickShareActionSheet showInView:appDelegate.navigationController.view ];
    }
}

#define CLIPBOARD_COPY_INFO_ACTION_SHEET_TAG 6548445
- (void)copyToDeviceCLipboard {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.sharingURL;
    
    UIActionSheet *clipboardCopyActionSheet = [[UIActionSheet alloc] initWithTitle:@"URL copied to Clipboard"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"OK"
                                                            destructiveButtonTitle:nil
                                                                 otherButtonTitles:nil];
    clipboardCopyActionSheet.tag = CLIPBOARD_COPY_INFO_ACTION_SHEET_TAG;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [clipboardCopyActionSheet showInView:appDelegate.navigationController.view ];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag != CLIPBOARD_COPY_INFO_ACTION_SHEET_TAG) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:QUICK_SHARE_TO_CLIPBOARD]) {
            [self copyToDeviceCLipboard];
        } else {
            if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:QUICK_SHARE_TO_EMAIL]) {
                [self sendViaEmail];
            } else {
                if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:QUICK_SHARE_TO_SAFARI]) {
                    [self openInSafari];
                }
            }
        }
    }
}
#undef QUICK_SHARE_TO_CLIPBOARD
#undef QUICK_SHARE_TO_EMAIL
#undef QUICK_SHARE_TO_SAFARI
#undef CLIPBOARD_COPY_ACTION_SHEET_TAG

- (void)sendViaEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        
        [mailController setMailComposeDelegate:self];
        [mailController setSubject:@"Sharing a new Fusion Table"];
        [mailController setMessageBody:[NSString stringWithFormat:@"Sharing a new Fusion Table: %@",
                                        self.sharingURL]
                                        isHTML:YES];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.navigationController presentViewController:mailController animated:YES completion:nil];
    } else {
        [[SimpleGoogleServiceHelpers sharedInstance]
            showAlertViewWithTitle:@"Email not set"
            AndText:@"To send emails from this device, please first set up an email account in the device Settings"];
    }
    
}
#pragma mark - MFMailComposeViewController
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.sharingURL]];
}

@end





/*
 cell.backgroundColor = (self.fusionTableID) ? [UIColor whiteColor] : [UIColor clearColor];
 cell.userInteractionEnabled = (self.fusionTableID) ? YES : NO;
 

 
 */