//
//  ViewController.m
//  Matchismo
//
//  Created by 胡强 on 15/1/9.
//  Copyright (c) 2015年 胡强. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
- (IBAction)restartButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (CardMatchingGame *)game {
	if (!_game) {
		_game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self creatDeck]];
		[self changeModeSelector:self.modeSelector];
	}
	return _game;
}


-(Deck*) creatDeck{
	return [[PlayingCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender
{
	NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
	[self.game chooseCardAtIndex:chosenButtonIndex];
	self.modeSelector.enabled = NO;
	[self updateUI];
	
}

- (void) updateUI{
	for (UIButton *cardButton in self.cardButtons) {
		NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
		Card *card = [self.game cardAtIndex:cardButtonIndex];
		[cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
		[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
		cardButton.enabled = !card.isMatched;
		self.scoreLabel.text = [NSString stringWithFormat:@"Score:%ld",(long)self.game.score];
	}
	
	if (self.game) {
		NSString *description = @"";
		if ([self.game.lastChosenCards count]) {
			NSMutableArray *cardContents = [NSMutableArray array];
			for (Card *card in self.game.lastChosenCards) {
				[cardContents addObject:card.contents];
			}
			description = [cardContents componentsJoinedByString:@" "];
		}
		if (self.game.lastScore>0) {
			description = [NSString stringWithFormat:@"Matched %@ for %ld points!",description,(long)self.game.lastScore];
		}else if(self.game.lastScore < 0){
			description = [NSString stringWithFormat:@"%@ don't match %ld point penalty!",description,(long)-self.game.lastScore];
		}
		self.resultLabel.text = description;
	}
}

-(NSString *)titleForCard:(Card*)card{
	return card.isChosen ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card*)card{
	return [UIImage imageNamed:card.isChosen ? @"cardfront":@"cardback"];
}

- (IBAction)restartButton:(UIButton *)sender {
	self.game = nil;
	self.modeSelector.enabled = YES;
	[self updateUI];
}
- (IBAction)changeModeSelector:(UISegmentedControl *)sender {
		self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}



@end
