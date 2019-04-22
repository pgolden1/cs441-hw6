//
//  NewSSVc.m
//  
//
//  Created by Peter Golden on 4/18/19.
//

#import <Foundation/Foundation.h>

#import "NewSSVc.h"


@implementation NewSSVc

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)updateDisplay:(NSString *)data {
    [self.errorMessage setText:data];
}

-(IBAction)attemptCreateSession:(UIButton *)sender {
    NSLog(@"attempting to create study session");
    if ((!self.location.text || self.location.text.length == 0) ||
        (!self.date.text || self.date.text.length == 0) ||
        (!self.time.text || self.time.text.length == 0) ||
        (!self.subject.text || self.subject.text.length == 0) ||
        (!self.maxStudents.text || self.maxStudents.text.length == 0)) {
        NSString *message = @"Empty fields not allow. Try again";
        [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
        return;
    }
}

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    
    [self.maxStudents setText:[NSString stringWithFormat:@"%d", (int)value]];
}

@end
