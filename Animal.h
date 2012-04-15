#import <UIKit/UIKit.h>

@interface Animal : NSObject {
	NSString *type;
	NSString *longitude;
	NSString *latitude;
	NSString *city;	
	NSString *image;
    NSString *clue;
	NSString *idAnimal;
	NSString *isCoupled;  
    NSString *generation;
    NSString *owner;
    NSString *isCatched;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *clue;
@property (nonatomic, retain) NSString *idAnimal;
@property (nonatomic, retain) NSString *isCoupled;
@property (nonatomic, retain) NSString *generation;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *isCatched;


-(id)initWithType:(NSString *)t longitude:(NSString *)longit latitude:(NSString *)latit city:(NSString *)c image:(NSString *)im clue:(NSString *)cl isCoupled:(NSString *)isCoup generation:(NSString *)gen owner:(NSString *)own isCatched:(NSString *)isCatch;

@end