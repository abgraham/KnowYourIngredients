//
//  ViewController.m
//  KnowYourIngredients
//
//  Created by Annie Graham on 10/17/16.
//  Copyright © 2016 Annie Graham. All rights reserved.
//

#import "ViewController.h"
#import "Stats.h"

@interface ViewController ()
@property UILabel *ingredient;
@property NSArray *glutenIngredients;
@property NSArray *allIngredients;
@property NSLayoutConstraint *xPositionConstraint;
@property NSLayoutConstraint *yPositionConstraint;
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
    self.ingredient = [UILabel new];
    [self.view addSubview:self.ingredient];
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
    self.xPositionConstraint.constant = self.view.center.x;
    self.yPositionConstraint.constant = 130;
    NSInteger randomIndex = arc4random_uniform((unsigned int)[self.allIngredients count]);
    NSString *ingredient = [self.allIngredients objectAtIndex:randomIndex];
    self.ingredient.text = ingredient;
    NSLog(@"testing");
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
    self.ingredient.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    self.yPositionConstraint =  [NSLayoutConstraint
                                 constraintWithItem:self.ingredient
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                 constant:130];

    self.xPositionConstraint = [NSLayoutConstraint
                                constraintWithItem:self.ingredient
                                attribute:NSLayoutAttributeCenterX
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                constant:([UIScreen mainScreen].bounds.size.width/2)];
    [self.view addConstraint:self.yPositionConstraint];
    [self.view addConstraint:self.xPositionConstraint];
}

- (void)setUpIngredients {
    if (self.segmentedControl.selectedSegmentIndex == 0){
        self.glutenIngredients = [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye", NULL];
        self.allIngredients = [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye", @"rice", @"potatoes", @"corn", @"buckwheat", NULL];
    } else {
        self.glutenIngredients = [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye",
                                  @"yeast", @"Bulgur", @"Durum", @"Farro/faro", @"Spelt", @"dinkel", @"Graham flour", @"Hydrolyzed wheat protein", @"Kamut", @"Malt, malt extract, malt syrup, malt flavoring", @"Malt vinegar", @"Malted milk", @"Matzo", @"Modified wheat starch", @"Oatmeal", @"Seitan", @"Semolina", @"Triticale", @"Wheat bran", @"Wheat flour", @"Wheat germ", @"Wheat starch", @"Atta", @"Chapati flour", @"Einkorn", @"Emmer", @"Farina", @"Fu", NULL];
        self.allIngredients = [NSArray arrayWithObjects: @"corn starch", @"grits", @"hominy", @"polenta", @"maltodextrin", @"arrowroot", @"tapioca", @"manioc flour", @"guar gum", @"hydrolyzed soy protein", @"lethicin", @"millet", @"mono and diglycerides", @"montina", @"MSG", @"Oat gum", @"Quinoa", @"Sorghum", @"Soy", @"Starch", @"Teff", @"Vinegar", @"Whey", @"Xanthan gum", @"Yeast", @"Brewer's yeast", @"Bulgur", @"Durum", @"Farro/faro", @"Spelt", @"dinkel", @"Graham flour", @"Hydrolyzed wheat protein", @"Kamut", @"Malt, malt extract, malt syrup, malt flavoring", @"Malt vinegar", @"Malted milk", @"Matzo", @"Modified wheat starch", @"Oatmeal", @"Seitan", @"Semolina", @"Triticale", @"Wheat bran", @"Wheat flour", @"Wheat germ", @"Wheat starch", @"Atta", @"Chapati flour", @"Einkorn", @"Emmer", @"Farina", @"Fu", NULL];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint pointPressed = [sender locationInView:self.view];
    NSLog(@"%f", pointPressed.x);
    self.xPositionConstraint.constant = pointPressed.x;
    self.yPositionConstraint.constant = pointPressed.y;
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ((pointPressed.x < self.view.center.x && [self.glutenIngredients containsObject:self.ingredient.text]) || (pointPressed.x > self.view.center.x && ![self.glutenIngredients containsObject:self.ingredient.text])) {
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
