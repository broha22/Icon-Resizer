#import <preferences/preferences.h>
@interface namedSliderIS : PSTableCell {
    UILabel *label;
    UILabel *value;
    UISlider *slider;
    NSDictionary *plist;
    NSNumberFormatter *formatter;
    id specifierWriteTo;
    UITapGestureRecognizer *valueTap;
}
@end
