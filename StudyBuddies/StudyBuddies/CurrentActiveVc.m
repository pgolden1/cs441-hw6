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
                    
                    [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:stringRow waitUntilDone:YES];
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
    button.tag = 1;
    [button addTarget:self action:@selector(myaction) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    return cell;
}

- (void)myaction {
    NSLog(@"button click");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.creditList.count;
}

@end
