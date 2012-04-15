//
//  UserNamePrompt.m
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 12/11/11.
//  Copyright (c) 2011 InsanePlatypusGames. All rights reserved.
//

#import "UserNamePrompt.h"
#import "LocationController.h"

@implementation UserNamePrompt
@synthesize textField;
@synthesize enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{

    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil])
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
        //CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
        //[self setTransform:translate];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonTitle])
    {
        NSString *entered = [(UserNamePrompt *)alertView enteredText];
        // Get the shared defaults object.  
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];  
        
        // Save the index.  
        [settings setValue:entered forKey:@"userName"];  
        
        CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager startUpdatingLocation];
       // label.text = [NSString stringWithFormat:@"You typed: %@", entered];
    }
}

- (void)show
{
    [textField becomeFirstResponder];
    [super show];
}
- (NSString *)enteredText
{
    return textField.text;
}
- (void)dealloc
{
    [textField release];
    [super dealloc];
}
@end
