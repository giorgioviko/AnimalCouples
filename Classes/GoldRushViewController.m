//
//  GoldRushViewController.m
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoldRushViewController.h"
#import "GoldRushAppDelegate.h"
//#import "LocationController.h"
#import "MyLocation.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
//#import "MBProgressHUD.h"
#import "ParseAnimal.h"
#import "UserNamePrompt.h"
#import <Twitter/Twitter.h>
#import "Animal.h"

@implementation GoldRushViewController

@synthesize buttonSearch;
@synthesize reverseGeocoder;
@synthesize userNameView;
@synthesize mapView;
@synthesize userLocation;
@synthesize arrayItems;
@synthesize arrayCapturedAnimals;
@synthesize firstAnimalType;
//@synthesize buttonHideSelected;
@synthesize itemFoundView;
@synthesize itemNotFoundView;
@synthesize alertLabel;
@synthesize alertNotFoundLabel;
//@synthesize alertNotFoundLabelMeters;
@synthesize itemFoundAlertButton;
@synthesize itemNotFoundAlertButton;
@synthesize buttonAnimal0;
@synthesize viewLoadingData;
@synthesize menuItems;
@synthesize buttonPlay;
@synthesize menuView;
@synthesize tutorialTextsView;
@synthesize nextTutorialButton;
@synthesize labelForTutorials;
@synthesize lastItemFound;
@synthesize webData;
@synthesize scrollView;
@synthesize viewForTutorials;
@synthesize ipAddress;
@synthesize activityViewIndicator;
//@synthesize activityIndicator;
@synthesize hud;
@synthesize viewForTutorialTexts;
@synthesize locationManager;
@synthesize currentLocation;

#define ITEM_INTERVAL       0.002;
static NSString *const ANIMAL_DOG_MALE = @"DOG_M";
static NSString *const ANIMAL_DOG_FEMALE = @"DOG_F";
static NSString *const ANIMAL_ZEBRA_FEMALE = @"ZEBRA_F";
static NSString *const ANIMAL_ZEBRA_MALE = @"ZEBRA_M";
static NSString *const ANIMAL_CAT_MALE = @"CAT_M";
static NSString *const ANIMAL_CAT_FEMALE = @"CAT_F";
static NSString *const ANIMAL_ELEPHANT_FEMALE = @"ELEPHANT_F";
static NSString *const ANIMAL_ELEPHANT_MALE = @"ELEPHANT_M";
static NSString *const MODE = @"DEMO";  //@"PROD"

static NSString *const SERVER_URL = @"http://84.123.19.220:9999/AnimalsWebService/services/AnimalsDBManagement";
static NSString *const SERVER_URL_GETANIMALS = @"http://84.123.19.220:9999/AnimalsWebService/services/AnimalsDBManagement/getAnimalsFromCity";
static NSString *const SERVER_URL_GETANIMALSFORDEVICE = @"http://84.123.19.220:9999/AnimalsWebService/services/AnimalsDBManagement/getAnimalsForDeviceIdResponse";

static double const MAX_ITEM_DISTANCE = 40;
static int const ANIMAL_TYPES_NUMBER = 4;

//#define MAX_ITEM_DISTANCE       40;

BOOL buttonHideSelected;
BOOL cityLocated = FALSE;
BOOL comodinPushed = FALSE;
BOOL buttonMenuSelected = FALSE;
BOOL accuracyAlerted = FALSE;
BOOL connectionAlerted = FALSE;
double VALENCIA_METERSPERMILE_ZOOMIN = 0.5;
double VALENCIA_METERSPERMILE_ZOOMOUT = 3.7;
double CITY_MAP_CENTER_LONGITUDE = -0.368328;
double CITY_MAP_CENTER_LATITUDE = 39.469038;

NSString *userCity =@"";

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { 
    switch(buttonIndex) {
        case 0:
            //cancel
            //NSString *entered = [(UserNamePrompt *)alertView enteredText];
            //NSString* text = [alertView textField].text;
            NSLog(@"*** ALERT VIEW %@ ", [alertView title]); 
            if ([[alertView title] isEqualToString:@"User Name"]){
                [[alertView textField] removeFromSuperview];
                //            NSString *entered = [(UserNamePrompt *)alertView enteredText];
                NSString *entered = [alertView textField].text;
            
                
                
                if([entered isEqualToString:@""]){
                    // The first time the user inits the app, he must enter one user name
                    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"User Name" message:@"Please, enter your user name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    
                    [alert addTextFieldWithValue:@"" label:@"User name"];
                    [alert show];
                }else{
            
                    
                    // Get the shared defaults object.  
                    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];  
            
                    // Save the index.  
                    [settings setValue:entered forKey:@"userName"];  
            
                   // CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
                    /*locationManager.delegate = self;
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                    [locationManager startUpdatingLocation];*/
                   /* self.locationManager = [[[CLLocationManager alloc] init] autorelease];
                    self.locationManager.delegate = self;
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                    [self.locationManager startUpdatingLocation];
                    */
                    // label.text = [NSString stringWithFormat:@"You typed: %@", entered];

                    [userNameView setHidden:YES];
                    
                    [settings setValue:@"STEP1" forKey:@"tutorialStep"];  
                     NSLog(@"*** userName %@ ", [settings objectForKey:@"userName"]);
                  //  [self showTutorialForStep:@"STEP1"];

                    
                    
                }
            }
            break;
        case 1:
            //ok
            break;
        default:
            break;
    }
}

