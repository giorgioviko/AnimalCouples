#import <UIKit/UIKit.h>

@interface Animal : NSObject {
	NSString *type;
	NSString *longitude;
	NSString *latitude;
	NSString *city;	
	NSString *image;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *image;

-(id)initWithType:(NSString *)t longitude:(NSString *)longit latitude:(NSString *)latit city:(NSString *)c image:(NSString *)im;

@end