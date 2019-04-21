//
//  CreateAccountVc.m
//  
//
//  Created by Peter Golden on 4/18/19.
//

#import <Foundation/Foundation.h>

#import "CreateAccountVc.h"


@implementation CreateAccountVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)attemptCreateAccount:(UIButton *)sender {
    NSLog(@"attempting to create account");
    
    NSLog(@"first: %@, last: %@, email: %@", self.first.text, self.last.text, self.email.text);
}

@end