-(void) showTutorialForStep:(NSString *)stepName{
    
    if([stepName isEqualToString:@"STEP1"]) {
       
        [activityViewIndicator setHidden:YES];
           // Animal *animal = (Animal *)[self.arrayItems objectAtIndex:i];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = userLocation.coordinate.latitude;
                coordinate.longitude = userLocation.coordinate.longitude;
                //itemType = animal.type;
                //crime = animal.type;
                //image = animal.image;
                
                NSLog(@"ANIMAL TYPE %@", self.firstAnimalType);
 //       NSLog(@"USER CITY %@", userCity);
                //NSLog(@"ANIMAL LATITUDE %d", coordinate.latitude);
                //NSLog(@"ANIMAL LONGITUDE %d", coordinate.longitude);
  //              NSString *longitude = [[NSNumber numberWithDouble:userLocation.coordinate.longitude]stringValue];
    //            NSString *latitude = [[NSNumber numberWithDouble:userLocation.coordinate.latitude]stringValue];
      //          NSString *isCatched = @"N";
                NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
                NSString *userName = [settings objectForKey:@"userName"];
        	NSLog(@"*** FIRST ANIMAL Location: %@ ", userLocation.location); 
                //TODO
//                NSString *deviceID = @"DEVIDEID";
               // NSString *deviceID = [settings objectForKey:@"userDeviceID"];        
        
        //        NSString *userOwner = [NSString stringWithFormat:@"%@-%@", userName , deviceID];
       // [self createNewAnimalWithType:itemType longitude:longitude latitude:latitude city:userCity image:image clue:clue isCatched:isCatched userOwner:userOwner];
        
      //  [self getAnimalsFromCity:userCity];
        
        
      //  [activityViewIndicator setHidden:NO];

        //[tutorialTextsView setText:@"Hello this is about the text view, the difference in text view and the text field is that you can display large data or paragraph in text view but in text field you cant."];
       // [tutorialTextsView setHidden:NO]; 
            
        
       // [viewForTutorialTexts setHidden:NO];

        
       // UITextView *textFieldRounded = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 70)];
        //textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
        

		//tutorialTextsView.textColor = [UIColor blackColor]; //text color
		//tutorialTextsView.font = [UIFont systemFontOfSize:12.0];  //font size
		//textFieldRounded.placeholder = @"<enter text>";  //place holder
		//tutorialTextsView.backgroundColor = [UIColor cyanColor]; //background color
		//tutorialTextsView.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		//textFieldRounded.enabled = NO;
		//tutorialTextsView.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
		//tutorialTextsView.returnKeyType = UIReturnKeyDone;  // type of the return key
		
		//textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
        //textFieldRounded.text = @"YOU ARE AT TUTORIAL 1: Can you see the animal over your location? Now push the SEARCH button to catch it!";

/////        textView.text=[NSString stringWithString:[item objectForKey:@"content:encoded"]];
        NSString * texto = @"Los animales se están extinguiendo así que necesitamos emparejarlos para conseguir que procreen";
        
       //(UITextField *) [self.view viewWithTag:334].setText = texto;
        //[tutorialTextsView setText:texto];

//        tutorialTextsView.text = [NSString stringWithString: texto];
       // tutorialTextsView.text = @"Los animales se están extinguiendo así que necesitamos emparejarlos para conseguir que procreen";
       
		//[self.view addSubview:textFieldRounded];
        
 
        
         //self.tutorialTextsView.text = @"Hello this is about the text view, the difference in text view and the text field is that you can display large data or paragraph in text view but in text field you cant.";
               // MyLocation *annotation = [[[MyLocation alloc] initWithName:name address:address itemType:itemType image:image coordinate:coordinate animal:animal] autorelease];
               // [self.mapView addAnnotation:annotation];
          
       // [menuView setHidden:YES];
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
        [myButton addTarget:self action:@selector(tutorialExplanationForStep1:) forControlEvents:UIControlEventTouchUpInside];
        [myButton setTitle:@"Next" forState:UIControlStateNormal];
        [myButton setTag:333];
        [myButton setFrame:CGRectMake(50,80,50,50)];
        [self.view addSubview:myButton];
        
        [labelForTutorials setText:@"Los animales se están extinguiendo así que necesitamos emparejarlos para conseguir que procreen"];
         [viewLoadingData setHidden:YES]; 
        [viewForTutorials setHidden:NO];
        //[viewForTutorialTexts setHidden:NO];
      
         //[nextTutorialButton setHidden:NO];
        //buttonSearch.tintColor = [UIColor orangeColor];
        
        //TODO: Insert arrow targeting SEARCH BUTTON or resalt button
    }
    if([stepName isEqualToString:@"STEP2"]) {
        
        //UITextView * textFieldRounded = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 70)];
        //textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
		//tutorialTextsView.textColor = [UIColor blackColor]; //text color
		//tutorialTextsView.font = [UIFont systemFontOfSize:12.0];  //font size
		//tutorialTextsView.placeholder = @"<enter text>";  //place holder
		//tutorialTextsView.backgroundColor = [UIColor cyanColor]; //background color
		//tutorialTextsView.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		//textFieldRounded.enabled = NO;
		//tutorialTextsView.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
		//tutorialTextsView.returnKeyType = UIReturnKeyDone;  // type of the return key
		
		//textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
      /////  tutorialTextsView.text = @"Esa bola azul eres tú y esa chincheta es un animal";
        
		//[self.view addSubview:textFieldRounded];
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
        [myButton addTarget:self action:@selector(tutorialExplanationForStep2:) forControlEvents:UIControlEventTouchUpInside];
        [myButton setTitle:@"Next" forState:UIControlStateNormal];
        [myButton setTag:333];
        [myButton setFrame:CGRectMake(50,80,50,50)];
        [self.view addSubview:myButton];
        [labelForTutorials setText:@"Esa bola azul eres tú y esa chincheta es un animal"];
        [viewLoadingData setHidden:YES]; 
        [viewForTutorials setHidden:NO];
        //nextTutorialButton.hidden = FALSE;
        
    }
    
    if([stepName isEqualToString:@"STEP3"]) {
        
        //UITextView * textFieldRounded = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 70)];
        //textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
		//tutorialTextsView.textColor = [UIColor blackColor]; //text color
		//tutorialTextsView.font = [UIFont systemFontOfSize:12.0];  //font size
		//textFieldRounded.placeholder = @"<enter text>";  //place holder
		//tutorialTextsView.backgroundColor = [UIColor cyanColor]; //background color
		//tutorialTextsView.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		//textFieldRounded.enabled = NO;
		//tutorialTextsView.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
		//tutorialTextsView.returnKeyType = UIReturnKeyDone;  // type of the return key
		
		//textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
        ///////tutorialTextsView.text = @"Pulsa el botón SEARCH para capturar el animal. VAMOS!";
        
		//[self.view addSubview:textFieldRounded];
       /* UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
        [myButton addTarget:self action:@selector(tutorialExplanationForStep3:) forControlEvents:UIControlEventTouchUpInside];
        [myButton setTitle:@"OK" forState:UIControlStateNormal];
        [myButton setTag:333];
        [myButton setFrame:CGRectMake(50,80,50,50)];
        [self.view addSubview:myButton];*/
        
        
        [labelForTutorials setText:@"Pulsa el botón SEARCH para capturar el animal. VAMOS!"];
        [viewLoadingData setHidden:YES]; 
        [viewForTutorials setHidden:NO];
        //nextTutorialButton.hidden = FALSE;
        //nextTutorialButton.tintColor = [UIColor orangeColor];
        buttonSearch.tintColor = [UIColor orangeColor]; 
    }
    if([stepName isEqualToString:@"STEP4"]) {
        
        //UITextView * textFieldRounded = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, 300, 70)];
        //textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
		//tutorialTextsView.textColor = [UIColor blackColor]; //text color
		//tutorialTextsView.font = [UIFont systemFontOfSize:12.0];  //font size
		//textFieldRounded.placeholder = @"<enter text>";  //place holder
		//tutorialTextsView.backgroundColor = [UIColor cyanColor]; //background color
		//tutorialTextsView.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
		//textFieldRounded.enabled = NO;
		//tutorialTextsView.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
		//tutorialTextsView.returnKeyType = UIReturnKeyDone;  // type of the return key
		
		//textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		
        ///////tutorialTextsView.text = @"Pulsa el botón SEARCH para capturar el animal. VAMOS!";
        
		//[self.view addSubview:textFieldRounded];
        /* UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
         
         
         [myButton addTarget:self action:@selector(tutorialExplanationForStep3:) forControlEvents:UIControlEventTouchUpInside];
         [myButton setTitle:@"OK" forState:UIControlStateNormal];
         [myButton setTag:333];
         [myButton setFrame:CGRectMake(50,80,50,50)];
         [self.view addSubview:myButton];*/
        
        
        [labelForTutorials setText:@"Pulsa el botón SEARCH para capturar el animal. VAMOS!"];
        [viewLoadingData setHidden:YES]; 
        [viewForTutorials setHidden:NO];
        //nextTutorialButton.hidden = FALSE;
        //nextTutorialButton.tintColor = [UIColor orangeColor];
        buttonSearch.tintColor = [UIColor orangeColor]; 
    }

    
}


