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
@protocol SBIconViewDelegate, SBIconAccessoryView, SBIconViewObserver;

@interface SBIconView : UIView <_UISettingsKeyObserver, SBIconObserver, SBReusableView> {
	SBIcon* _icon;
	int _iconLocation;
	UIView* _currentImageView;
	SBIconImageView* _iconImageView;
	SBIconImageCrossfadeView* _crossfadeView;
	UIView<SBIconAccessoryView>* _accessoryView;
	SBCloseBoxView* _closeBox;
	SBFParallaxSettings* _closeBoxParallaxSettings;
	CGPoint _wallpaperRelativeCloseBoxCenter;
	SBIconLabelView* _labelView;
	UIView* _updatedMark;
	SBFolderIconBackgroundView* _dropGlow;
	unsigned _drawsLabel : 1;
	unsigned _isEditing : 1;
	unsigned _isPaused : 1;
	unsigned _isGrabbed : 1;
	unsigned _isOverlapping : 1;
	unsigned _refusesRecipientStatus : 1;
	unsigned _highlighted : 1;
	unsigned _launchDisabled : 1;
	unsigned _isJittering : 1;
	unsigned _allowJitter : 1;
	unsigned _touchDownInIcon : 1;
	unsigned _hideLabel : 1;
	unsigned _hideUpdatedMark;
	CGPoint _unjitterPoint;
	CGPoint _grabPoint;
	NSTimer* _longPressTimer;
	CGRect _visibleImageRect;
	id<SBIconViewDelegate> _delegate;
	id<SBIconViewObserver> _observer;
	_UILegibilitySettings* _legibilitySettings;
	float _iconImageAlpha;
	float _iconAccessoryAlpha;
	float _iconLabelAlpha;
	CGPoint _wallpaperRelativeImageCenter;
}
@property(assign, nonatomic) CGPoint wallpaperRelativeImageCenter;
@property(assign, nonatomic) BOOL isEditing;
@property(assign, nonatomic) float iconLabelAlpha;
@property(assign, nonatomic) float iconAccessoryAlpha;
@property(assign, nonatomic) float iconImageAlpha;
@property(retain, nonatomic) _UILegibilitySettings* legibilitySettings;
@property(assign, nonatomic) int location;
@property(assign, nonatomic) id<SBIconViewObserver> observer;
@property(assign, nonatomic) id<SBIconViewDelegate> delegate;
@property(retain, nonatomic) SBIcon* icon;
+(id)_jitterTransformAnimation;
+(id)_jitterPositionAnimation;
+(CGSize)maxLabelSize;
+(CGRect)_rectForLayoutMetric:(int)layoutMetric;
+(CGSize)defaultVisibleIconImageSize;
+(CGPoint)defaultIconImageCenter;
+(CGSize)defaultIconImageSize;
+(float)_labelHeight;
+(CGSize)defaultIconSize;
+(float)updatedMarkRightMargin;
+(BOOL)canShowUpdatedMark;
+(int)_defaultIconFormat;
-(void)iconLaunchEnabledDidChange:(id)iconLaunchEnabled;
-(void)iconAccessoriesDidUpdate:(id)iconAccessories;
-(BOOL)_shouldAnimatePropertyWithKey:(id)key;
-(void)_backgroundContrastDidChange:(id)_backgroundContrast;
-(void)_updateProgressAnimated:(BOOL)animated;
-(void)prepareForReuse;
-(void)settings:(id)settings changedValueForKey:(id)key;
-(BOOL)_delegateTapAllowed;
-(void)_delegateTouchEnded:(BOOL)ended;
-(UIEdgeInsets)snapshotEdgeInsets;
-(BOOL)pointInside:(CGPoint)inside withEvent:(id)event;
-(void)_closeBoxTapped;
-(BOOL)_isShowingCloseBox;
-(void)_updateCloseBoxAnimated:(BOOL)animated;
-(void)_applyEditingStateAnimated:(BOOL)animated;
-(void)setIsEditing:(BOOL)editing animated:(BOOL)animated;
-(void)setTouchDownInIcon:(BOOL)icon;
-(BOOL)isTouchDownInIcon;
-(void)touchesEnded:(id)ended withEvent:(id)event;
-(void)touchesMoved:(id)moved withEvent:(id)event;
-(void)touchesBegan:(id)began withEvent:(id)event;
-(void)touchesCancelled:(id)cancelled withEvent:(id)event;
-(void)didMoveToWindow;
-(void)cancelLongPressTimer;
-(void)longPressTimerFired;
-(void)cleanupAfterImageCrossfade;
-(void)setImageCrossfadeMorphFraction:(float)fraction totalScale:(float)scale;
-(void)setImageCrossfadeFadeFraction:(float)fraction;
-(void)prepareToCrossfadeImageWithView:(id)view maskCorners:(BOOL)corners trueCrossfade:(BOOL)crossfade anchorPoint:(CGPoint)point;
-(void)prepareToCrossfadeImageWithView:(id)view maskCorners:(BOOL)corners trueCrossfade:(BOOL)crossfade;
-(id)dropGlow;
-(void)removeDropGlow;
-(void)showDropGlow:(BOOL)glow;
-(void)prepareDropGlow;
-(void)setIsOverlapping:(BOOL)overlapping;
-(BOOL)isGrabbed;
-(void)setIsGrabbed:(BOOL)grabbed;
-(double)grabDurationForEvent:(id)event;
-(BOOL)canReceiveGrabbedIcon:(id)icon;
-(void)setRefusesRecipientStatus:(BOOL)status;
-(void)setIconPosition:(CGPoint)position;
-(void)removeAllIconAnimations;
-(void)setAllowJitter:(BOOL)jitter;
-(void)_updateJitter;
-(void)_recursivelyUpdateBackdropMaskFrames;
-(void)_recursiveNotifyInteractionTintColorDidChangeForReasons:(unsigned)_recursiveNotifyInteractionTintColor;
-(id)tintColor;
-(void)setFrame:(CGRect)frame;
-(BOOL)isInDock;
-(void)setHighlighted:(BOOL)highlighted;
-(BOOL)isHighlighted;
-(BOOL)allowsTapWhileEditing;
-(void)_updateBrightness;
-(BOOL)pointMostlyInside:(CGPoint)inside withEvent:(id)event;
-(id)_automationID;
-(void)_createAccessoryViewIfNecessary;
-(void)_updateAccessoryViewWithAnimation:(BOOL)animation;
-(void)_updateIconImageViewAnimated:(BOOL)animated;
-(void)_updateUpdatedMark;
-(id)_legibilitySettingsWithStyle:(int)style primaryColor:(id)color;
-(id)_legibilitySettingsWithPrimaryColor:(id)primaryColor;
-(id)_legibilitySettingsWithParameters:(id)parameters;
-(void)_updateLabel;
-(id)_labelImageParameters;
-(void)invalidateLabelLayoutGeometry;
-(void)_updateAdaptiveColors;
-(void)setShouldRasterizeImageView:(BOOL)rasterizeImageView;
-(void)setSuppressesBlurryBackgroundChanges:(BOOL)changes;
-(id)_labelImage;
-(id)_iconImageView;
-(CGPoint)_centerForCloseBoxRelativeToVisibleImageFrame:(CGRect)visibleImageFrame;
-(CGPoint)_centerForCloseBox;
-(CGRect)_frameForAccessoryView;
-(CGRect)_frameForUpdatedMarkWithLabelFrame:(CGRect)labelFrame;
-(CGRect)_frameForLabel;
-(CGRect)_frameForVisibleImage;
-(float)_labelVerticalOffset;
-(CGRect)_frameForImageView;
-(void)layoutSubviews;
-(void)setUpdatedMarkHidden:(BOOL)hidden;
-(void)setLabelHidden:(BOOL)hidden;
-(void)_applyIconLabelAlpha:(float)alpha;
-(void)_applyIconAccessoryAlpha:(float)alpha;
-(void)_applyIconImageAlpha:(float)alpha;
-(void)setIconImageAndAccessoryAlpha:(float)alpha;
-(CGSize)iconImageVisibleSize;
-(CGPoint)iconImageCenter;
-(CGRect)iconImageFrame;
-(id)iconImageSnapshot;
-(void)swapInIcon:(id)icon;
-(void)_setIcon:(id)icon animated:(BOOL)animated;
-(void)setPaused:(BOOL)paused;
-(void)dealloc;
-(id)initWithDefaultSize;
@end

