//
//  ViewController.m
//  KnowYourIngredients
//
//  Created by Annie Graham on 10/17/16.
//  Copyright © 2016 Annie Graham. All rights reserved.
//

#import "ViewController.h"
#import "Stats.h"
#import "KnowYourIngredientsAPI.h"

@interface ViewController () {

UILabel *ingredient;
NSArray *glutenIngredients;
NSArray *allIngredients;
NSLayoutConstraint *xPositionConstraint;
NSLayoutConstraint *yPositionConstraint;

}

@property (weak, nonatomic) IBOutlet UIImageView *reaction;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property Stats *gameStats;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)controlValueChanged:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self restoreSettings];
    [self setUpIngredients];
    [self setUpStats];
    ingredient = [UILabel new];
    [self.view addSubview:ingredient];
    [self presentIngredient];
    [self addConstraints];
    [self addPanRecognizer];
}

- (void)setUpStats {
    self.gameStats = [Stats new];
    [self.gameStats addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    [self.gameStats addObserver:self forKeyPath:@"streak" options:NSKeyValueObservingOptionNew context:nil];
    self.gameStats.score = 0;
    self.gameStats.streak = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.gameStats.highScore =[defaults integerForKey:@"HighScore"];
    self.highScoreLabel.text = [NSString stringWithFormat:@"%ld",self.gameStats.highScore];
}

- (void)presentIngredient {
    xPositionConstraint.constant = self.view.center.x;
    yPositionConstraint.constant = 130;
    NSInteger randomIndex = arc4random_uniform((unsigned int)[allIngredients count]);
    NSString *ingredientString = [allIngredients objectAtIndex:randomIndex];
    ingredient.text = ingredientString;
}

- (void)addPanRecognizer {
    UIPanGestureRecognizer *panRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    self.scoreLabel.text =[NSString stringWithFormat:@"%ld", self.gameStats.score];
    self.streakLabel.text = [NSString stringWithFormat:@"%ld", self.gameStats.streak];
    if (self.gameStats.score > self.gameStats.highScore){
        [self recordHighScore];
    }
}

- (void)addConstraints {
    ingredient.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    yPositionConstraint =  [NSLayoutConstraint
                                 constraintWithItem:ingredient
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                 constant:130];

    xPositionConstraint = [NSLayoutConstraint
                                constraintWithItem:ingredient
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                constant:([UIScreen mainScreen].bounds.size.width/2)];
    [self.view addConstraint:yPositionConstraint];
    [self.view addConstraint:xPositionConstraint];
}

- (void)setUpIngredients {
    KnowYourIngredientsAPI *sharedInstance = [KnowYourIngredientsAPI sharedInstance];
    if (self.segmentedControl.selectedSegmentIndex == 0){
        glutenIngredients = [sharedInstance getEasyGlutenIngredients];
        allIngredients = [sharedInstance getEasyAllIngredients];
    } else {
        glutenIngredients = [sharedInstance getHardGlutenIngredients];
        allIngredients = [sharedInstance getAllHardIngredients];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint pointPressed = [sender locationInView:self.view];
    xPositionConstraint.constant = pointPressed.x;
    yPositionConstraint.constant = pointPressed.y;
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ((pointPressed.x < self.view.center.x && [glutenIngredients containsObject:ingredient.text]) || (pointPressed.x > self.view.center.x && ![glutenIngredients containsObject:ingredient.text])) {
            self.gameStats.score += 100;
            self.gameStats.streak += 1;
            self.reaction.image = [UIImage imageNamed:@"happyface.jpg"];
        } else {
            self.gameStats.streak = 0;
            self.gameStats.score -= 100;
            self.reaction.image = [UIImage imageNamed:@"sickface.jpg"];
        }
        [self presentIngredient];
    }
}

- (void)recordHighScore {
    self.gameStats.highScore = self.gameStats.score;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.gameStats.highScore forKey:@"HighScore"];
    self.highScoreLabel.text = [NSString stringWithFormat:@"%ld", self.gameStats.highScore];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)controlValueChanged:(id)sender {
    NSInteger selectedSegment = ((UISegmentedControl *)sender).selectedSegmentIndex;
    [[NSUserDefaults standardUserDefaults] setInteger:selectedSegment forKey:@"SelectedSegmentIndex"];
    [self setUpIngredients];
}

- (void)restoreSettings {
    self.segmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedSegmentIndex"];
}
@end
