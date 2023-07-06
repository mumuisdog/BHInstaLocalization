#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <rootless.h>

// Create bundle for localizations
NSBundle *BHInstaLocalizationBundle() {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"BHInstaLocalization" ofType:@"bundle"];
        if (tweakBundlePath)
            bundle = [NSBundle bundleWithPath:tweakBundlePath];
        else
            bundle = [NSBundle bundleWithPath:ROOT_PATH_NS("/Library/Application Support/BHInstaLocalization.bundle")];
    });
    return bundle;
}

// Translate (change) existing text with new one directly in .strings file
%hook UILabel
- (void)setText:(NSString *)text {
    NSBundle *tweakBundle = BHInstaLocalizationBundle();
    NSString *localizedText = [tweakBundle localizedStringForKey:text value:nil table:nil];

    if (localizedText && ![localizedText isEqualToString:text]) {
        %orig(localizedText);
    } else {
        %orig;
    }
}
%end

// Fix option labels to fit in line
@interface BHSwitchTableCell : UITableViewCell
@end

%hook BHSwitchTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = %orig(style, reuseIdentifier);
    if (self) {
        self.textLabel.adjustsFontSizeToFitWidth = YES;
    } return self;
}
%end