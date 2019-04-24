//
//  LoggedInVc.m
//  StudyBuddies
//
//  Created by Peter Golden on 4/18/19.
//  Copyright © 2019 Peter Golden. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoggedInVc.h"
#import "CurrentActiveVc.h"


@implementation LoggedInVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username_label.text = self.username;
}

- (IBAction)unwindToLoggedInViewController:(UIStoryboardSegue *)unwindSegue
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CurrentActiveVc *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"gotoCurrentActive"]) {
        vc.username = self.username;
    }
}

@end