- (IBAction)tutorialExplanationForStep1:(UIButton*)sender{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

        
        
        
        
        //buttonSearch.tintColor = [UIColor clearColor];
        tutorialTextsView.hidden = YES;
                        sender.hidden = YES;
        /*for(UIView *subview in [self.view subviews]) {
         if([subview isKindOfClass:[UITextView class]]) {
         [subview removeFromSuperview];
         } else {
         // Do nothing - not a UIButton or subclass instance
         }
         }*/
        [settings setValue:@"STEP2" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP2"];

    
}


- (IBAction)tutorialExplanationForStep2:(UIButton*)sender{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    

    
    //buttonSearch.tintColor = [UIColor clearColor];
    tutorialTextsView.hidden = YES;
    
    /*for(UIView *subview in [self.view subviews]) {
     if([subview isKindOfClass:[UITextView class]]) {
     [subview removeFromSuperview];
     } else {
     // Do nothing - not a UIButton or subclass instance
     }
     }*/
    sender.hidden = YES;
    [settings setValue:@"STEP3" forKey:@"tutorialStep"];  
    [self showTutorialForStep:@"STEP3"];
    
    
}


- (IBAction)tutorialExplanationForStep3:(id)sender{
   // NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    
    
    
    
    //buttonSearch.tintColor = [UIColor clearColor];
    tutorialTextsView.hidden = YES;
   
    /*for(UIView *subview in [self.view subviews]) {
     if([subview isKindOfClass:[UITextView class]]) {
     [subview removeFromSuperview];
     } else {
     // Do nothing - not a UIButton or subclass instance
     }
     }*/
     
   // [settings setValue:@"STEP3" forKey:@"tutorialStep"];  
    //[self showTutorialForStep:@"STEP3"];
    
    
}

- (IBAction)nextTutorialExplanation:(id)sender{
    //UIButton *button = (UIButton *)[self.view viewWithTag:333];
    //[button removeFromSuperview];
    nextTutorialButton.hidden = YES;
    
    //[sender removeTarget:self action:@selector(wasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP1"]) {
        
        
        
        
        //buttonSearch.tintColor = [UIColor clearColor];
        tutorialTextsView.hidden = YES;
        
        /*for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UITextView class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }*/
        [settings setValue:@"STEP2" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP2"];
        
    }
    if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP2"]) {
        
        tutorialTextsView.hidden = YES;
        //buttonSearch.tintColor = [UIColor clearColor];
        /*for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UITextView class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }*/
        [settings setValue:@"STEP3" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP3"];
        
    }
    if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP3"]) {
        
        tutorialTextsView.hidden = YES;
        nextTutorialButton.tintColor = [UIColor clearColor];
        //buttonSearch.tintColor = [UIColor clearColor];
       /* for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UITextView class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }
        */
        [settings setValue:@"STEP4" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP4"];
        
    }
}

-(void)wasTapped:(UIButton*)sender { 
    //UIButton *button = (UIButton *)[self.view viewWithTag:333];
    //[button removeFromSuperview];
    sender.hidden = YES;
    
    [sender removeTarget:self action:@selector(wasTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP1"]) {
        
        //buttonSearch.tintColor = [UIColor clearColor];
        for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UITextView class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }
        [settings setValue:@"STEP2" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP2"];
        
    }
    if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP2"]) {
        
        //buttonSearch.tintColor = [UIColor clearColor];
        for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UITextView class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }
        [settings setValue:@"STEP3" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP3"];
        
    }
    if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP3"]) {
        
        //buttonSearch.tintColor = [UIColor clearColor];
        for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UITextView class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }
        [settings setValue:@"STEP4" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP4"];
        
    }
    
    
}


- (Animal *) canMakeACoupleWith:(Animal *) animalFound{
//    Animal *animalCoupled
    Animal* animal = [[[Animal alloc] init] autorelease];
    for(int i = 0; i < self.arrayCapturedAnimals.count; i++){
		animal = (Animal*)[self.arrayCapturedAnimals objectAtIndex:i];
        //(NSString *)[(Animal *)animalFound generation];
         NSString *animalFoundType = [[NSString alloc] initWithFormat:@"%@", animalFound.type];
        NSString *type = [[NSString alloc] initWithFormat:@"%@", [self getCoupleType:animalFoundType]];
               // NSString *animalFoundGeneration = [[NSString alloc] initWithFormat:@"%@", (NSString *)animalFound.generation];
         NSString *animalFoundGeneration = [[NSString alloc] initWithFormat:@"%@", (NSString *)[(Animal *)animalFound generation]];
        NSString *animalGeneration = [[NSString alloc] initWithFormat:@"%@", (NSString *)[(Animal *)animal generation]];
        
       // [stepName isEqualToString:@"STEP1"]
      //  if(([animal.generation isEqualToString:animalFound.generation]) && ([animal.isCoupled isEqualToString:@"N"]) && ([animal.type isEqualToString:type])){
          if(([animalGeneration isEqualToString:(NSString *)animalFoundGeneration]) && ([(NSString *)[(Animal *)animal isCoupled] isEqualToString:@"N"]) && ([animal.type isEqualToString:type])){
            break;
        }
    }
    
    return animal;
}

- (NSString *) getCoupleType:(NSString *) type{
     NSString *coupleType = [[[NSString alloc] init] autorelease];
    
    if(type == ANIMAL_DOG_MALE){
        coupleType = ANIMAL_DOG_FEMALE;
    }
    if(type == ANIMAL_DOG_MALE){
        coupleType = ANIMAL_DOG_FEMALE;
    }

    if(type == ANIMAL_ZEBRA_FEMALE){
        coupleType = ANIMAL_ZEBRA_MALE;
    }

    if(type == ANIMAL_ZEBRA_MALE){
        coupleType = ANIMAL_ZEBRA_FEMALE;
    }

    
    if(type == ANIMAL_CAT_MALE){
        coupleType = ANIMAL_CAT_FEMALE;
    }
    if(type == ANIMAL_CAT_FEMALE){
        coupleType = ANIMAL_CAT_MALE;
    }
    
    if(type == ANIMAL_ELEPHANT_FEMALE){
        coupleType = ANIMAL_ELEPHANT_MALE;
    }
    
    if(type == ANIMAL_ELEPHANT_MALE){
        coupleType = ANIMAL_ELEPHANT_FEMALE;
    }
    
           
           
    return coupleType;
}

-(void) createNewAnimalWithType:(NSString *)type longitude:(NSString *)longitude latitude:(NSString *)latitude city:(NSString *)city image:(NSString *)image clue:(NSString *)clue isCatched:(NSString *)isCatched userOwner:(NSString *)userOwner isCoupled:(NSString *)isCoupled generation:(NSString *)generation{
      
    
    if ([MODE isEqualToString:@"DEMO"]){
        //   [appDelegate insertNewAnimalWithType:@"CERDO_F" longitude:longitude latitude:latitude city:userCity image:@"android_normal.png" clue:@"AAA"]; 
        
        GoldRushAppDelegate *appDelegate = (GoldRushAppDelegate *)[[UIApplication sharedApplication] delegate];  
        [appDelegate insertNewAnimalWithType:type longitude:longitude  latitude:latitude  city:city  image:image  clue:clue isCatched:isCatched owner:userOwner isCoupled:isCoupled generation:generation];    
        
        
        // [self plotCrimePositionsFromCity:userCity];
        //    insertNewAnimalWithType:(NSString *)animalType longitude:(NSString *)animalLongitude  latitude:(NSString *)animalLatitude  city:(NSString *)animalCity  image:(NSString *)animalImage  clue:(NSString *)animalClue {
        
    }else{

        NSLog(@"ANIMAL TYPE %@", type);
        NSLog(@"ANIMAL LONG %@", longitude);
        NSLog(@"ANIMAL LAT %@", latitude);
        NSLog(@"ANIMAL CITY %@", city);
        NSLog(@"ANIMAL IMAGE %@", image);
        NSLog(@"ANIMAL CLUE %@", clue);        
        NSLog(@"ANIMAL ISCATCHED %@", isCatched);  
        NSLog(@"ANIMAL USEROWNER %@", userOwner);  
    
        NSString *soapMessage = [NSString stringWithFormat:
                                 @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dat=\"http://database.java.insaneplatypusgames.com\">"
                                 "<soapenv:Header/>"
                                 "<soapenv:Body>"
                                 "<dat:insertAnimal>"
                                 "<dat:type>%@</dat:type>"
                                 "<dat:longitude>%@</dat:longitude>"
                                 "<dat:latitude>%@</dat:latitude>"
                                 "<dat:city>%@</dat:city>"
                                 "<dat:image>%@</dat:image>"
                                 "<dat:clue>%@</dat:clue>"
                                 "<dat:isCatched>%@</dat:isCatched>"
                                 "<dat:userOwner>%@</dat:userOwner>"
                                 "<dat:isCoupled>%@</dat:isCoupled>"
                                 "<dat:generation>%@</dat:generation>"                                 
                                 "</dat:insertAnimal>"
                                 "</soapenv:Body>"
                                 "</soapenv:Envelope>",
                                 type,
                                 longitude,
                                 latitude,
                                 city,
                                 image,
                                 clue,
                                 isCatched,
                                 userOwner,
                                 isCoupled,
                                 generation];
        
        
        
        
        NSURL *url = [NSURL URLWithString:SERVER_URL];               
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
        [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
        
        [theRequest addValue: SERVER_URL_GETANIMALS forHTTPHeaderField:@"soapAction"];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPMethod:@"POST"];     
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if(theConnection) {
            self.webData = [[NSMutableData data] retain];
            
            NSLog(@"-------------- webData %@", self.webData);
        }
        else {
            NSLog(@"-------------- theConnection is NULL");
        }
    }
}
    
    
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)currentLocation{
	
    //[self.locationManager stopUpdatingLocation];
    
    //NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];  
           
    if(cityLocated==FALSE){
	userLocation = currentLocation;
	NSLog(@"*** Current User Location: %@ ", userLocation.location); 

	NSLog(@"*** HORIZONTAL ACCURACY: %f ", userLocation.location.horizontalAccuracy); 
        
        if(userLocation.location.horizontalAccuracy > 100.0 && !accuracyAlerted){

            
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Accuracy Warning" message:@"The accuracy of your location is low, this could cause problems on the search" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
            accuracyAlerted = TRUE;
        }
        
	/*MKReverseGeocoder *geocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:currentLocation.coordinate] autorelease];
	geocoder.delegate = self;
	[geocoder start];*/
		
	if(self.mapView.annotations.count <= 1){
		CLLocationCoordinate2D zoomLocation;
		zoomLocation.latitude = userLocation.coordinate.latitude;
		zoomLocation.longitude = userLocation.coordinate.longitude;
        
      //  if(userCity == @"" && cityLocated==FALSE){
  /*      if( ![userCity isEqualToString:@""]){
            [self createAnimalForStep1];
        }*/
        [self locateUser];
	}
	}
    
}

