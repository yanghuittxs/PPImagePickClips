//
//  ViewController.m
//  PPImagePickClips
//
//  Created by Young on 2020/2/25.
//  Copyright © 2020 Young. All rights reserved.
//

#import "ViewController.h"

#import "PPImageClipsContentView.h"

@interface ViewController ()
@property (nonatomic, strong) PPImageClipsContentView   *contentView;/**< zz*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView = [[PPImageClipsContentView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.contentView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end
