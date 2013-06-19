testSpine
=========

Test project for Cocos2d-iPhone and Spine

This is a Cocos2d-iPhone 2.1 project that gives some simple examples on how to use Spine.  It also contains a quickly put together SkeletonManager to give you a starting point in creating your own Spine singletons.

Methods
=======

- (void)createSkeletonsWithFile:(NSString*)json AtlasFile:(NSString*)atlas withMaxAmount:(unsigned int)maxSkeletons skeletonName:(NSString*)skeletonName forNode:(id)node

Creates a pool of predefined skeletons and adds them to the calling node.

- (NSString*)getAvailableSkeletonKeyFor:(NSString *)skeletonName withMaxAmount:(unsigned int)maxSkeletons

Obtains a key for the next available skeleton in the pool.

- (CCSkeletonAnimation*)getAvailableSkeletonNamedInDict:(NSString*)skeletonKeyForDict

Returns the skeleton from the pool using the obtained key.

- (void) freeSkeleton:(NSString*)skeletonToFree

Returns the skeleton to the pool for future use.
