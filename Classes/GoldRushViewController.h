//
//  GoldRushViewController.h
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 24/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GADBannerView.h"
#import "MyLocation.h"
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD.h"


#define METERS_PER_MILE 1609.344

@interface GoldRushViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate>  {
	BOOL _doneInitialZoom;
	MKMapView *_mapView;
	GADBannerView *bannerView_;
	MKUserLocation *userLocation;
	NSMutableArray *arrayItems;
    NSMutableArray *arrayCapturedAnimals;
    NSString *firstAnimalType;
	MyLocation *lastItemFound;
     MKReverseGeocoder *reverseGeocoder;
	//BOOL buttonHideSelected;




	//IBOutlet UILabel* alertNotFoundLabelMeters;


	//IBOutlet UIActivityIndicatorView * activityView;

    

    //---web service access---//
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    
    //---xml parsing---//
    NSXMLParser *xmlParser;
    BOOL *elementFound;    
    	

    MBProgressHUD *hud;
    
    
    IBOutlet UIBarButtonItem *buttonSearch;
    IBOutlet UITextView *tutorialTextsView;
    IBOutlet UIButton *buttonPlay;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIBarButtonItem *menuItems;  
    IBOutlet UIView *userNameView;
    IBOutlet UIView *menuView;
    IBOutlet UIView *viewLoadingData;
    IBOutlet UIButton *buttonAnimal0;
    IBOutlet UIActivityIndicatorView * activityViewIndicator;
  	IBOutlet UIButton* itemNotFoundAlertButton;
   	IBOutlet UIButton* itemFoundAlertButton;
   	IBOutlet UILabel* alertLabel;
   	IBOutlet UILabel* alertNotFoundLabel;
    IBOutlet UIScrollView *viewForTutorialTexts;
	IBOutlet UIView* itemNotFoundView;
    IBOutlet UIButton *nextTutorialButton;
    IBOutlet UIView *viewForTutorials;
   	IBOutlet UIView* itemFoundView;
    IBOutlet UILabel *labelForTutorials;
}

@property (retain, nonatomic) IBOutlet UIBarButtonItem *buttonSearch;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (retain, nonatomic) IBOutlet UIView *userNameView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, readonly) MKUserLocation *userLocation;
@property(nonatomic, retain) NSMutableArray *arrayItems;
@property(nonatomic, retain) NSMutableArray *arrayCapturedAnimals;
@property(nonatomic, retain) NSString *firstAnimalType;
@property(nonatomic, retain) MyLocation *lastItemFound;
//@property(nonatomic, ) BOOL buttonHideSelected;
@property (nonatomic, retain) IBOutlet UIView *itemFoundView;
@property (nonatomic, retain) IBOutlet UIView *itemNotFoundView;
@property (nonatomic, retain) IBOutlet UILabel *alertLabel;
@property (nonatomic, retain) IBOutlet UILabel *alertNotFoundLabel;
//@property (nonatomic, retain) IBOutlet UILabel *alertNotFoundLabelMeters;
@property (nonatomic, retain) IBOutlet UIButton *itemFoundAlertButton;
@property (nonatomic, retain) IBOutlet UIButton *itemNotFoundAlertButton;
@property (retain, nonatomic) IBOutlet UIButton *buttonAnimal0;
@property (retain, nonatomic) IBOutlet UIView *viewLoadingData;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *menuItems;
@property (retain, nonatomic) IBOutlet UIButton *buttonPlay;
@property (retain, nonatomic) IBOutlet UIView *menuView;
@property (retain, nonatomic) IBOutlet UITextView *tutorialTextsView;
@property (retain, retain) IBOutlet UIButton *nextTutorialButton;
@property (retain, nonatomic) IBOutlet UILabel *labelForTutorials;

//@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic, retain) UITextField *ipAddress;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityViewIndicator;
//@property(nonatomic,retain)  UIActivityIndicatorView * activityView;
//@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain) NSMutableData *webData;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *viewForTutorials;

@property(nonatomic, retain) MBProgressHUD *hud;
@property (retain, nonatomic) IBOutlet UIScrollView *viewForTutorialTexts;

- (IBAction) hideItems:(id)sender;
- (IBAction) searchNearItem:(id)sender;
- (IBAction) locateUser;
- (IBAction) showMenuItems;
- (IBAction) removeLastFoundAnnotation;
- (IBAction) closeNotFoundAlert;
- (IBAction)insertAnimalSon:(id)sender;
- (IBAction)nextTutorialExplanation:(id)sender;

- (void)plotCrimePositions:(CLLocationCoordinate2D )zoomLocation;
- (void)plotCrimePositionsFromCity:(NSString *)cityLocation;
- (void)plotAnimalPositionsFromArray;
- (void) updateAnimalWithId:(NSString*) idAnimal;
- (void) removeItemFromArray:(NSString*)itemFoundType;
- (void) locateUser;
- (void) showTutorialForStep:(NSString *)stepName;
- (void) getAnimalsFromCity:(NSString *) cityName;
- (void) createAnimalForStep1;
- (void) createNewAnimalWithType:(NSString *)type longitude:(NSString *)longitude latitude:(NSString *)latitude city:(NSString *)city image:(NSString *)image clue:(NSString *)clue isCatched:(NSString *)isCatched userOwner:(NSString *)userOwner isCoupled:(NSString *)isCoupled generation:(NSString *)generation;
- (NSString*) randomAnimalType;
- (Animal *) canMakeACoupleWith:(Animal *) animalFound;
- (NSString *) getCoupleType:(NSString *) type;
@end

