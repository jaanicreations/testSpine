/*******************************************************************************
 * Copyright (c) 2013, Esoteric Software
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/

#import "ExampleLayer.h"

@implementation ExampleLayer

+ (CCScene*) scene {
	CCScene *scene = [CCScene node];
	[scene addChild:[ExampleLayer node]];
	return scene;
}

-(id) init {
	self = [super init];
    if (self != nil) {
        self.touchEnabled = YES;

	animationNode = [CCSkeletonAnimation skeletonWithFile:@"spineboy.json" atlasFile:@"spineboy.atlas" scale:1];
	[animationNode setMixFrom:@"walk" to:@"jump" duration:0.2f]; // setMix sets crossfade durations
	[animationNode setMixFrom:@"jump" to:@"walk" duration:0.4f];
	[animationNode setAnimation:@"walk" loop:NO]; // sets the current animation
	[animationNode addAnimation:@"jump" loop:NO afterDelay:0]; // queues animations to be played in sequence
	[animationNode addAnimation:@"walk" loop:YES afterDelay:0];
	
    /*
    // To play multiple animations at the same time
    [animationNode addAnimationState]; // adds a second AnimationState
    [animationNode setAnimation:@"jump" loop:true forState:0]; // first state
    [animationNode setAnimation:@"walk" loop:true forState:1]; // second state
    */
     
    animationNode.timeScale = 0.7f;
	animationNode.debugBones = false;
    animationNode.debugSlots = false;

        CCLOG(@"Creating skeleton array pool");
        skeletonKeyListArray = [[NSMutableArray alloc]init];
        [[SkeletonManager sharedSkeletonManager]createSkeletonsWithFile:@"spineboy.json" AtlasFile:@"spineboy.atlas" withMaxAmount:20 skeletonName:@"spineboys" forNode:self];
        
	windowSize = [[CCDirector sharedDirector] winSize];
	[animationNode setPosition:ccp(windowSize.width / 2, 20)];
	[self addChild:animationNode];

        [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
#if __CC_PLATFORM_MAC
	[self setMouseEnabled:YES];
#endif
    }
	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    /*
    CCLOG(@"Creating new SpineBoy");
    CCSkeletonAnimation* animationNode1 = [CCSkeletonAnimation skeletonWithFile:@"spineboy.json" atlasFile:@"spineboy.atlas" scale:0.25];
    [animationNode1 setAnimation:@"walk" loop:YES];
    [animationNode1 setPosition:ccp(touchLocation.x,20)];
    [self addChild:animationNode1];
     */
    
    // Create using SkeletonManager
    // get the next available skeleton key
    NSString* _spineboyKey = [[SkeletonManager sharedSkeletonManager]getAvailableSkeletonKeyFor:@"spineboys" withMaxAmount:20];
    
    // get the skeleton based on the key
    CCSkeletonAnimation* animationNode1 = [[SkeletonManager sharedSkeletonManager]getAvailableSkeletonNamedInDict:_spineboyKey];
    [animationNode1 setAnimation:@"walk" loop:YES];
    [animationNode1 setPosition:ccp(touchLocation.x,20)];
    [animationNode1 runAction:[CCSequence actions:[CCMoveTo actionWithDuration:2 position:ccp(windowSize.width*1.1,animationNode1.position.y)],[CCCallBlock actionWithBlock:^{
        [animationNode1 clearAnimation];
    }],
                               [CCPlace actionWithPosition:ccp(windowSize.width/2,-windowSize.height)],
                               [CCCallFuncND actionWithTarget:self selector:@selector(freeSkeletonCallBack:skeletonKey:) data:(void *)_spineboyKey],nil]];
    
    return TRUE;
}

// Make the call to free up the skeleton
- (void)freeSkeletonCallBack:(id)sender skeletonKey:(void*)_skeletonKey {
    NSString* _skeletonToFree = (NSString*)_skeletonKey;
    CCLOG(@"Free skeleton with name: %@",_skeletonToFree);
    [[SkeletonManager sharedSkeletonManager]freeSkeleton:_skeletonToFree];
}

#if __CC_PLATFORM_MAC
- (BOOL) ccMouseDown:(NSEvent*)event {
	CCDirector* director = [CCDirector sharedDirector];
	NSPoint location =  [director convertEventToGL:event];
	location.x -= [[director runningScene]position].x;
	location.y -= [[director runningScene]position].y;
	location.x -= animationNode.position.x;
	location.y -= animationNode.position.y;
	if (CGRectContainsPoint(animationNode.boundingBox, location)) NSLog(@"Clicked!");
	return YES;
}
#endif

- (void) dealloc {
	//[skeletonKeyListArray release];
	[super dealloc];
}

@end
