//
//  BIZExpandingTextView.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/15/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


// * TextView that have size as it's content size
// * It changes dynamicaly while text is inputed
@interface BIZExpandingTextView : UITextView

@property (nonatomic) BOOL enableCharCount;
@property (nonatomic, strong) UILabel *charCountLabel;
@property (nonatomic) CGFloat charCountLabelInsetHorizontal;
@end
