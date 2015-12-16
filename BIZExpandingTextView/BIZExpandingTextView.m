//
//  BIZExpandingTextView.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/15/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "BIZExpandingTextView.h"


static NSString * kContentSizeKey = @"contentSize";


@interface BIZExpandingTextView ()
@property (nonatomic) CGFloat charCountLabelHeight;
@end


@implementation BIZExpandingTextView


#pragma mark - LifeCycle


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    //Defaults
    self.enableCharCount = YES;
    self.charCountLabelInsetHorizontal = 10;

    [self addObserver:self forKeyPath:kContentSizeKey options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // * Stop changing text offset/scrolling to top/jumping then text changed
    self.contentOffset = CGPointMake(0, 0);
    
    if (self.enableCharCount) {
        [self updateCharCountLabelFrame];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:kContentSizeKey];
}


#pragma makr - Getters/Setters


- (CGSize)intrinsicContentSize
{
    
    return self.contentSize;
}


#pragma mark - Events


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kContentSizeKey])
    {
        // * Update frame for new ContentSize
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        CGRect frame = self.frame;
        frame.size = size;
        frame.size.height = [self intrinsicContentSize].height + self.charCountLabelHeight;
        self.frame = frame;
        
        // * This will updates Intrinsic size of TextView recalling -()intrinsicContentSize method
        [self invalidateIntrinsicContentSize];
    }
}


#pragma makr - Char Count


- (void)setEnableCharCount:(BOOL)enableCharCount
{
    _enableCharCount = enableCharCount;
    
    if (enableCharCount) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        
        if (!self.charCountLabel) {
            self.charCountLabel = [[UILabel alloc] init];
            self.charCountLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:self.charCountLabel];
        }
        
        [self updateCharCount];
        
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
        [self.charCountLabel removeFromSuperview];
        self.charCountLabel = nil;
    }
    
    [self setNeedsLayout];
}

- (void)updateCharCount
{
    self.charCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.text.length];
    [self updateCharCountLabelFrame];
    [self setNeedsLayout];
}

- (void)updateCharCountLabelFrame
{
    CGFloat w = self.bounds.size.width - self.charCountLabelInsetHorizontal * 2;
    CGSize textSize = { w, CGFLOAT_MAX };
    self.charCountLabelHeight = [self.charCountLabel.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.charCountLabel.font } context:nil].size.height + 1.0;
    CGFloat y = self.bounds.size.height - self.charCountLabelHeight;
    self.charCountLabel.frame = CGRectMake(10, y, w, self.charCountLabelHeight);
}

- (void)textDidChange:(NSNotification *)notification
{
    [self updateCharCount];
}

@end