- (void) createAnimalForStep1{
    //NSString *name = @"name";
    //NSString *address = @"address";
    //NSString *itemType = @"ZEBRAH_M";
    NSString *image = @"golden.png";
    NSString *clue = @"NO_CLUE";
    NSString *isCoupled = @"N";
    NSString *generation = @"0";    
    NSString *itemType = [self randomAnimalType];
    self.firstAnimalType = itemType;
    NSString *longitude = [[NSNumber numberWithDouble:userLocation.coordinate.longitude]stringValue];
    NSString *latitude = [[NSNumber numberWithDouble:userLocation.coordinate.latitude]stringValue];
    NSString *isCatched = @"N";
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
   // NSString *userName = [settings objectForKey:@"userName"];
    NSLog(@"*** FIRST ANIMAL Location: %@ ", userLocation.location); 
    NSLog(@"*** FIRST ANIMAL longitude: %@ ", longitude); 
    NSLog(@"*** FIRST ANIMAL latitude: %@ ", latitude); 
    //TODO
   
    NSString *userOwner = @"NO_OWNER";

    [self createNewAnimalWithType:itemType longitude:longitude latitude:latitude city:userCity image:image clue:clue isCatched:isCatched userOwner:userOwner isCoupled:isCoupled generation:generation];
    
   // [self showTutorialForStep:@"STEP1"];

}

- (NSString*) randomAnimalType{
    int randomNumber = arc4random() % ANIMAL_TYPES_NUMBER;
    NSString *randomizedType = @""; 
    
    switch (randomNumber){
        case 0:
            randomizedType = ANIMAL_DOG_MALE;
            break;
        case 1:
            randomizedType = ANIMAL_DOG_FEMALE;
            break;
        case 2:
            randomizedType = ANIMAL_ZEBRA_FEMALE;
            break;
        case 3:
            randomizedType = ANIMAL_ZEBRA_MALE;
            break;    
       default:
            break;
    }

    return randomizedType;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
	// Add at start of requestFinished AND requestFailed
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	
    if (request.responseStatusCode == 400) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"ALERT" message:@"Invalid code" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
    } else if (request.responseStatusCode == 403) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"ALERT" message:@"Code already used" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
    } else if (request.responseStatusCode == 200) {
        NSString *responseString = [request responseString];
       NSLog(@"*** RESPONSE: %@ ", responseString); 
    } else {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"ALERT" message:@"Unexpected error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alert show];
    }
	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{    
	// Add at start of requestFinished AND requestFailed
	[MBProgressHUD hideHUDForView:self.view animated:YES];
    NSError *error = [request error];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"ERROR" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}




// this delegate is called when the reverseGeocoder finds a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	if(userCity == @"" && cityLocated==FALSE){
       
      
    MKPlacemark *myPlacemark = placemark;
    // with the placemark you can now retrieve the city name
    NSString *city = [myPlacemark.addressDictionary objectForKey:(NSString*) kABPersonAddressCityKey];
	NSLog(@"log *****: %@", city);
        if ([MODE isEqualToString:@"DEMO"]){
            userCity = @"LONDON";
        }else{
            userCity = [city uppercaseString];
        }
		cityLocated = TRUE;
        //userCity = city;
	NSString *stringCity = [NSString stringWithFormat:@"%@%@", @"You're at ", userCity];
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
//        if( [elementName isEqualToString:@"city"])
        if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP1"]) {
            [self createAnimalForStep1];
        }
        
        //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"CITY" message:stringCity delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	
        
        [viewLoadingData setHidden:NO];
        [activityViewIndicator startAnimating];
        [activityViewIndicator setHidden:NO];
        [self getAnimalsFromCity:userCity];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        //[alert show];
///////////	[self plotCrimePositionsFromCity:userCity];	
	}
}


-(void) getAnimalsFromCity:(NSString *) cityName{
    
    if ([MODE isEqualToString:@"DEMO"]){
        //   [appDelegate insertNewAnimalWithType:@"CERDO_F" longitude:longitude latitude:latitude city:userCity image:@"android_normal.png" clue:@"AAA"]; 
        
        GoldRushAppDelegate *appDelegate = (GoldRushAppDelegate *)[[UIApplication sharedApplication] delegate];  
        [appDelegate readAnimalsFromDatabaseFromCity:cityName];    
        
        
        // [self plotCrimePositionsFromCity:userCity];
        //    insertNewAnimalWithType:(NSString *)animalType longitude:(NSString *)animalLongitude  latitude:(NSString *)animalLatitude  city:(NSString *)animalCity  image:(NSString *)animalImage  clue:(NSString *)animalClue {

        self.arrayItems = appDelegate.animals;
        
        [self plotAnimalPositionsFromArray];
    }else{
        
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dat=\"http://database.java.insaneplatypusgames.com\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<dat:getAnimalsFromCity>"
                             "<dat:cityName>%@</dat:cityName>"
                             "</dat:getAnimalsFromCity>"
                             "</soapenv:Body>"
                             " </soapenv:Envelope>", userCity];
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];               
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    
    [theRequest addValue: SERVER_URL_GETANIMALS forHTTPHeaderField:@"soapAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection) {
        self.webData = [[NSMutableData data] retain];
        
        NSLog(@"-------------- webData %@", self.webData);
        [viewLoadingData setHidden:NO];
    }
    else {
        NSLog(@"-------------- theConnection is NULL");
    }
    }
}

