//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by 胡强 on 1/21/15.
//  Copyright (c) 2015 胡强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"


@interface CardMatchingGame : NSObject

//designated initializer
-(instancetype) initWithCardCount:(NSUInteger) count usingDeck:(Deck*) deck;

-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic,readonly) NSInteger score;
@property (nonatomic) NSUInteger maxMatchingCards;

@property (nonatomic,readonly) NSArray *lastChosenCards;
@property (nonatomic,readonly) NSInteger lastScore;

@end
