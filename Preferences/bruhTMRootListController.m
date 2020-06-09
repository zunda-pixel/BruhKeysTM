#include "bruhTMRootListController.h"

@implementation bruhTMRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)openTwitterWithUsername:(NSString*)username{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", username]] options:@{} completionHandler:nil];
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", username]] options:@{} completionHandler:nil];
    }
}

- (void)sourceLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/zunda_pixel/Choicy"] options:@{} completionHandler:nil];
}

- (void)openTwitter:(id)sender {
    [self openTwitterWithUsername:@"zunda_pixel"];
}

- (void)respring:(id)sender {
    UIViewController *view = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (view.presentedViewController != nil && !view.presentedViewController.isBeingDismissed) {
                view = view.presentedViewController;
        }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                             message:@"Do you want to respring?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        NSTask *t = [[NSTask alloc] init];
        [t setLaunchPath:@"/usr/bin/killall"];
        [t setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
        [t launch];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        //nothing
    }]];
    [view presentViewController:alertController animated:YES completion:nil];
}
@end
