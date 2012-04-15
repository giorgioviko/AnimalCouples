/*-
 * WSDL stubs for:  http://localhost:8080/AnimalsWebService/services/AnimalsDBManagement?wsdl
 *   Generated by:  VIKO
 *           Date:  Tue Oct 25 20:01:00 2011
 *        Emitter:  Objective-C
 */

#ifndef __AnimalsDBWebService__
#define __AnimalsDBWebService__

//#import <CoreServices/CoreServices.h>
//#import <Foundation/Foundation.h>
//#import "WSGeneratedObj.h"

/*-
 *   Web Service:  AnimalsDBManagement
 * Documentation:  <not documented>
 */
/*-
 *   Method Name:  getAnimalsFromCity
 * Documentation:  <no documentation>
 */

@interface getAnimalsFromCity : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|getAnimalsFromCity */) in_parameters;

// result returns an id from the reply dictionary as specified by the WSDL.
- (id) resultValue;

@end; /* getAnimalsFromCity */


/*-
 *   Method Name:  createTable
 * Documentation:  <no documentation>
 */

@interface createTable : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|createTable */) in_parameters;

@end; /* createTable */


/*-
 *   Method Name:  insertAnimal
 * Documentation:  <no documentation>
 */

@interface insertAnimal : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|insertAnimal */) in_parameters;

@end; /* insertAnimal */


/*-
 *   Method Name:  getAnimalsFromCity
 * Documentation:  <no documentation>
 */

@interface getAnimalsFromCity : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|getAnimalsFromCity */) in_parameters;

// result returns an id from the reply dictionary as specified by the WSDL.
- (id) resultValue;

@end; /* getAnimalsFromCity */


/*-
 *   Method Name:  createTable
 * Documentation:  <no documentation>
 */

@interface createTable : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|createTable */) in_parameters;

@end; /* createTable */


/*-
 *   Method Name:  insertAnimal
 * Documentation:  <no documentation>
 */

@interface insertAnimal : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|insertAnimal */) in_parameters;

@end; /* insertAnimal */


/*-
 *   Method Name:  getAnimalsFromCity
 * Documentation:  <no documentation>
 */

@interface getAnimalsFromCity : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|getAnimalsFromCity */) in_parameters;

// result returns an id from the reply dictionary as specified by the WSDL.
- (id) resultValue;

@end; /* getAnimalsFromCity */


/*-
 *   Method Name:  createTable
 * Documentation:  <no documentation>
 */

@interface createTable : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|createTable */) in_parameters;

@end; /* createTable */


/*-
 *   Method Name:  insertAnimal
 * Documentation:  <no documentation>
 */

@interface insertAnimal : WSGeneratedObj

// update the parameter list for the invocation.
- (void) setParameters:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|insertAnimal */) in_parameters;

@end; /* insertAnimal */


/*-
 * Web Service:  AnimalsDBManagement
 */
@interface AnimalsDBManagementService : NSObject 

+ (id) getAnimalsFromCity:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|getAnimalsFromCity */) in_parameters;
+ (id) createTable:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|createTable */) in_parameters;
+ (id) insertAnimal:(CFTypeRef /* Complex type http://database.java.insaneplatypusgames.com|insertAnimal */) in_parameters;

@end;


#endif /* __AnimalsDBWebService__ */
/*-
 * End of WSDL document at
 * http://localhost:8080/AnimalsWebService/services/AnimalsDBManagement?wsdl
 */