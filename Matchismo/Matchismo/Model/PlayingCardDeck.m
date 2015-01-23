//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by 胡强 on 15/1/9.
//  Copyright (c) 2015年 胡强. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank =1 ; rank<=[PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addcard:card];
            }
        }
    }
    
    return self;
}
@end
