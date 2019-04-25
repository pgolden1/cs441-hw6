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

-(void)returnToPrev:(NSString *)segueName {
    [self performSegueWithIdentifier:segueName sender:self.view];
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
    
    NSString *dateRegex = @"([12][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))";
    NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dateRegex];
    
    if (![dateTest evaluateWithObject:self.date.text]) {
        NSString *message = @"Not a valid date. Try again";
        [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
        return;
    }
    
    NSString *timeRegex = @"(0[0-9]|1[0-9]|2[0-4]):([0-6][0-9]):([0-6][0-9])";
    NSPredicate *timeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", timeRegex];
    
    if (![timeTest evaluateWithObject:self.time.text]) {
        NSString *message = @"Not a valid time. Try again";
        [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
        return;
    }
    
    
    NSString *post = [NSString stringWithFormat:@"username=%@&location=%@&studyDate=%@&subject=%@&maxStudent=%@", self.username, [self.location text], [NSString stringWithFormat:@"%@ %@", [self.date text], [self.time text]], [self.subject text],[self.maxStudents text], nil];
    NSLog(@"%@", post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://cs.binghamton.edu/~jkunnum1/php/new_study.php"]] ;
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
                NSString *message = @"Session creation successful!";
                [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:message waitUntilDone:YES];
                
                [self performSelectorOnMainThread:@selector(returnToPrev:) withObject:@"unwindToCurrentSessions" waitUntilDone:YES];
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
                        message = @"Insert failed";
                        break;
                    case 3:
                        message = @"Insert into rsvp failed";
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

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    
    [self.maxStudents setText:[NSString stringWithFormat:@"%d", (int)value]];
}

@end
