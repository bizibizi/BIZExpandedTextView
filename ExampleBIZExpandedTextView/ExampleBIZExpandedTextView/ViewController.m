//
//  ViewController.m
//  ExampleBIZExpandedTextView
//
//  Created by IgorBizi@mail.ru on 12/12/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "ViewController.h"
#import "BIZExpandingTextView.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet BIZExpandingTextView *textView;
@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.enableCharCount = YES;
}

@end
