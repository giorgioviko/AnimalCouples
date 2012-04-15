#import "Animal.h"

@implementation Animal

@synthesize type, longitude, latitude, city, image, generation, owner, isCatched;
@synthesize clue;
@synthesize idAnimal;
@synthesize isCoupled;

-(id)initWithType:(NSString *)t longitude:(NSString *)longit latitude:(NSString *)latit city:(NSString *)c image:(NSString *)im clue:(NSString *)cl isCoupled:(NSString *)isCoup generation:(NSString *)gen owner:(NSString *)own isCatched:(NSString *)isCatch{

	self.type = t;
	self.longitude = longit;
	self.latitude = latit;
	self.city = c;
	self.image = im;
	self.clue = cl;
    self.isCoupled = isCoup;
    self.generation = gen;
    self.owner = own;
    self.isCatched = isCatch;
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:type forKey:@"type"];
    [coder encodeInteger:longitude forKey:@"longitude"];
    [coder encodeObject:latitude forKey:@"latitude"];
    [coder encodeInteger:city forKey:@"city"];
    [coder encodeObject:image forKey:@"image"];
    [coder encodeInteger:clue forKey:@"clue"];
    [coder encodeInteger:idAnimal forKey:@"idAnimal"];
    [coder encodeInteger:isCoupled forKey:@"isCoupled"];
    [coder encodeInteger:generation forKey:@"generation"];
    [coder encodeInteger:owner forKey:@"owner"];
    [coder encodeInteger:isCatched forKey:@"isCatched"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Animal alloc] init];
    if (self != nil)
    {
        self.type = [[coder decodeObjectForKey:@"type"] retain];
        self.longitude = [[coder decodeObjectForKey:@"longitude"] retain];
        self.latitude = [[coder decodeObjectForKey:@"latitude"] retain];
        self.city = [[coder decodeObjectForKey:@"city"] retain];
        self.image = [[coder decodeObjectForKey:@"image"] retain];
        self.clue = [[coder decodeObjectForKey:@"clue"] retain];
        self.idAnimal = [[coder decodeObjectForKey:@"idAnimal"] retain];
        self.isCoupled = [[coder decodeObjectForKey:@"isCoupled"] retain];
        self.generation = [[coder decodeObjectForKey:@"generation"] retain];
        self.owner = [[coder decodeObjectForKey:@"owner"] retain];
        self.isCatched = [[coder decodeObjectForKey:@"isCatched"] retain];
    }   
    return self;
}

/*
- (NSString *)generation {
    return generation;
}

- (NSString *)isCoupled {
    return isCoupled;
}



- (NSString *)clue {
    return clue;
}

- (NSString *)idAnimal {
    return idAnimal;
}*/

@end