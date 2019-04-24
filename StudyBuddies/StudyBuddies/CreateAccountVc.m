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
}

-(void)updateDisplay:(NSString *)data {
    [self.errorMessage setText:data];
}

-(void)returnToPrev:(NSString *)segueName {
    [self performSegueWithIdentifier:segueName sender:self.view];
}

-(IBAction)attemptCreateAccount:(UIButton *)sender {
    NSLog(@"attempting to create account");
    
    if ((!self.first.text || self.first.text.length == 0) ||
        (!self.last.text || self.last.text.length == 0) ||
        (!self.email.text || self.email.text.length == 0) ||
        (!self.username.text || self.username.text.length == 0) ||
        (!self.password.text || self.password.text.length == 0) ||
        (!self.repassword.text || self.repassword.text.length == 0)) {
        NSString *message = @"Empty fields not allow. Try again";
        [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
        return;
    }
    
    if (self.password.text != self.repassword.text) {
        NSString *message = @"Passwords do not match. Try again";
        [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
        return;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:self.email.text]) {
        NSString *message = @"Not a valid email address. Try again";
        [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
        return;
    }
    
    
    
    NSString *post = [NSString stringWithFormat:@"first=%@&last=%@&email=%@&username=%@&password=%@",[self.first text], [self.last text], [self.email text], [self.username text],[self.password text], nil];
    NSLog(@"%@", post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://cs.binghamton.edu/~jkunnum1/php/new_account.php"]] ;
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
            NSLog(@"JSON result is %@", responseDictionary);
            
            NSInteger result = [[[responseDictionary valueForKey:@"result"] objectAtIndex:0] integerValue];
            
            if(result == 1)
            {
                NSLog(@"Login SUCCESS");
                NSString *message = @"Login successful!";
                [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];

                [self performSelectorOnMainThread:@selector(returnToPrev:) withObject:@"unwindToMain" waitUntilDone:YES];
            }
            else
            {
                NSLog(@"Login FAILURE");
                NSInteger error_num = [[[responseDictionary valueForKey:@"error"] objectAtIndex:0] integerValue];
                NSLog(@"error: %ld", error_num);
                NSString *message;
                switch (error_num) {
                    case 1:
                        message = @"Connection failed";
                        break;
                    case 2:
                        message = @"Select query failed";
                        break;
                    case 3:
                        message = @"Username already exist";
                        break;
                    case 4:
                        message = @"Insert failed";
                        break;
                    default:
                        message = @"";
                        break;
                }
                NSLog(@"%@", message);
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

@end
