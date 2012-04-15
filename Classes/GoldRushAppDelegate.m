		//
//  GoldRushAppDelegate.m
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoldRushAppDelegate.h"
#import "GoldRushViewController.h"
#import "Animal.h" 

@implementation GoldRushAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize animals; // Synthesize the animals array

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Setup some globals
	databaseName = @"DataBase2.sql";
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSLog(@"documentPaths: %@ ", documentPaths); 
	NSString *documentsDir = [[documentPaths objectAtIndex:0] retain];
	NSLog(@"documentsDir: %@ ", documentsDir);
	databasePath = [[documentsDir stringByAppendingPathComponent:databaseName] retain];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	//[self readAnimalsFromDatabase];
	

	// Set the view controller as the window's root view controller and display.
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    sleep(2);

    
    // Setup some globals
	databaseName = @"DataBase2.sql";
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSLog(@"documentPaths: %@ ", documentPaths); 
	NSString *documentsDir = [[documentPaths objectAtIndex:0]retain];
	NSLog(@"documentsDir: %@ ", documentsDir); 
	databasePath = [[documentsDir stringByAppendingPathComponent:databaseName]retain];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	//[self readAnimalsFromDatabase];
	
    
	// Configure and show the window
	[window addSubview:[viewController view]];
	[window makeKeyAndVisible];
}

-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
//	[fileManager release];
}

-(void) readAnimalsFromDatabase {
	// Setup the database object
	sqlite3 *database;
	
	// Init the animals Array
	animals = [[NSMutableArray alloc] init];
	
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from animals";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString *aLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				NSString *aCity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				NSString *aImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
				NSString *aClue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				
				// Create a new animal object with the data from the database
				//-(id)initWithType:(NSString *)t longitude:(NSString *)longit latitude:(NSString *)latit city:(NSString *)c image:(NSString *)im{
				Animal *animal = [[Animal alloc] initWithType:aType longitude:aLongitude latitude:aLatitude city:aCity image:aImage clue:aClue];
				
				// Add the animal object to the animals Array
				[animals addObject:animal];
				
				[animal release];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
}

-(void) readAnimalsFromDatabaseFromCity:(NSString *)cityLocation {
	// Setup the database object
	sqlite3 *database;
	
	// Init the animals Array
	animals = [[NSMutableArray alloc] init];
	NSLog(@"databasePath: %@ ", databasePath); 
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		//const char *sqlStatement = "select * from animals where city = ";//'" + cityLocation + "'";
		NSString *sqlStatementConcat = [NSString stringWithFormat:@"select * from animals where city = '%@'", cityLocation];
		const char *sqlStatement = [sqlStatementConcat UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString *aLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				NSString *aCity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				NSString *aImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
				NSString *aClue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                NSString *aIsCatched = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                NSString *aOwner = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                NSString *aIsCoupled = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                NSString *aGeneration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];



                
				// Create a new animal object with the data from the database
				//-(id)initWithType:(NSString *)t longitude:(NSString *)longit latitude:(NSString *)latit city:(NSString *)c image:(NSString *)im{
				//Animal *animal = [[Animal alloc] initWithType:aType longitude:aLongitude latitude:aLatitude city:aCity image:aImage clue:aClue];
				
				
                Animal *animal = [[Animal alloc] initWithType:aType longitude:aLongitude latitude:aLatitude city:aCity image:aImage clue:aClue isCoupled:(NSString *)aIsCoupled generation:(NSString *)aGeneration owner:(NSString *)aOwner isCatched:(NSString *)aIsCatched];
                
                
                
                
                // Add the animal object to the animals Array
				[animals addObject:animal];
				
				[animal release];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
}

-(void) insertNewAnimalWithType:(NSString *)animalType longitude:(NSString *)animalLongitude  latitude:(NSString *)animalLatitude  city:(NSString *)animalCity  image:(NSString *)animalImage  clue:(NSString *)animalClue isCatched:(NSString *)animalIsCatched owner:(NSString *)animalOwner isCoupled:(NSString *)animalIsCoupled generation:(NSString *)animalGeneration {
    
    // Setup the database object
	sqlite3 *database;
	
	// Init the animals Array
	animals = [[NSMutableArray alloc] init];
	NSLog(@"databasePath: %@ ", databasePath); 
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		//const char *sqlStatement = "select * from animals where city = ";//'" + cityLocation + "'";
		//NSString *sqlStatementConcat = [NSString stringWithFormat:@"select * from animals where city = '%@'", cityLocation];
        NSString *sqlStatementConcat = [NSString stringWithFormat:@"INSERT INTO animals(type, longitude, latitude, city, image, clue, isCatched, owner, isCoupled, generation) VALUES('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", animalType, animalLongitude, animalLatitude, animalCity, animalImage, animalClue, animalIsCatched, animalOwner, animalIsCoupled, animalGeneration];
		const char *sqlStatement = [sqlStatementConcat UTF8String];
        //const char *sqlStatement = [sqlStatementConcat cStringUsingEncoding:NSASCIIStringEncoding];
       // const char *sqlStatement = [sqlStatementConcat cStringUsingEncoding:[NSString defaultCStringEncoding]];

        NSLog(@"sqlStatementConcat: %@ ", sqlStatementConcat);
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            NSLog(@"INSERT OK"); 
			// Loop through the results and add them to the feeds array
			/*while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aLongitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString *aLatitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				NSString *aCity = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				NSString *aImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
				NSString *aClue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                
				// Create a new animal object with the data from the database
				//-(id)initWithType:(NSString *)t longitude:(NSString *)longit latitude:(NSString *)latit city:(NSString *)c image:(NSString *)im{
				Animal *animal = [[Animal alloc] initWithType:aType longitude:aLongitude latitude:aLatitude city:aCity image:aImage clue:aClue];
				
				// Add the animal object to the animals Array
				[animals addObject:animal];
				
				[animal release];
			}*/
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[animals release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
