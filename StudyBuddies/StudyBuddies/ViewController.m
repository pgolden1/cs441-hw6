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

-(IBAction)attemptLogin:(UIButton *)sender {
    NSLog(@"attempting to login");
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",[self.username text],[self.password text], nil];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://cs.binghamton.edu/~jkunnum1/php/login.php"]] ;
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSASCIIStringEncoding error:&parseError];
            //NSLog(@"JSON result is %@", responseDictionary);
        
            NSInteger result = [[[responseDictionary valueForKey:@"result"] objectAtIndex:0] integerValue];
            
            if(result == 1)
            {
                NSLog(@"Login SUCCESS");
                NSString *message = @"Login successful!";
                [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
            }
            else
            {
                NSLog(@"Login FAILURE");
                NSString *message = @"Incorrect username and password. Try again";
                [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
            }
        }
        else
        {
            NSLog(@"Error: %ld", httpResponse.statusCode);
        }
    }];
    [dataTask resume];

}

-(void)updateDisplay:(NSString *)data {
    [self.errorMessage setText:data];
}


@end
