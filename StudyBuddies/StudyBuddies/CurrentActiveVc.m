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
    // replace the populating of this list with a call to the database to get the list of study sessions
    self.creditList = [NSMutableArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
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
    CGRect buttonRect = CGRectMake(210, 25, 65, 25);
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
