#import <preferences/preferences.h>
@interface namedSliderIS : PSTableCell {
    UILabel *label;
    UILabel *value;
    UISlider *slider;
    NSDictionary *plist;
    NSNumberFormatter *formatter;
    id specifierWriteTo;
    UITapGestureRecognizer *valueTap;
    UIImageView *iconView;
}
@end

@implementation namedSliderIS
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3{
    plist = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.evilgoldfish.iconresizer.plist"];
    self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
    if (self) {
        specifierWriteTo = [arg3 propertyForKey:@"key"];
        CGRect frame = [self frame];
        frame.origin.x += 51;
        label = [[UILabel alloc] initWithFrame:frame];
        frame = [self frame];
        label.text = [arg3 propertyForKey:@"labelText"];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        CGRect valueFrame = CGRectMake(frame.size.width - 35,frame.size.height-20, frame.size.width, frame.size.height);
        value = [[UILabel alloc] initWithFrame:valueFrame];
        value.textColor = [UIColor grayColor];
        valueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(valueTap:)];
        [value addGestureRecognizer:valueTap];
        valueTap.delegate = self;
        valueTap.numberOfTapsRequired = 1;
        value.userInteractionEnabled = YES;
        slider = [[UISlider alloc] initWithFrame:CGRectMake(45,frame.size.height-20, frame.size.width - 90, frame.size.height)];
        slider.minimumValue = 20.f;
        slider.maximumValue = 120.f;
        if ([plist objectForKey:specifierWriteTo]){
        slider.value = [[plist objectForKey:specifierWriteTo] floatValue];
        }
        else {
            slider.value = 62.f;
        }
        [slider setContinuous:YES];
        [slider addTarget:self action:@selector(writeValue:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:0];
      
        value.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:round(slider.value *100)/100]]];

        [self addSubview:value];
        iconView = [[UIImageView alloc] initWithImage:[arg3 propertyForKey:@"icon"]];
        iconView.frame = CGRectMake(14,14,29,29);
        [self addSubview:iconView];
        
    }
    return self;
}

- (void)writeValue:(UISlider *)fromSlider {
    value.text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:round(slider.value *100)/100]]];
    
    NSString *filePath = @"/var/mobile/Library/Preferences/com.evilgoldfish.iconresizer.plist";
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [userData setObject:[NSNumber numberWithFloat:slider.value] forKey:specifierWriteTo];
    [userData writeToFile:filePath atomically:YES];
    [filePath release];
    [userData release];
    filePath = nil;
    userData = nil;
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.evilgoldfish.iconresizer.settingschanged", NULL, NULL, TRUE);
    
}

- (void)valueTap:(UITapGestureRecognizer *)recognizer {
    UIAlertView *tappedAlert = [[UIAlertView alloc] initWithTitle:label.text message:@"Please enter a number between 20 and 120." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];
   tappedAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [tappedAlert show];
    [[tappedAlert textFieldAtIndex:0] resignFirstResponder];
    [[tappedAlert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
    [[tappedAlert textFieldAtIndex:0] becomeFirstResponder];
    [tappedAlert release];
    tappedAlert = nil;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([[alertView textFieldAtIndex:0].text floatValue] <= 120 && [[alertView textFieldAtIndex:0].text floatValue] >= 20) {
        slider.value = [[alertView textFieldAtIndex:0].text floatValue];
        [self writeValue:slider];
        }
            else {
                UIAlertView *invalidValue = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Numbers must be between 20 and 120" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [invalidValue show];
                [invalidValue release];
                invalidValue = nil;
            }
    }
}
- (void)dealloc {
    
    [iconView release];
    iconView = nil;
    
    [label release];
    label = nil;
    
    [value release];
    value = nil;

    [slider release];
    slider = nil;

    [formatter release];
    formatter = nil;

    [valueTap release];
    valueTap = nil;
    [super dealloc];
}
@end