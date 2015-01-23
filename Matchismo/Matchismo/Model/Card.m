//
//  Card.m
//  Matchismo
//
//  Created by 胡强 on 15/1/9.
//  Copyright (c) 2015年 胡强. All rights reserved.
//

#import "Card.h"

@implementation Card

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score= 1;
        }
    }
    
    return score;
}
@end