-(void) getAnimalsForDevice:(NSString *) deviceId{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dat=\"http://database.java.insaneplatypusgames.com\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<dat:getAnimalsForDeviceId>"
                             "<dat:deviceId>%@</dat:deviceId>"
                             "</dat:getAnimalsForDeviceId>"
                             "</soapenv:Body>"
                             " </soapenv:Envelope>", deviceId];
    
    NSURL *url = [NSURL URLWithString:SERVER_URL];               
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    
    [theRequest addValue: SERVER_URL_GETANIMALSFORDEVICE forHTTPHeaderField:@"soapAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection) {
        self.webData = [[NSMutableData data] retain];
        
        NSLog(@"-------------- webData %@", self.webData);
        [viewLoadingData setHidden:NO];
    }
    else {
        NSLog(@"-------------- theConnection is NULL");
    }
    
}

-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response {
     NSLog(@"response *****: %@", response); 
    [webData setLength: 0];
    
}

-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
    //NSLog(@"data *****: %@", data); 
    [webData appendData:data];
 //   NSLog(@"Bytes: %d", [webData length]);
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    NSLog(@"error *****: %@", error); 
    
    
    if(error.code == kCLErrorDenied) {
        //[locationManager stopUpdatingLocation];
        [self.locationManager stopUpdatingLocation];
        NSLog(@" ***** kCLErrorDenied *****"); 

    } else if (![MODE isEqualToString:@"DEMO"]){
      
    
    
    
    [webData release];
    [connection release];
    
    
    [viewLoadingData setHidden:YES];
    [activityViewIndicator stopAnimating];    
    [activityViewIndicator setHidden:YES];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSLog(@"Current Locale: %@", [[NSLocale currentLocale] localeIdentifier]);
    NSLog(@"Current language: %@", currentLanguage);
    NSLog(@"Error Text: %@", NSLocalizedString(@"Connection_error", @""));
    
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection_error", @"") message:NSLocalizedString(@"Try_again_later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
    
    //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"\n\nConnection error" message:@"Please, try again later" delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
    
     [alert show];
    } 
   
}



-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];  
        NSString *theXML = [[NSString alloc] 
                            initWithBytes: [webData mutableBytes] 
                            length:[webData length] 
                            encoding:NSUTF8StringEncoding];
        //---shows the XML---
        //NSLog(@"XML %@", theXML);
        
    
        [theXML release];   

        ParseAnimal *pa = [[ParseAnimal alloc] init];
        arrayItems = [[NSMutableArray alloc] init];
        arrayItems = [pa parseAnimalWithData:webData];	
        
        [pa release];
        
        [connection release];
        [webData release];
        
        [self plotAnimalPositionsFromArray];

	//[self showTutorialForStep:[settings objectForKey:@"tutorialStep"]];
        [viewLoadingData setHidden:YES];
        [activityViewIndicator stopAnimating];    
        [activityViewIndicator setHidden:YES];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    [currentDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.arrayItems] forKey:@"animalsArray"];
    
    [currentDefaults synchronize];
        
    /*    
    } else{
        
    }*/
    
    
}



//---when the start of an element is found---
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI 
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    if( [elementName isEqualToString:@"city"])
    {
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        elementFound = YES;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        [soapResults appendString: string];
    }
}


- (void)plotAnimalPositionsFromArray{

	NSString *address = @"Generation 0";
	NSString *itemType = @"blah";
	NSString *image = @"";

    
	for(int i = 0; i < self.arrayItems.count; i++){
		Animal *animal = (Animal *)[self.arrayItems objectAtIndex:i];
		CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[animal latitude] doubleValue];
        coordinate.longitude = [[animal longitude] doubleValue];
		itemType = animal.type;

		image = animal.image;

        NSLog(@"ANIMAL TYPE %@", itemType);
		MyLocation *annotation = [[[MyLocation alloc] initWithName:itemType address:address itemType:itemType image:image coordinate:coordinate animal:animal] autorelease];
		[self.mapView addAnnotation:annotation];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	static NSString *identifier = @"MyLocation"; 
    
    if(comodinPushed == TRUE){
	UIImage *imageOrange = [UIImage imageNamed:@"android.png"];
    UIImage *imageGolden = [UIImage imageNamed:@"android_golden.png"];
    //UIImage *imageZebra1 = [UIImage imageNamed:@"zebra1.png"];
    UIImage *imageZebra2 = [UIImage imageNamed:@"zebra2.png"];
    UIImage *imageNormal = [UIImage imageNamed:@"android_normal.png"];

    
    if ([annotation isKindOfClass:[MyLocation class]]) {
 		
        //MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        //NSLog(@"ANNOTATION_VIEW%@", annotationView);
       // NSLog(@"ANNOTATION%@", annotation);
        if (annotationView == nil) {
            annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        } else {

            annotationView.annotation = annotation;
        }
        
       // NSLog(@"ANNOTATION_VIEW%@", annotationView.annotation);
        
        NSLog(@"ANNOTATION TYPE %@ ", [annotation itemType]);
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
				//annotationView.image = imageOrange;
		annotationView.hidden = YES;
		NSString *imName = [annotation image];
		UIImage *imageName =  [UIImage imageNamed:imName];

 		annotationView.image = imageName;
		 
        return annotationView;
    }         
		
    }else {
        
        MKPinAnnotationView *retval = nil;
        
        // Make sure we only create Pins for the Cameras. Ignore the current location annotation 
        // so it returns the 'blue dot'
        if ([annotation isMemberOfClass:[MyLocation class]]) {
            // See if we can reduce, reuse, recycle
            (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
            
            // If we have to, create a new view
            if (retval == nil) {
                retval = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
                
                // Set the button as the callout view
                //retval.leftCalloutAccessoryView = myDetailButton;
                retval.animatesDrop = YES;
                retval.canShowCallout = YES;
                
                [retval setPinColor:MKPinAnnotationColorGreen];
            }
            
            // Set a bunch of other stuff
            if (retval) {
                [retval setPinColor:MKPinAnnotationColorGreen];
                retval.animatesDrop = YES;
                retval.canShowCallout = YES;
            }
        }
        
        return retval;
    }

	
    return nil;    
}

- (void)viewForAnnotation{
/*	
       
	static NSString *identifier = @"MyLocation"; 
	static NSString *crime = @"Crime for ";
	static NSString *address = @"Addres for ";

    float lat = userLocation.location.coordinate.latitude;
	float lon = userLocation.location.coordinate.longitude;
	for (int i = 1; i<= 15; i++) {
		
		lat = lat + (i * 0.001);
		lon = lon + (i * 0.001); 
		
		MyLocation *annotation = [[[MyLocation alloc] initWithName:crime address:address coordinate:userLocation.location.coordinate] autorelease];
		[mapView addAnnotation:annotation];   
		
	}*/
}


- (IBAction) searchNearItem:(id)sender{
	
	[self locateUser];
	BOOL itemFound = FALSE;
	int idItem;
	NSString *itemType = @"";
	NSString *identifier = @"";
	/*for(int i = 0; i < arrayItems.count; i++) {
		NSMutableArray *itLocat = [arrayItems objectAtIndex:i];
		CLLocationDegrees degreeLat = [[itLocat objectAtIndex:0] doubleValue];
				CLLocationDegrees degreeLon = [[itLocat objectAtIndex:1] doubleValue];
				CLLocation *itemLocation = [[CLLocation alloc] initWithLatitude:degreeLat longitude:degreeLon];
		   double distance = ([userLocation.location distanceFromLocation:itemLocation]);

		if(distance <= 15){
			NSLog(@"LAT %f ", degreeLat);
			NSLog(@"LON %f ", degreeLon);
			NSLog(@"DIST %f ", distance);
			idItem = (int)i;
			itemFound = TRUE;
			itemType = [itLocat objectAtIndex:2];
			break;
		}
		
	}*/
	
	double nearestDistance = 500000;
	MyLocation *nextAnnotation = [[MyLocation alloc]init];
	
	
	for (int i = 0; i < [[mapView annotations] count]; i++)
	{
		nextAnnotation = [[mapView annotations]objectAtIndex: i];
		CLLocationCoordinate2D annotationCoordinate = [nextAnnotation coordinate];
		CLLocationDegrees degreeLat = annotationCoordinate.latitude;
		CLLocationDegrees degreeLon = annotationCoordinate.longitude;
		
		CLLocation *itemLocation = [[CLLocation alloc] initWithLatitude:degreeLat longitude:degreeLon];
		double distance = ([userLocation.location distanceFromLocation:itemLocation]);
		
		
		if(distance <= MAX_ITEM_DISTANCE && [nextAnnotation isKindOfClass:[MyLocation class]]){
			NSLog(@"LAT %f ", degreeLat);
			NSLog(@"LON %f ", degreeLon);
			NSLog(@"DIST %f ", distance);
			idItem = (int)i;
			itemFound = TRUE;
            identifier = [NSString stringWithFormat:@"%d", i];
            NSLog(@"IDANIMAL %@", identifier);
			[[mapView viewForAnnotation:nextAnnotation] setHidden:NO];
			
			//[[(MKAnnotationView *)nextAnnotation] setHidden:NO];
			//itemType = [itLocat objectAtIndex:2];
			break;
		} else if(distance > MAX_ITEM_DISTANCE && distance < nearestDistance){
			//NSLog(@"DIST %f ", distance);
			nearestDistance = distance;
		}
        
        [itemLocation release];

	}
	
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];  

	
	
	if(!itemFound){
		//NSString *alertString = [NSString stringWithFormat:@"%@%.0f%@", @"You are close!!! ", nearestDistance, @" meters"];
		NSString *alertString = [NSString stringWithFormat:@"%@", @"You are close!!! "];
		NSString *stringMeters = [NSString stringWithFormat:@"%.0f%@", nearestDistance, @"m"];
		
		[itemNotFoundView setHidden:NO];
		[alertNotFoundLabel setText:alertString];
	//	[alertNotFoundLabelMeters setText:stringMeters];
		[itemNotFoundAlertButton setTitle:stringMeters forState:UIControlStateNormal];
		
		//NSString *imageName2 = @"";
		//imageName2 = @"android_normal.png";
		
		//[itemNotFoundAlertButton setImage:[UIImage imageNamed:imageName2] forState:UIControlStateNormal];
		//[itemNotFoundAlertButton setHidden:YES];
		//[self.view addSubview:itemNotFoundView];
		//UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oooouch!!!" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		//UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oooouch!!!" message:@"You've found nothing! The nearest ITEM is at " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		//[alert show];
	} else{
		NSString *alertString = [NSString stringWithFormat:@"%@", @"You've found ONE ITEM!"];
		[itemFoundView setHidden:NO];
        [scrollView setHidden:NO];
		[alertLabel setText:alertString];
		/*NSString *imageName = @"";
		if(nextAnnotation.itemType == ANIMAL_DOG_MALE){
			imageName = @"android_golden.png";
		} else{
			imageName = @"android_focused.png";
		}*/
			
		NSString *imageName = nextAnnotation.image;

		
		//btnImage = [UIImage imageNamed:@"image.png"];
		[itemFoundAlertButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];


		
		
		//[self.view addSubview:itemFoundView];
		lastItemFound = nextAnnotation;
		//UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Yeeeeeeeah!!!" message:@"You've found ONE ITEM!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		//[self removeItemFromArray:itemType];
		
		//[alert show];
        
        
        
        [buttonAnimal0 setAlpha:1.0f];
        
        [self updateAnimalWithId:identifier];
        [mapView removeAnnotation: nextAnnotation];
        [self canMakeACoupleWith:nextAnnotation.animal];
        
        if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP3"]) {
             [viewForTutorials setHidden:YES];
            NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
            [settings setValue:@"STEP4" forKey:@"tutorialStep"];  
            [self showTutorialForStep:@"STEP4"];
            buttonSearch.tintColor = [UIColor blueColor]; 
        }
       

	}
    //[nextAnnotation release];
}

