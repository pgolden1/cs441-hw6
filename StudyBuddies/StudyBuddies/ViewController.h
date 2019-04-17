//
//  ViewController.h
//  StudyBuddies
//
//  Created by Peter Golden on 4/9/19.
//  Copyright © 2019 Peter Golden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *query;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;


@end

