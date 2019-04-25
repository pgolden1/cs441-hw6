//
//  CurrentActiveVc.m
//  
//
//  Created by Peter Golden on 4/18/19.
//

#import <Foundation/Foundation.h>

#import "CurrentActiveVc.h"
#import "NewSSVc.h"


@implementation CurrentActiveVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.creditList = [[NSMutableArray alloc] initWithCapacity:8];
    self.sessionIDs = [[NSMutableArray alloc] initWithCapacity:8];
    [self getActiveSessions];
}

- (void)getActiveSessions {
    NSLog(@"in getactivesessions");
    [self.creditList removeAllObjects];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://cs.binghamton.edu/~jkunnum1/php/active_sessions.php"]] ;
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
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
                NSArray *items = [[responseDictionary valueForKey:@"items"] objectAtIndex:0];
                for (int i = 0; i < items.count; i++)
                {
                    NSDictionary *row = [items objectAtIndex:i];
                    NSString *stringRow = [NSString stringWithFormat:@"%@ | %@ | %@ | %@", row[@"subject"], row[@"date"], row[@"time"], row[@"location"]];
                    
                    NSNumber *value = [NSNumber numberWithInteger:[row[@"studyIDs"] integerValue]];
                    
                    [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:stringRow waitUntilDone:YES];
                    [self performSelectorOnMainThread:@selector(updateSessionID:) withObject:value waitUntilDone:YES];
                }
                
            }
            else
            {
                NSLog(@"Login FAILURE");
            }
        }
        else
        {
            NSLog(@"Error: %ld", httpResponse.statusCode);
        }
        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:NULL waitUntilDone:YES];
    }];
    [dataTask resume];
}

-(void)reloadTableView {
    [self.tableView reloadData];
}

-(void)updateDisplay:(NSString *)data {
    [self.creditList addObject:data];
}

-(void)updateSessionID:(NSNumber *)sessionID {
    NSLog(@"adding the sessionid value: %ld", [sessionID integerValue]);
    [self.sessionIDs addObject:sessionID];
}


- (IBAction)unwindToCurrentActiveViewController:(UIStoryboardSegue *)unwindSegue
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewSSVc *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"gotoCreateStudy"]) {
        vc.username = self.username;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.creditList objectAtIndex:indexPath.row];
    
    // make button to add
    CGRect buttonRect = CGRectMake(330, 15, 40, 25);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = buttonRect;
    // set the button title here if it will always be the same
    [button setTitle:@"RSVP" forState:UIControlStateNormal];
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(myaction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    return cell;
}

- (void)myaction:(UIButton *)sender {
    NSLog(@"button click on %ld and studySessionID is %ld",sender.tag, [[self.sessionIDs objectAtIndex:sender.tag] integerValue]);
    
    NSString *post = [NSString stringWithFormat:@"studyID=%ld&username=%@", [[self.sessionIDs objectAtIndex:sender.tag] integerValue], self.username, nil];
    NSLog(@"%@", post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://cs.binghamton.edu/~jkunnum1/php/rsvp.php"]] ;
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
                NSString *message = @"Successfully RSVPed!";
                [self performSelectorOnMainThread:@selector(showMessage:) withObject:message waitUntilDone:YES];
                
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
                        message = @"You are already RSVPed!";
                        break;
                    case 4:
                        message = @"Insert failed";
                        break;
                    default:
                        message = @"";
                        break;
                }
                NSLog(@"%@", message);
                [self performSelectorOnMainThread:@selector(showMessage:) withObject:message waitUntilDone:YES];
            }
        }
        else
        {
            NSLog(@"Error: %ld", httpResponse.statusCode);
        }
    }];
    [dataTask resume];
    
}

-(void)showMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"RSVP"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.creditList.count;
}

@end
