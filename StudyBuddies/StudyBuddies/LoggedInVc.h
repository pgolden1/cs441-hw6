//
//  LoggedInVc.h
//  StudyBuddies
//
//  Created by Peter Golden on 4/18/19.
//  Copyright © 2019 Peter Golden. All rights reserved.
//

#ifndef LoggedInVc_h
#define LoggedInVc_h

#import <UIKit/UIKit.h>

@interface LoggedInVc : UIViewController

@property NSString *username;
@property (weak, nonatomic) IBOutlet UILabel *username_label;

@end

#endif /* LoggedInVc_h */
