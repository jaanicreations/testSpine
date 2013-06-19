testSpine
=========

Test project for Cocos2d-iPhone and Spine

This is a Cocos2d-iPhone 2.1 project that gives some simple examples on how to use Spine (as provided by Esoteric). It also contains a quickly put together SkeletonManager (based on code from @bigred) to give you a starting point in creating your own Spine singletons. The test project creates a pool of 20 (user definable) skeleton and places them off screen but slightly visible.  It then draws a Spineboy (unscaled) in the middle of the screen running a loop animation. Tapping the screen will take a skeleton from the pool, put a scaled spriteboy at the touch locations X axis and have him walk across the screen. When he leaves the screen he will be returned to the pool.

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
