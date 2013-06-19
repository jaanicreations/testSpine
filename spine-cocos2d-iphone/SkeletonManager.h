//
//  SkeletonManager.h
//  spine-cocos2d-iphone-ios
//
//  Created by Naveed Iqbal on 18/06/2013 using code from @BigRed.
//  Provided under MIT license
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <spine/spine-cocos2d-iphone.h>

@interface SkeletonManager : NSObject {
    NSMutableDictionary *skeletonDict;
    NSMutableDictionary *usedSkeletonDict;
}
@property (nonatomic, retain) NSMutableDictionary *skeletonDict;
@property (nonatomic, retain) NSMutableDictionary *usedSkeletonDict;

+ (SkeletonManager*)sharedSkeletonManager;
- (void)createSkeletonsWithFile:(NSString*)json AtlasFile:(NSString*)atlas withMaxAmount:(unsigned int)maxSkeletons skeletonName:(NSString*)skeletonName forNode:(id)node;
- (NSString*)getAvailableSkeletonKeyFor:(NSString *)skeletonName withMaxAmount:(unsigned int)maxSkeletons;
- (CCSkeletonAnimation*)getAvailableSkeletonNamedInDict:(NSString*)skeletonKeyForDict;
- (void) freeSkeleton:(NSString*)skeletonToFree;
@end
