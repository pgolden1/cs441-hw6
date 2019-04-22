//
//  NewSSVc.h
//  
//
//  Created by Peter Golden on 4/18/19.
//

#ifndef NewSSVc_h
#define NewSSVc_h

#import <UIKit/UIKit.h>

@interface NewSSVc : UIViewController

@property NSString *username;

@property (weak, nonatomic) IBOutlet UITextField *location;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UILabel *maxStudents;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end

#endif /* NewSSVc_h */
