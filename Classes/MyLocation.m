//
//  MyLocation.m
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 30/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyLocation.h"


@implementation MyLocation
@synthesize name = _name;
@synthesize address = _address;
@synthesize itemType = _itemType;
@synthesize image = _image;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address itemType:(NSString*)itemType image:(NSString*)image coordinate:(CLLocationCoordinate2D)coordinate animal:(Animal*)animal{
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
		_itemType = [itemType copy];
		_image = [image copy];		
        _coordinate = coordinate;
        _animal = animal;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (NSString *)image {
    return _image;
}

- (Animal *)animal {
    return _animal;
}

/*
- (NSString *)itemType {
    return _itemType;
}
*/
- (void)dealloc
{
    [_name release];
    _name = nil;
    [_address release];
    _address = nil;  
	[_itemType release];
    _itemType = nil;  
	[_image release];
    _image = nil; 
 	[_animal release];
    _animal = nil;
    [super dealloc];
}

@end