- (void) updateAnimalWithId:(NSString*) idAnimal{
    
    //UIDevice *device = [UIDevice currentDevice];
    //NSString *userOwner = [device uniqueIdentifier];
    NSString *userOwner = @"giorgioviko";

   // NSLog(@"IDANIMAL %@ ", idAnimal);

    NSString *soapMessage = [NSString stringWithFormat:
                             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dat=\"http://database.java.insaneplatypusgames.com\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<dat:updateAnimal>"
                             "<dat:id>%@</dat:id>"
                             "<dat:isCatched>%@</dat:isCatched>"
                             "<dat:userOwner>%@</dat:userOwner>"
                             "</dat:updateAnimal>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>", idAnimal, @"Y", userOwner];
    
    
  
    
    
    
    
    //NSURL *url = [NSURL URLWithString:@"http://172.16.0.142:8731/Service1/"];               
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.6:8080/AnimalsWebService/services/AnimalsDBManagement"];               
    NSURL *url = [NSURL URLWithString:SERVER_URL];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    //[theRequest addValue: @"http://192.168.1.6:8080/AnimalsWebService/services/AnimalsDBManagement/insertAnimal" forHTTPHeaderField:@"soapAction"];
    [theRequest addValue: SERVER_URL_GETANIMALS forHTTPHeaderField:@"soapAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection) {
        self.webData = [[NSMutableData data] retain];
        
        NSLog(@"-------------- webData %@", self.webData);
        
       
        
        //[self plotAnimalPositionsFromArray];	
    }
    else {
        NSLog(@"-------------- theConnection is NULL");
    }
    
}

- (IBAction) removeLastFoundAnnotation{
	//[mapView removeAnnotation: lastItemFound];
	[itemFoundView setHidden:YES];
    [scrollView setHidden:YES];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if([[settings objectForKey:@"tutorialStep"] isEqualToString:@"STEP3"]) {
        
        buttonSearch.tintColor = [UIColor clearColor];
        /*for(UIView *subview in [self.view subviews]) {
            if([subview isKindOfClass:[UITextField class]]) {
                [subview removeFromSuperview];
            } else {
                // Do nothing - not a UIButton or subclass instance
            }
        }
        [settings setValue:@"STEP2" forKey:@"tutorialStep"];  
        [self showTutorialForStep:@"STEP2"];*/
        
    }    
}

- (IBAction) closeNotFoundAlert{
	[itemNotFoundView setHidden:YES];
    [scrollView setHidden:YES];
}

/*
- (void) removeItemFromArray:(int)index{


	//for (int i = 0; i < [[mapView annotations] count]; i++)
	//{
		MyLocation *nextAnnotation = [[mapView annotations]objectAtIndex: index];
		
	//	if (nextAnnotation && [itemType isEqualToString:[nextAnnotation itemType]])
	//	{	
			
			NSLog([nextAnnotation address]);
			NSLog(@"%u",[nextAnnotation coordinate].longitude);
			[mapView removeAnnotation: nextAnnotation];
	//	}
	//}
	//[arrayItems removeObjectAtIndex:index];
	
}*/

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	if(buttonHideSelected == TRUE){
    NSArray *annotations = [mapView annotations];  
    MyLocation *annotation = nil; 
    for (int i=0; i<[annotations count]; i++)
    {
        annotation = [annotations objectAtIndex:i];
        if ([annotation isKindOfClass:[MyLocation class]] && (mapView.region.span.latitudeDelta > .15))
        {
            [[mapView viewForAnnotation:annotation] setHidden:YES];
        }
        else if([annotation isKindOfClass:[MyLocation class]]){
            [[mapView viewForAnnotation:annotation] setHidden:NO];
        }
    }
	}
}


