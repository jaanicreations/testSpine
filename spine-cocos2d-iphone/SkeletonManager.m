//
//  SkeletonManager.m
//  spine-cocos2d-iphone-ios
//
//  Created by Naveed Iqbal on 18/06/2013.
//  Provided under MIT license

#import "SkeletonManager.h"

@implementation SkeletonManager

static SkeletonManager* _sharedSkeletonManager = nil;
//@synthesize skeletonArray = _skeletonArray;
//@synthesize usedSkeletonArray = _usedSkeletonArray;
@synthesize skeletonDict = _skeletonDict;
@synthesize usedSkeletonDict = _usedSkeletonDict;


+(SkeletonManager*)sharedSkeletonManager {
    @synchronized([SkeletonManager class])
    {
        if(!_sharedSkeletonManager)
            [[self alloc] init];
        return _sharedSkeletonManager;
    }
    return nil;
}

+(id)alloc
{
    @synchronized ([SkeletonManager class])
    {
        NSAssert(_sharedSkeletonManager == nil,@"Attempted to allocate a second instance of the Skeleton Manager singleton");
        _sharedSkeletonManager = [super alloc];
        return _sharedSkeletonManager;
    }
    return nil;
}

// Override the scale parameter in CCAnimationSkeleton
- (CCSkeletonAnimation*)skeletonFile:(NSString*)_skf atlasFile:(NSString*)_atl {
    CCSkeletonAnimation* skeletonNode = [CCSkeletonAnimation skeletonWithFile:_skf atlasFile:_atl scale:1/CC_CONTENT_SCALE_FACTOR()];
    return skeletonNode;
}

// Creates a predefined number of skeletons and adds to the calling node
-(void)createSkeletonsWithFile:(NSString*)json AtlasFile:(NSString*)atlas withMaxAmount:(unsigned int)maxSkeletons skeletonName:(NSString*)skeletonName forNode:(id)node {
    CGSize ss = [[CCDirector sharedDirector]winSize];

    _skeletonDict = [[NSMutableDictionary alloc]initWithCapacity:maxSkeletons];
    _usedSkeletonDict = [[NSMutableDictionary alloc]initWithCapacity:maxSkeletons];
    
    int i;
    for (i = 0; i <= maxSkeletons; i++) {
        NSString* skeletonKeyString = [NSString stringWithFormat:@"%@_%i",skeletonName,i];
        CCSkeletonAnimation* skeletonAnimationNode = [self skeletonFile:json atlasFile:atlas];
        skeletonAnimationNode.position = ccp(ss.width/2,-ss.height);
        [_skeletonDict setObject:skeletonAnimationNode forKey:skeletonKeyString];
        
        CCLOG(@"Adding: %@ | skeletonKeyString: %@",skeletonAnimationNode,skeletonKeyString);
        [node addChild:skeletonAnimationNode];
    }
}

- (NSString*)getAvailableSkeletonKeyFor:(NSString*)skeletonName withMaxAmount:(unsigned int)maxSkeletons{
    int i;
    int skeletonToReturn = maxSkeletons + 1;
    NSString* skeletonKeyString;
    
    for (i = 0; i <= maxSkeletons; i++) {
        skeletonKeyString = [NSString stringWithFormat:@"%@_%i",skeletonName,i];
        if (![_usedSkeletonDict objectForKey:skeletonKeyString]) {
            skeletonToReturn = i;
            [_usedSkeletonDict setObject:skeletonKeyString forKey:skeletonKeyString];
            CCLOG(@"Getting skeletonNamed: %@ at index: %i",skeletonKeyString, i);
            break;
        }
    }
    
    if (skeletonToReturn > maxSkeletons) { // we never found a free slot in _usedSkeletonDict
        CCLOG(@"All skeletons in _skeletonArray are being used");
        return NULL;
    } else {
        return skeletonKeyString;
    }
}

- (CCSkeletonAnimation*)getAvailableSkeletonNamedInDict:(NSString*)skeletonKeyForDict {
    CCLOG(@"Returning skeleton for key: %@", skeletonKeyForDict);
    return [_skeletonDict objectForKey:skeletonKeyForDict];
}

- (void) freeSkeleton:(NSString*)skeletonToFree {
    CCLOG(@"Freeing up skeleton for key: %@", skeletonToFree);
    [_usedSkeletonDict removeObjectForKey:skeletonToFree];
}

-(void) dealloc {
    [super dealloc];
    //[_skeletonDict release];
    //[_usedSkeletonDict release];
}
@end
