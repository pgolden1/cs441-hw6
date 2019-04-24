//
//  CurrentActiveVc.h
//  
//
//  Created by Peter Golden on 4/18/19.
//

#ifndef CurrentActiveVc_h
#define CurrentActiveVc_h

#import <UIKit/UIKit.h>

@interface CurrentActiveVc : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString *username;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *creditList;

@end

#endif /* CurrentActiveVc_h */
