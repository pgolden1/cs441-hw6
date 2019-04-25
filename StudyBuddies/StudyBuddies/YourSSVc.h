//
//  YourSSVc.h
//  
//
//  Created by Peter Golden on 4/18/19.
//

#ifndef YourSSVc_h
#define YourSSVc_h

#import <UIKit/UIKit.h>

@interface YourSSVc : UIViewController

@property NSString *username;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *sessionInfo;
@property NSMutableArray *sessionIDs;

@end

#endif /* YourSSVc_h */
