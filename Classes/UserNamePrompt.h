//
//  UserNamePrompt.h
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 12/11/11.
//  Copyright (c) 2011 InsanePlatypusGames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNamePrompt :  UIAlertView
{
    UITextField *textField;
}
@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;
@end
