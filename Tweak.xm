/* MINIMUM ICON SIZE IS 10px
   Should there be a maximum??
   
   TODO:
   Add HomeScreenDesigner compatibility
   --Add enable/disable toggle--
   --Make icons fit nicely--
   --Add max icon size (if needed)--
   Add folder resize
   --Add default icon size--
   --Make a PreferenceBundle--
   Add multi-select (PreferenceBundle)
   --Get rid of respring requirement after sizing icon-- (too difficult)
   --Remove unnecessary framework links--
   --Add dependency on PreferenceLoader and AppList--
   --Allow changing default icon size--
   --MOAR SETTINGS (HIGHER MAX)--
   --Fix Newsstand crash-- (another tweak was causing this issue)
   
   From reddit:
   --Add Newsstand slider /u/MC603CA--
   Correct icon position /u/WhackKids
   Correct iPad issues
   Add pinch gestures
*/

#import <SpringBoard/SpringBoard-Structs.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "substrate.h"

@protocol SBIconIndexNode <NSObject>
@end

@protocol SBReusableView <NSObject>
-(void)prepareForReuse;
@end

@protocol _UISettingsKeyObserver <NSObject>
@end

@protocol SBIconObserver <NSObject>
@end

@class NSHashTable, UIImage;

@interface SBIcon : NSObject <SBIconIndexNode>
-(id)applicationBundleID;
-(BOOL)isNewsstandApplicationIcon;
-(BOOL)isNewsstandIcon;
@end

@class SBIconLabelView, SBFParallaxSettings, SBIconImageCrossfadeView, SBIconImageView, _UILegibilitySettings, SBFolderIconBackgroundView, UIView, SBCloseBoxView, SBIcon, NSTimer;
@protocol SBIconViewDelegate, SBIconAccessoryView;

@interface SBIconView : UIView <_UISettingsKeyObserver, SBIconObserver, SBReusableView>
@property(retain, nonatomic) SBIcon* icon;
+(CGPoint)defaultIconImageCenter;
-(CGRect)_frameForVisibleImage;
-(CGRect)_frameForImageView;
-(CGSize)iconImageVisibleSize;
-(CGPoint)iconImageCenter;
-(CGRect)iconImageFrame;
@end

#define MAX_WIDTH_AND_HEIGHT 120 // Let's put this higher at some point.
#define MIN_WIDTH_AND_HEIGHT 20
#define DEFAULT_WIDTH_AND_HEIGHT 62
#define IPAD_DEFAULT_WIDTH_AND_HEIGHT 78
#define PREFERENCES_PATH @"/private/var/mobile/Library/Preferences/com.evilgoldfish.iconresizer.plist"
#define RESIZED_ICON_X 0
#define RESIZED_ICON_Y 0
#define STANDARD_ICON_X 0
#define STANDARD_ICON_Y 0

// Preference keys
#define ENABLE_SWITCH_KEY @"enabled"
#define RESIZE_SBICONVIEW_KEY @"resizesbiconview"
#define DEFAULT_SIZE_KEY @"defaultsize"
#define NEWSSTAND_SIZE_KEY @"com.apple.newsstand"

CGPoint defaultPoint = (CGPoint)[%c(SBIconView) defaultIconImageCenter];

%hook SBIconView

NSString *deviceType = [%c(UIDevice) currentDevice].model;

