//
//  CreateAccountVc.h
//  
//
//  Created by Peter Golden on 4/18/19.
//

#ifndef CreateAccountVc_h
#define CreateAccountVc_h

#import <UIKit/UIKit.h>

@interface CreateAccountVc : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repassword;

@property (weak, nonatomic) IBOutlet UITextField *first;
@property (weak, nonatomic) IBOutlet UITextField *last;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

#endif /* CreateAccountVc_h */
