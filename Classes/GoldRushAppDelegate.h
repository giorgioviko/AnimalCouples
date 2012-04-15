//
//  GoldRushAppDelegate.h
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h> 

@class GoldRushViewController;

@interface GoldRushAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GoldRushViewController *viewController;
	
	// Database variables
	NSString *databaseName;
	NSString *databasePath;
	// Array to store the animal objects
	NSMutableArray *animals;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GoldRushViewController *viewController;
@property (nonatomic, retain) NSMutableArray *animals;


@end