-(CGRect)_frameForVisibleImage {
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	int size = DEFAULT_WIDTH_AND_HEIGHT; // Default size = 62
	int defaultSize = DEFAULT_WIDTH_AND_HEIGHT;
	
	if([deviceType isEqualToString:@"iPad"]) {
		size = IPAD_DEFAULT_WIDTH_AND_HEIGHT; // iPad default size (hopefully)
		defaultSize = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
	}
    
    if (preferences && self.icon) {
    	if (![[preferences objectForKey:ENABLE_SWITCH_KEY] boolValue]) {
    		return CGRectMake(0, 0-(size-defaultSize), defaultSize, defaultSize);
    	}
        
        size = [[preferences objectForKey:(NSString *)[self.icon applicationBundleID]] intValue];
        
        if ([self.icon isNewsstandIcon]) {
    		size = [[preferences objectForKey:NEWSSTAND_SIZE_KEY] intValue];
    	}
        
        if (size < MIN_WIDTH_AND_HEIGHT)  { // Less than minimum
        	size = [[preferences objectForKey:DEFAULT_SIZE_KEY] intValue];
        	if (size < MIN_WIDTH_AND_HEIGHT) { // Still less than minimum (couldn't find default key)
        		if([deviceType isEqualToString:@"iPad"]) {
    				size = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
    			} else {
    				size = DEFAULT_WIDTH_AND_HEIGHT;
    			}
    		}
        }
    }
    
    return CGRectMake(0, 0-(size-defaultSize), size, size);
}
-(CGRect)_frameForImageView {
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	int size = DEFAULT_WIDTH_AND_HEIGHT; // Default size = 62
	int defaultSize = DEFAULT_WIDTH_AND_HEIGHT;
	
	if([deviceType isEqualToString:@"iPad"]) {
		size = IPAD_DEFAULT_WIDTH_AND_HEIGHT; // iPad default size (hopefully)
		defaultSize = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
	}
    
    if (preferences && self.icon) {
    	if (![[preferences objectForKey:ENABLE_SWITCH_KEY] boolValue]) {
    		return CGRectMake(0, 0-(size-defaultSize), defaultSize, defaultSize);
    	}
        
        size = [[preferences objectForKey:(NSString *)[self.icon applicationBundleID]] intValue];
        
        if ([self.icon isNewsstandIcon]) {
    		size = [[preferences objectForKey:NEWSSTAND_SIZE_KEY] intValue];
    	}
        
        if (size < MIN_WIDTH_AND_HEIGHT)  { // Less than minimum
        	size = [[preferences objectForKey:DEFAULT_SIZE_KEY] intValue];
        	if (size < MIN_WIDTH_AND_HEIGHT) { // Still less than minimum (couldn't find default key)
        		if([deviceType isEqualToString:@"iPad"]) {
    				size = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
    			} else {
    				size = DEFAULT_WIDTH_AND_HEIGHT;
    			}
    		}
        }
        
        // This line centres the icon and label, however it *can* cause glitches.
        if ([[preferences objectForKey:RESIZE_SBICONVIEW_KEY] boolValue] && size >= MIN_WIDTH_AND_HEIGHT)
    		[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size, size)];
    }
    
    return CGRectMake(0, 0-(size-defaultSize), size, size);
} // The origin of this rect will move the icons.

-(CGRect)iconImageFrame {
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	int size = DEFAULT_WIDTH_AND_HEIGHT; // Default size = 62
	int defaultSize = DEFAULT_WIDTH_AND_HEIGHT;
	
	if([deviceType isEqualToString:@"iPad"]) {
		size = IPAD_DEFAULT_WIDTH_AND_HEIGHT; // iPad default size (hopefully)
		defaultSize = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
	}
    
    if (preferences && self.icon) {
    	if (![[preferences objectForKey:ENABLE_SWITCH_KEY] boolValue]) {
    		return CGRectMake(0, 0-(size-defaultSize), defaultSize, defaultSize);
    	}
        
        size = [[preferences objectForKey:(NSString *)[self.icon applicationBundleID]] intValue];
        
        if ([self.icon isNewsstandIcon]) {
    		size = [[preferences objectForKey:NEWSSTAND_SIZE_KEY] intValue];
    	}
        
        if (size < MIN_WIDTH_AND_HEIGHT)  { // Less than minimum
        	size = [[preferences objectForKey:DEFAULT_SIZE_KEY] intValue];
        	if (size < MIN_WIDTH_AND_HEIGHT) { // Still less than minimum (couldn't find default key)
        		if([deviceType isEqualToString:@"iPad"]) {
    				size = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
    			} else {
    				size = DEFAULT_WIDTH_AND_HEIGHT;
    			}
    		}
        }
    }
    
    return CGRectMake(0, 0-(size-defaultSize), size, size);
}

-(CGPoint)iconImageCenter {
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	int size = DEFAULT_WIDTH_AND_HEIGHT; // Default size = 62
	int defaultSize = DEFAULT_WIDTH_AND_HEIGHT;
	
	if([deviceType isEqualToString:@"iPad"]) {
		size = IPAD_DEFAULT_WIDTH_AND_HEIGHT; // iPad default size (hopefully)
		defaultSize = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
	}
    
    if (preferences && self.icon) {
        
        size = [[preferences objectForKey:(NSString *)[self.icon applicationBundleID]] intValue];
        
        if ([self.icon isNewsstandIcon]) {
    		size = [[preferences objectForKey:NEWSSTAND_SIZE_KEY] intValue];
    	}
        
        if (size < MIN_WIDTH_AND_HEIGHT)  { // Less than minimum
        	size = [[preferences objectForKey:DEFAULT_SIZE_KEY] intValue];
        	if (size < MIN_WIDTH_AND_HEIGHT) { // Still less than minimum (couldn't find default key)
        		if([deviceType isEqualToString:@"iPad"]) {
    				size = IPAD_DEFAULT_WIDTH_AND_HEIGHT;
    			} else {
    				size = DEFAULT_WIDTH_AND_HEIGHT;
    			}
    		}
        }
    }
    
	return CGPointMake(defaultSize/2, 0-(size-(defaultSize*1.5)));
}

%end