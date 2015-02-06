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


-(void)viewDidLoad
{
	self.resultLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark 历史记录数据
-(NSMutableArray *)flipHistory{
	if (!_flipHistory) {
		_flipHistory = [NSMutableArray array];
	}
	return _flipHistory;
}

#pragma mark 初始化游戏(懒加载)
- (CardMatchingGame *)game {
	if (!_game) {
		_game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self creatDeck]];
		[self changeModeSelector:self.modeSelector];
	}
	return _game;
}

#pragma mark 创建牌堆
-(Deck*) creatDeck{
	return [[PlayingCardDeck alloc] init];
}

#pragma mark 点击卡牌事件
- (IBAction)touchCardButton:(UIButton *)sender
{
	[self playClickSound];
	NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
	[self.game chooseCardAtIndex:chosenButtonIndex];
	self.modeSelector.enabled = NO;
	[self updateUI];
	
}

#pragma mark 更新界面
- (void) updateUI{
	for (UIButton *cardButton in self.cardButtons) {
		cardButton.titleLabel.adjustsFontSizeToFitWidth = YES;
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
		
		//此处判断description的长度大于4，是为了避免如“10♣️“这类title单独出现在flipHistory里。
		if (description.length > 4 && ![[self.flipHistory lastObject] isEqualToString:description]) {
			[self.flipHistory addObject:description];
			[self setSliderRange];
		}
	
	}
	
}

#pragma mark 卡片文字
-(NSString *)titleForCard:(Card*)card{
	return card.isChosen ? card.contents : @"";
}

#pragma mark 卡片背景图片
-(UIImage *)backgroundImageForCard:(Card*)card{
	return [UIImage imageNamed:card.isChosen ? @"cardfront":@"cardback"];
}

#pragma mark 游戏重新开始
- (IBAction)restartButton:(UIButton *)sender {
	self.game = nil;
	self.modeSelector.enabled = YES;
	self.flipHistory = nil;
	//[self setSliderRange];
	[self.historySlider setValue:0 animated:YES];
	self.historySlider.maximumValue = 0;
	[self updateUI];
}

#pragma mark 更换游戏模式
- (IBAction)changeModeSelector:(UISegmentedControl *)sender {
		self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

#pragma mark 历史纪录条
- (IBAction)changeSlider:(UISlider *)sender {
	NSInteger sliderValue;
	sliderValue = lroundf(self.historySlider.value);
	[self.historySlider setValue:sliderValue animated:NO];
	if ([self.flipHistory count]) {
		self.resultLabel.alpha = (sliderValue+1 <[self.flipHistory count]) ? 0.6 : 1.0;
		self.resultLabel.text = [self.flipHistory objectAtIndex:sliderValue];
	}
}

#pragma mark 设置slider的范围
-(void)setSliderRange{
	NSInteger maxValue = [self.flipHistory count]-1;
	self.historySlider.maximumValue = maxValue;
	[self.historySlider setValue:maxValue animated:YES];
}

#pragma mark 播放音效
-(void)playClickSound{
	
	SystemSoundID soundID;
	
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
	CFURLRef soundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:soundPath];
	AudioServicesCreateSystemSoundID(soundURL, &soundID);
	AudioServicesPlaySystemSound(soundID);
}



@end
