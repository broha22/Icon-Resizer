#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <AppList/AppList.h>
@interface indieSlidersListController : PSListController {
    NSMutableArray *tempArray;
    NSArray *displayIdentifiers;
}
@end
@implementation indieSlidersListController

- (id)specifiers {
	if(_specifiers == nil) {
		ALApplicationList *apps = [ALApplicationList sharedApplicationList];
        displayIdentifiers = [[[apps.applications allKeys] sortedArrayUsingComparator:^(id obj1, id obj2) {
            return [[apps.applications objectForKey:obj1] caseInsensitiveCompare:[apps.applications objectForKey:obj2]];
        }] retain];
        tempArray = [[NSMutableArray alloc] init];
        
        PSSpecifier *defaultSize = [PSSpecifier preferenceSpecifierNamed:nil target:nil set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
        [defaultSize setProperty:@"Default" forKey:@"labelText"];
        [defaultSize setProperty:NSClassFromString(@"namedSliderIS") forKey:@"cellClass"];
        [defaultSize setProperty:[NSNumber numberWithInt:65] forKey:@"height"];
        [defaultSize setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        [defaultSize setProperty:[UIImage imageWithContentsOfFile:@"/System/Library/PrivateFrameworks/MobileIcons.framework/DefaultIcon-29.png"] forKey:@"icon"];
        [defaultSize setProperty:@"" forKey:@"label"];
        [defaultSize setProperty:@"defaultsize" forKey:@"key"];
        [tempArray addObject:defaultSize];
        
        PSSpecifier *newsstand = [PSSpecifier preferenceSpecifierNamed:nil target:nil set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
        [newsstand setProperty:@"Newsstand" forKey:@"labelText"];
        [newsstand setProperty:@"" forKey:@"label"];
        [newsstand setProperty:NSClassFromString(@"namedSliderIS") forKey:@"cellClass"];
        [newsstand setProperty:[UIImage imageWithContentsOfFile:@"/System/Library/PrivateFrameworks/StoreKitUI.framework/ProductViewNewsstandBadge.png"] forKey:@"icon"];
        [newsstand setProperty:[NSNumber numberWithInt:65] forKey:@"height"];
        [newsstand setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        [newsstand setProperty:@"com.apple.newsstand" forKey:@"key"];
        [tempArray addObject:newsstand];
       NSArray *hiddenDisplayIdentifiers = [[NSArray alloc] initWithObjects:
		                            @"com.apple.AdSheet",
		                            @"com.apple.AdSheetPhone",
		                            @"com.apple.AdSheetPad",
		                            @"com.apple.DataActivation",
		                            @"com.apple.DemoApp",
		                            @"com.apple.fieldtest",
		                            @"com.apple.iosdiagnostics",
		                            @"com.apple.iphoneos.iPodOut",
		                            @"com.apple.TrustMe",
		                            @"com.apple.WebSheet",
		                            @"com.apple.springboard",
                                    @"com.apple.purplebuddy",
                                    @"com.apple.datadetectors.DDActionsService",
                                    @"com.apple.FacebookAccountMigrationDialog",
                                    @"com.apple.iad.iAdOptOut",
                                    @"com.apple.ios.StoreKitUIService",
                                    @"com.apple.TextInput.kbd",
                                    @"com.apple.MailCompositionService",
                                    @"com.apple.mobilesms.compose",
                                    @"com.apple.quicklook.quicklookd",
                                    @"com.apple.ShoeboxUIService",
                                    @"com.apple.social.remoteui.SocialUIService",
                                    @"com.apple.WebViewService",
                                    @"com.apple.gamecenter.GameCenterUIService",
									@"com.apple.appleaccount.AACredentialRecoveryDialog",
									@"com.apple.CompassCalibrationViewService",
									@"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
									@"com.apple.PassbookUIService",
									@"com.apple.uikit.PrintStatus",
									@"com.apple.Copilot",
									@"com.apple.MusicUIService",
									@"com.apple.AccountAuthenticationDialog",
									@"com.apple.MobileReplayer",
									@"com.apple.SiriViewService",
                                            @"com.apple.TencentWeiboAccountMigrationDialog",
		                            nil];
        for (id identifier in displayIdentifiers) {
            if (![hiddenDisplayIdentifiers containsObject:identifier]){
            PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:nil target:nil set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
            [specifier setProperty:[apps valueForKey:@"displayName" forDisplayIdentifier:identifier] forKey:@"labelText"];
            [specifier setProperty:NSClassFromString(@"namedSliderIS") forKey:@"cellClass"];
            [specifier setProperty:[NSNumber numberWithInt:65] forKey:@"height"];
            [specifier setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
            [specifier setProperty:identifier forKey:@"key"];
            [specifier setProperty:[apps iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:identifier] forKey:@"icon"];
            [specifier setProperty:@"" forKey:@"label"];
            [tempArray addObject:specifier];
            }
        }
        _specifiers = [[NSArray arrayWithArray:tempArray] retain];
        
        [displayIdentifiers release];
            displayIdentifiers = nil;
            [tempArray release];
            tempArray = nil;
         
	}
	return _specifiers;
}
- (void)dealloc {
    
    [super dealloc];
}
@end

// vim:ft=objc
