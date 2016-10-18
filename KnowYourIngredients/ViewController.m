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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpIngredients];
    self.gameStats = [Stats new];
    [self.gameStats addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    [self.gameStats addObserver:self forKeyPath:@"streak" options:NSKeyValueObservingOptionNew context:nil];

    self.gameStats.score = 0;
    self.gameStats.streak = 0;
    self.ingredient = [UILabel new];
    [self.view addSubview:self.ingredient];
    self.ingredient.text = self.allIngredients[arc4random_uniform([self.allIngredients count])];
    [self addConstraints];
    UIPanGestureRecognizer *panRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panRecognizer];


    // Do any additional setup after loading the view, typically from a nib.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    self.scoreLabel.text =[NSString stringWithFormat:@"%ld", self.gameStats.score];
    self.streakLabel.text = [NSString stringWithFormat:@"%ld", self.gameStats.streak];

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
    [self.view addConstraint:self.yPositionConstraint];
    self.xPositionConstraint = [NSLayoutConstraint constraintWithItem:self.ingredient
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant:([UIScreen mainScreen].bounds.size.width/2)];
    [self.view addConstraint:self.xPositionConstraint];
}

- (void)setUpIngredients {
    self.glutenIngredients = [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye", NULL];
    self.allIngredients = [NSArray arrayWithObjects: @"wheat", @"oats", @"barley", @"rye", @"rice", @"potatoes", @"corn", @"buckwheat", NULL];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"panning");
    CGPoint pointPressed = [sender locationInView:self.view];
    NSLog(@"%f", pointPressed.x);
    self.xPositionConstraint.constant = pointPressed.x;
    self.yPositionConstraint.constant = pointPressed.y;
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ((pointPressed.x < self.view.center.x && [self.glutenIngredients containsObject:self.ingredient.text]) || (pointPressed.x > self.view.center.x && ![self.glutenIngredients containsObject:self.ingredient.text])) {
            NSLog(@"Picked right");
            self.gameStats.score += 100;
            self.gameStats.streak += 1;
            self.reaction.image = [UIImage imageNamed:@"happyface.jpg"];
        } else {
            NSLog(@"Picked wrong");
            self.gameStats.streak = 0;
            self.gameStats.score -= 100;
            self.reaction.image = [UIImage imageNamed:@"sickface.jpg"];
        }
        self.xPositionConstraint.constant = self.view.center.x;
        self.yPositionConstraint.constant = 130;
        self.ingredient.text = self.allIngredients[arc4random_uniform([self.allIngredients count])];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
