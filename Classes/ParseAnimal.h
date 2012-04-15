//
//  ParseAnimal.h
//  GoldRush
//
//  Created by Jorge Jordán Arenas on 04/11/11.
//  Copyright (c) 2011 InsanePlatypusGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"

@interface ParseAnimal : NSObject{
    
    NSXMLParser   *revParser; 
	
	Animal *animalRet;
	
	NSMutableString *currentElement;
    
    NSMutableArray *arrayAnimals;
}

-(NSMutableArray*)parseAnimal:(NSString *)xml;

@end
