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
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong,nonatomic) NSMutableArray *flipHistory;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation ViewController

-(NSMutableArray *)flipHistory{
	if (!_flipHistory) {
		_flipHistory = [NSMutableArray array];
	}
	return _flipHistory;
}

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
	[self playClickSound];
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
	}
	self.scoreLabel.text = [NSString stringWithFormat:@"Score:%ld",(long)self.game.score];
	
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
	
		self.resultLabel.alpha = 1;
		if (![description isEqualToString:@""] && ![[self.flipHistory lastObject] isEqualToString:description]) {
			[self.flipHistory addObject:description];
			[self setSliderRange];
		}
	
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
	self.flipHistory = nil;
	[self setSliderRange];
	[self updateUI];
}
- (IBAction)changeModeSelector:(UISegmentedControl *)sender {
		self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}
- (IBAction)changeSlider:(UISlider *)sender {
	NSInteger sliderValue;
	sliderValue = lroundf(self.historySlider.value);
	[self.historySlider setValue:sliderValue animated:NO];
	if ([self.flipHistory count]) {
		self.resultLabel.alpha = (sliderValue+1 <[self.flipHistory count]) ? 0.6 : 1.0;
		self.resultLabel.text = [self.flipHistory objectAtIndex:sliderValue];
	}
}

-(void)setSliderRange{
	NSInteger maxValue = [self.flipHistory count]-1;
	self.historySlider.maximumValue = maxValue;
	[self.historySlider setValue:maxValue animated:YES];
}

-(void)playClickSound{
	
	SystemSoundID soundID;
	
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
	CFURLRef soundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:soundPath];
	AudioServicesCreateSystemSoundID(soundURL, &soundID);
	AudioServicesPlaySystemSound(soundID);
}



@end
