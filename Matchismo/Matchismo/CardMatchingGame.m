//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by 胡强 on 1/21/15.
//  Copyright (c) 2015 胡强. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Card.h"

@interface CardMatchingGame()
@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic,strong) NSMutableArray *cards;// of Card
@property (nonatomic,strong) NSArray *lastChosenCards;
@property (nonatomic,readwrite) NSInteger lastScore;
@end


@implementation CardMatchingGame

-(NSUInteger)maxMatchingCards{
	if (_maxMatchingCards < 2) {
		_maxMatchingCards = 2;
	}
	return _maxMatchingCards;
}

- (NSMutableArray *)cards{
	if (!_cards) {
		_cards = [[NSMutableArray alloc] init];
	}
	return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck{
	if (self = [super init]) {
		for (int i = 0; i < count; i++) {
			Card *card = [deck drawRandomCard];
			if (card) {
				[self.cards addObject:card];
			}else {
				self = nil;
				break;
			}
			
		}
	}
	return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(Card *)cardAtIndex:(NSUInteger)index{
	return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (void) chooseCardAtIndex:(NSUInteger)index{
	Card *card = [self cardAtIndex:index];
	
	if (!card.isMatched) {
		if (card.isChosen){
			card.chosen = NO;
		} else {
			//match against other chosen cards
			NSMutableArray *otherCards = [NSMutableArray array];
			for (Card *otherCard in self.cards) {
				if (otherCard.isChosen && !otherCard.isMatched) {
					[otherCards addObject:otherCard];
				}
			}
			self.lastScore = 0;
			self.lastChosenCards = [otherCards arrayByAddingObject:card];
			if ([otherCards count] + 1 == self.maxMatchingCards) {
				int matchScore = [card match:otherCards];
				if (matchScore) {
					self.lastScore = matchScore * MATCH_BONUS;
					card.matched = YES;
					for (Card *otherCard in otherCards) {
						otherCard.matched = YES;
					}
				} else {
					self.lastScore = - MISMATCH_PENALTY;
					for (Card *otherCard in otherCards) {
						otherCard.chosen= NO;
					}
				}
			}
			self.score += self.lastScore - COST_TO_CHOOSE;
			card.chosen = YES ;
		}
	}
}
@end
