//
//  PlayingCard.h
//  Matchismo
//
//  Created by 胡强 on 15/1/9.
//  Copyright (c) 2015年 胡强. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong,nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