- (void) removeItemFromArray:(NSString*)itemFoundType{
	
	
	for (int i = 0; i < [[mapView annotations] count]; i++)
	{
		MyLocation *nextAnnotation = [[mapView annotations]objectAtIndex: i];
		
		if (nextAnnotation && [itemFoundType isEqualToString:[nextAnnotation itemType]])
		{	
			
			NSLog([nextAnnotation itemType]);
//			NSLog(@"%u",[nextAnnotation coordinate].longitude);
			[mapView removeAnnotation: nextAnnotation];
			
			break;
		}
	}
	//[arrayItems removeObjectAtIndex:index];
	
}


-(IBAction) hideItems:(id)sender{
	NSArray *annotations = [mapView annotations]; 
	MyLocation *annotation = nil; 
	
	if(buttonHideSelected == TRUE){
		buttonHideSelected = FALSE;
		
		CLLocationCoordinate2D zoomLocation;
		zoomLocation.latitude = userLocation.coordinate.latitude;
		zoomLocation.longitude = userLocation.coordinate.longitude;
		
		
		
		
		
		MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, VALENCIA_METERSPERMILE_ZOOMIN*METERS_PER_MILE, VALENCIA_METERSPERMILE_ZOOMIN*METERS_PER_MILE);
	
		MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
	
		[self.mapView setRegion:adjustedRegion animated:YES]; 
		
		for (int i=0; i<[annotations count]; i++)
		{
			[sender setTitle:@"Show Items"];
			annotation = [annotations objectAtIndex:i];
			if ([annotation isKindOfClass:[MyLocation class]])
			{
				[[mapView viewForAnnotation:annotation] setHidden:YES];
			}
			
		}
	} else if(buttonHideSelected == FALSE){
		buttonHideSelected = TRUE;
		
		CLLocationCoordinate2D zoomLocation;
		//zoomLocation.latitude = CITY_MAP_CENTER_LATITUDE;
		//zoomLocation.longitude = CITY_MAP_CENTER_LONGITUDE;
        zoomLocation.latitude = userLocation.coordinate.latitude;
		zoomLocation.longitude = userLocation.coordinate.longitude;
		
		[sender setTitle:@"Hide Items"];
		for (int i=0; i<[annotations count]; i++)
		{
            
			annotation = [annotations objectAtIndex:i];
			// NSLog(@" %@", [annotation itemType]);
            if([annotation isKindOfClass:[MyLocation class]]){
				[[mapView viewForAnnotation:annotation] setHidden:NO];
			}
		}
		
		MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, VALENCIA_METERSPERMILE_ZOOMOUT*METERS_PER_MILE, VALENCIA_METERSPERMILE_ZOOMOUT*METERS_PER_MILE);
		
		MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
		
		[self.mapView setRegion:adjustedRegion animated:YES]; 
	
	}
	
	
	//NSArray *annotations = [mapView annotations]; 
	//MyLocation *annotation = nil; 
	if(buttonHideSelected == TRUE){
		/*buttonHideSelected = FALSE;
		 
		
		for (int i=0; i<[annotations count]; i++)
		{
		[sender setTitle:@"Show Items"];
			annotation = [annotations objectAtIndex:i];
			if ([annotation isKindOfClass:[MyLocation class]])
			{
				[[mapView viewForAnnotation:annotation] setHidden:YES];
			}
			
		}*/
	} else if(buttonHideSelected == FALSE){
		/*buttonHideSelected = TRUE;
		[sender setTitle:@"Hide Items"];
		for (int i=0; i<[annotations count]; i++)
		{
			annotation = [annotations objectAtIndex:i];
			if([annotation isKindOfClass:[MyLocation class]]){
				[[mapView viewForAnnotation:annotation] setHidden:NO];
			}
		}*/
	}
}

-(void) locateUser{
	CLLocationCoordinate2D zoomLocation;
	zoomLocation.latitude = userLocation.coordinate.latitude;
	zoomLocation.longitude = userLocation.coordinate.longitude;
	
	MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, VALENCIA_METERSPERMILE_ZOOMIN*METERS_PER_MILE, VALENCIA_METERSPERMILE_ZOOMIN*METERS_PER_MILE);
	
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
	
    [self.mapView setRegion:adjustedRegion animated:YES];        
}

-(IBAction) locateUser:(id)sender{
	[self locateUser];
	
		
}


-(IBAction) insertAnimalSon:(id)sender{
	[self locateUser];
	
    
    NSString *longitude = [[NSNumber numberWithDouble:userLocation.coordinate.longitude]stringValue];
    NSString *latitude = [[NSNumber numberWithDouble:userLocation.coordinate.latitude]stringValue];    

    
   /* int tag = [sender tag];
	NSString *audioName;
	
	switch (tag) {
		case 0:
			audioName = @"/jad0007a.wav";
			break;
		case 1:
			audioName = @"/jad0001a.wav";
			break;
		default:
			break;
	}*/
    
    NSString *animalType = @"PIG_M";
    NSString *animalCity = @"VALENCIA";    
    NSString *animalImage = @"android_normal.png";
    NSString *animalClue = @"NO_CLUE";
    
    
    
    NSString *isCoupled = @"N";
    NSString *generation = @"0";
    NSString *animalOwner = @"NO_OWNER";
    NSString *animalIsCatched = @"N";
    NSString *isCatched = @"N";
    
    
    if ([MODE isEqualToString:@"DEMO"]){
 //   [appDelegate insertNewAnimalWithType:@"CERDO_F" longitude:longitude latitude:latitude city:userCity image:@"android_normal.png" clue:@"AAA"]; 
    
      GoldRushAppDelegate *appDelegate = (GoldRushAppDelegate *)[[UIApplication sharedApplication] delegate];  
        [appDelegate insertNewAnimalWithType:animalType longitude:longitude  latitude:latitude  city:animalCity  image:animalImage  clue:animalClue isCatched:animalIsCatched owner:animalOwner isCoupled:isCoupled generation:generation];    
        
        
   // [self plotCrimePositionsFromCity:userCity];
   //    insertNewAnimalWithType:(NSString *)animalType longitude:(NSString *)animalLongitude  latitude:(NSString *)animalLatitude  city:(NSString *)animalCity  image:(NSString *)animalImage  clue:(NSString *)animalClue {
    
    }else{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dat=\"http://database.java.insaneplatypusgames.com\">"
                             "<soapenv:Header/>"
                             "<soapenv:Body>"
                             "<dat:insertAnimal>"
                             "<dat:type>%@</dat:type>"
                             "<dat:longitude>%@</dat:longitude>"
                             "<dat:latitude>%@</dat:latitude>"
                             "<dat:city>%@</dat:city>"
                             "<dat:image>%@</dat:image>"
                             "<dat:clue>%@</dat:clue>"
                             "</dat:insertAnimal>"
                             "</soapenv:Body>"
                             "</soapenv:Envelope>", animalType, longitude, latitude, animalCity, animalImage, animalClue];
                             
                              
    NSURL *url = [NSURL URLWithString:SERVER_URL];               
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];             
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];          
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];       
    [theRequest addValue: SERVER_URL_GETANIMALS forHTTPHeaderField:@"soapAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];     
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection) {
        self.webData = [[NSMutableData data] retain];
        
        NSLog(@"-------------- webData %@", self.webData);
        
        Animal *newAnimal = [[[Animal alloc] init] autorelease];
        newAnimal.type = animalType;
        newAnimal.city = animalCity;
        newAnimal.longitude = longitude;
        newAnimal.latitude = latitude;
        newAnimal.image = animalImage;
        //newAnimal.clue = animalClue;
         [arrayItems addObject:newAnimal];
         [self plotAnimalPositionsFromArray];	
    }
    else {
        NSLog(@"-------------- theConnection is NULL");
    }
    }


}



