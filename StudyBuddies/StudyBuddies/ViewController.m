//
//  ViewController.m
//  StudyBuddies
//
//  Created by Peter Golden on 4/9/19.
//  Copyright © 2019 Peter Golden. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)rotateCurrentBlockLeft:(UIButton *)sender {
    NSLog(@"Calling rotate left");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://www.sth.com/action/verify.php"]];

}


@end
