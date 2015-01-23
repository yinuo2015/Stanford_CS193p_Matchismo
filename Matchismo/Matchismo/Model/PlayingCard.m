//
//  PlayingCard.m
//  Matchismo
//
//  Created by 胡强 on 15/1/9.
//  Copyright (c) 2015年 胡强. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards{
	
	int score = 0;
	NSUInteger numOtherCards = [otherCards count];
	if (numOtherCards) {
		for (PlayingCard *otherCard in otherCards) {
			if (otherCard.rank == self.rank) {
				score += 4 ;
			} else if ([otherCard.suit isEqualToString:self.suit]) {
				score += 1 ;
			}
		}
		
	}
	
	if (numOtherCards > 1) {
		score += [[otherCards firstObject] match:[otherCards subarrayWithRange:NSMakeRange(1, numOtherCards-1)]];
	}
	return score;
}




- (NSString *)contents
{
    NSArray *rankStrings =[PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠️",@"♣️",@"♥️",@"♦️"];
}

-(void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1 ;
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}
@end
