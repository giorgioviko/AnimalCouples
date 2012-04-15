//
//  MyLocation.h
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Animal.h"

@interface MyLocation : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_address;
	NSString *_itemType;
	NSString *_image;
	Animal *_animal;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSString *itemType;
@property (copy) NSString *image;
@property (copy) Animal *animal;
//@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address itemType:(NSString*)itemType image:(NSString*)image coordinate:(CLLocationCoordinate2D)coordinate animal:(Animal*)animal;

@end