- (IBAction) pressPlayButton{
    [menuView setHidden:YES];
    
    if(cityLocated==FALSE){
        //CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
        /*locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager startUpdatingLocation];*/
        /*self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager startUpdatingLocation];
         */
    }
    
    buttonHideSelected = FALSE;
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];  
    
    //if([settings objectForKey:@"userName"] != nil) {
    if([settings objectForKey:@"userDeviceID"] != nil) {
        //getAnimalsForDeviceID
                [self getAnimalsForDevice:[settings objectForKey:@"userDeviceID"]];

        
    }else{
        
        //TODO deprecated UID
        UIDevice *device = [UIDevice currentDevice];
        NSString *deviceID = [device uniqueIdentifier];
        [settings setValue:deviceID forKey:@"userDeviceID"];  

        
        [settings setValue:@"STEP1" forKey:@"tutorialStep"];  
        NSLog(@"*** userDeviceID %@ ", [settings objectForKey:@"userDeviceID"]);
        [self showTutorialForStep:[settings objectForKey:@"tutorialStep"]];
        
        // The first time the user inits the app, he must enter one user name
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Name" message:@"Please, enter your user name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert addTextFieldWithValue:@"" label:@"User name"];
        
        UITextField *tf = [alert textFieldAtIndex:0];
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.keyboardType = UIKeyboardTypeAlphabet;
        tf.keyboardAppearance = UIKeyboardAppearanceAlert;
        tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
        tf.autocapitalizationType = UITextAutocorrectionTypeNo;
        //tf.background =
        [alert show];
        
        [userNameView setHidden:NO];*/
        
        //NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];  
       // [settings setValue:@"STEP1" forKey:@"tutorialStep"];  
       // NSLog(@"*** userName %@ ", [settings objectForKey:@"userName"]);
         // [self showTutorialForStep:@"STEP1"];
        

        
    }
}

- (IBAction) showMenuItems{
    /*CGRect scrollViewFrame = scrollView.frame;
    scrollViewFrame.origin.y = -scrollViewFrame.size.height;
    
    
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         scrollView.frame = scrollViewFrame;
                         //basketBottom.frame = basketBottomFrame;
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];*/
    
   // [scrollView setHidden:NO];
    CGRect scrollViewFrame = scrollView.frame;
    if(buttonMenuSelected == FALSE){
        buttonMenuSelected = TRUE;
        scrollViewFrame.origin.x = 20;
    } else{
        buttonMenuSelected = FALSE;
        scrollViewFrame.origin.x = 340;
    }
    

    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         scrollView.frame = scrollViewFrame;
                         //basketBottom.frame = basketBottomFrame;
                     } 
                     completion:^(BOOL finished){
                     }];
    [UIView commitAnimations];
    
}


// this delegate method is called if an error occurs in locating your current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"reverseGeocoder:%@ didFailWithError:%@", geocoder, error);

         NSLog(@" ***** error code %d ***** ",  error.code); 
 
    if(error.code == -1011 && !connectionAlerted && ![MODE isEqualToString:@"DEMO"]){
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Connection Error"                                                             
                                  message:@"Connection problem, please try again later."                                                         
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
        connectionAlerted = TRUE;
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	

}

// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    /*MKReverseGeocoder *geoCoder = [[[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate] autorelease];
    geoCoder.delegate = self;
    [geoCoder start];*/
    
   // [locationManager stopUpdatingLocation];
    
    self.reverseGeocoder =
    [[[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}

- (void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"savedArray"];
    
    self.arrayCapturedAnimals = [[NSMutableArray alloc] init];
    self.firstAnimalType = [[NSString alloc] init];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            self.arrayItems = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
            self.arrayItems = [[NSMutableArray alloc] init];
    } else {
    
    
    
        
    [viewLoadingData setHidden:NO];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *currentLocale = [locale displayNameForKey:NSLocaleIdentifier
                                                  value:[locale localeIdentifier]];
    NSLog( @"Complete locale: %@", currentLocale );
    
        

        if(cityLocated==FALSE){
        //CLLocationManager *locationManager = [[[CLLocationManager alloc] init] autorelease];
        
        /*locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager startUpdatingLocation];*/
  
            
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
          //  self.locationManager.distanceFilter = 50;
        [self.locationManager startUpdatingLocation];
        
    }

    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults]; 
    if([settings objectForKey:@"tutorialStep"] == nil) {
        
        [settings setValue:@"STEP1" forKey:@"tutorialStep"]; 
    }
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
   
	//GoldRushAppDelegate *appDelegate = (GoldRushAppDelegate *)[[UIApplication sharedApplication] delegate];
	//int count = appDelegate.animals.count;
	//return appDelegate.animals.count;
	
	
}

- (void)viewDidUnload {
    [labelForTutorials release];
    labelForTutorials = nil;
    [self setLabelForTutorials:nil];
    [viewForTutorials release];
    viewForTutorials = nil;
    [self setViewForTutorials:nil];
    [nextTutorialButton release];
    nextTutorialButton = nil;
    [self setNextTutorialButton:nil];
    [buttonSearch release];
    buttonSearch = nil;
    [self setButtonSearch:nil];
    [self setViewForTutorialTexts:nil];
    [viewForTutorialTexts release];
    viewForTutorialTexts = nil;
/*    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    [currentDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.arrayItems] forKey:@"animalsArray"];
    
    	[currentDefaults synchronize];
  */  
    [tutorialTextsView release];
    tutorialTextsView = nil;
    [buttonPlay release];
    buttonPlay = nil;
    [scrollView release];
    scrollView = nil;
    [menuItems release];
    menuItems = nil;
    [userNameView release];
    userNameView = nil;
    [menuView release];
    menuView = nil;
    [viewLoadingData release];
    viewLoadingData = nil;
    [buttonAnimal0 release];
    buttonAnimal0 = nil;
    [activityViewIndicator release];
    activityViewIndicator = nil;
	[itemNotFoundAlertButton release];
    itemNotFoundAlertButton = nil;
	[itemFoundAlertButton release];
    itemFoundAlertButton = nil;
	[alertLabel release];
    alertLabel = nil;
	[alertNotFoundLabel release];
    alertNotFoundLabel = nil;
 	[itemNotFoundView release];
    itemNotFoundView = nil;
	[itemFoundView release];
    itemFoundView = nil;
    [bannerView_ release];
    bannerView_ = nil;
//arrayitems???
}


- (void)dealloc {
    [reverseGeocoder release];
    [buttonPlay release];
    [scrollView release];
    [menuItems release];
    [userNameView release];
    [menuView release];
    [viewLoadingData release];
    [buttonAnimal0 release];
    [activityViewIndicator release];
	[itemNotFoundAlertButton release];
	[itemFoundAlertButton release];    
	[alertLabel release];    
	[alertNotFoundLabel release];
	[itemNotFoundView release];
	[itemFoundView release];
    [ipAddress release];
    [soapResults release];
    [tutorialTextsView release];
    [bannerView_ release];
    [locationManager release];
    [viewForTutorialTexts release];
    [arrayItems release];
    [firstAnimalType release];
    
    buttonPlay = nil;
    scrollView = nil;
    menuItems = nil;
    userNameView = nil;
    menuView = nil;
    viewLoadingData = nil;
    buttonAnimal0 = nil;
    activityViewIndicator = nil;
    itemNotFoundAlertButton = nil;
    itemFoundAlertButton = nil;
    alertLabel = nil;
    alertNotFoundLabel = nil;
    itemNotFoundView = nil;
    itemFoundView = nil;
    ipAddress = nil;
    soapResults = nil;
    tutorialTextsView = nil;
    bannerView_ = nil;
    viewForTutorialTexts = nil;
    arrayItems = nil;
    firstAnimalType = nil;
    
    [buttonSearch release];
    [buttonSearch release];
    [nextTutorialButton release];
    [nextTutorialButton release];
    [viewForTutorials release];
    [viewForTutorials release];
    [labelForTutorials release];
    [labelForTutorials release];
    [super dealloc];


}

@end
