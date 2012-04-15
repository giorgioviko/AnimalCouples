#import "Animal.h"

@implementation Animal
@synthesize type, longitude, latitude, city, image;

-(id)initWithType:(NSString *)t longitude:(NSString *)longit latitude:(NSString *)latit city:(NSString *)c image:(NSString *)im{

//-(id)initWithName:(NSString *)n description:(NSString *)d url:(NSString *)u {
	self.type = t;
	self.longitude = longit;
	self.latitude = latit;
	self.city = c;
	self.image = im;
	return self;
}
@end