typedef struct SBIconCoordinate {
	int row;
	int col;
} SBIconCoordinate;

@protocol SBIconIndexNodeObserver <NSObject>
@end

@interface SBIconZoomAnimator : NSObject <SBIconIndexNodeObserver> {
}
@end

@class SBScaleZoomSettings, UIView, SBIconView, SBIcon;

__attribute__((visibility("hidden")))
@interface SBScaleIconZoomAnimator : SBIconZoomAnimator {
	UIEdgeInsets _iconScootch;
	float _dockStretch;
	SBIconCoordinate _dockListCenterCoordinate;
	SBIconCoordinate _mainListCenterCoordinate;
	float _naturalVisualAltitude;
	UIView* _scalingView;
	SBIcon* _targetIcon;
	float _zoomScale;
}
@property(readonly, assign, nonatomic) float zoomScale;
@property(readonly, assign, nonatomic) SBIconView* targetIconView;
@property(readonly, assign, nonatomic) SBIcon* targetIcon;
@property(retain, nonatomic) SBScaleZoomSettings* zoomSettings;
-(void)_calculateIconScootch;
-(CGPoint)_scootchForIcon:(id)icon inDock:(BOOL)dock;
-(void)_applyOuterFadeFraction:(float)fraction;
-(void)_applyZoomFraction:(float)fraction;
-(float)_zoomedVisualAltitude;
-(CGPoint)_zoomedIconCenter;
-(CGRect)_zoomedFrame;
-(void)_animateToZoomFraction:(float)zoomFraction afterDelay:(double)delay withSharedCompletion:(id)sharedCompletion;
-(unsigned)_numberOfSignificantAnimations;
-(void)_cleanupZoom;
-(void)_setZoomFraction:(float)fraction;
-(void)_prepareZoom;
-(void)dealloc;
-(id)initWithFolderController:(id)folderController targetIcon:(id)icon;
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