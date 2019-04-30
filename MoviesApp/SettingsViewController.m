//
//  SettingsViewController.m
//  MoviesApp
//
//  Created by Praneeth,on 20/4/19.
//  Copyright © 2019 Praneeth Goli. All rights reserved.
//

#import "SettingsViewController.h"
#import "KeyChainWrapper.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize apiKeyTextBox;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * apiKey = [[KeyChainWrapper sharedInstance] get:@"API_KEY"];
    [self santizeApiKey:apiKey];

}

-(void) santizeApiKey:(NSString*)apiKey
{
    if(apiKey != nil && apiKey.length > 4)
    {
        NSString * keyToShow = [NSString stringWithFormat:@"%@************",[apiKey substringToIndex:4]];
        apiKeyTextBox.text = keyToShow;
    }
}

- (IBAction)saveKey:(id)sender {
    
    NSString * title= @"Error";
    NSString * message= @"";

    if(apiKeyTextBox.text.length < 4)
    {
        message = @"Invalid API Key length. Minimum length 4";
    }
   else
   {
       BOOL status =  [[KeyChainWrapper sharedInstance] insertOrUpdate:@"API_KEY" value:apiKeyTextBox.text];
       if(status == TRUE)
       {
           title = @"Info";
           message = @"Successfully saved";
           [self santizeApiKey:apiKeyTextBox.text];
       }
       else{
           message= @"Failed to Save API Key";
       }
   }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
