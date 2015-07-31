#import "UILabelEx.h"

@implementation UILabelEx

- (void)setOverrideFontName:(NSString *)overrideFontName
{
    if (![_overrideFontName isEqualToString:overrideFontName])
    {
        _overrideFontName = overrideFontName;

        self.font = self.font;
    }
}

- (void)setFont:(UIFont *)font
{
    NSString *overrideFontName = self.overrideFontName;
    if (overrideFontName != nil)
    {
        font = [UIFont fontWithName:overrideFontName size:font.pointSize];
    }

    [super setFont:font];
}

@end
