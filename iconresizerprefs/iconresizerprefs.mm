#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>

@interface iconresizerprefsListController: PSListController <UIAlertViewDelegate> {
}
-(void)respring;
-(void)resetAndRespring;
@end

#define RESPRING_ALERT_TAG 1
#define RESET_ALERT_TAG 2

@implementation iconresizerprefsListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"iconresizerprefs" target:self] retain];
	}
	return _specifiers;
}

-(void)respring {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Respring"
                                                    message:@"Are you sure you want to respring?"
                                                   delegate:self     
                                          cancelButtonTitle:@"No" 
                                          otherButtonTitles:@"Yes", nil];
    alert.tag = RESPRING_ALERT_TAG;
    [alert show];
    [alert release];
}

-(void)resetAndRespring {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset"
                                                    message:@"Are you sure you want to reset preferences and respring?"
                                                   delegate:self     
                                          cancelButtonTitle:@"No" 
                                          otherButtonTitles:@"Yes", nil];
    alert.tag = RESET_ALERT_TAG;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // Clicked Yes
        if (alertView.tag == RESPRING_ALERT_TAG) { // Respring
			system("killall -9 SpringBoard");
        } else if (alertView.tag == RESET_ALERT_TAG) { // Reset and respring
			[[NSFileManager defaultManager] removeItemAtPath:@"/private/var/mobile/Library/Preferences/com.evilgoldfish.iconresizer.plist" error:nil];
	
			NSMutableDictionary *prefdict = [[NSMutableDictionary alloc] init];
			[prefdict setObject:[NSNumber numberWithBool:YES] forKey:@"enabled"];
			[prefdict writeToFile:@"/private/var/mobile/Library/Preferences/com.evilgoldfish.iconresizer.plist" atomically:YES];
			[prefdict release];
	
			system("killall -9 SpringBoard");
        }
    }
}

@end

// vim:ft=objc
