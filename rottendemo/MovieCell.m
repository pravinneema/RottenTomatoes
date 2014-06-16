//
//  MovieCell.m
//  rottendemo
//
//  Created by Pravin Neema on 6/5/14.
//  Copyright (c) 2014 Pravin Neema. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieCell ()
    @property (weak, nonatomic) IBOutlet UILabel *movieTitleLable;
    @property (weak, nonatomic) IBOutlet UILabel *synopsisLable;
    @property (weak, nonatomic) IBOutlet UIImageView *posterView;
@end

@implementation MovieCell
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setMovie:(NSDictionary *) movie{
    self._movie = movie;
    
    self.movieTitleLable.text = movie[@"title"];
    self.synopsisLable.text = movie[@"synopsis"];
    
    NSDictionary *posters = movie[@"posters"];
    
    NSString *imageUrl = posters[@"thumbnail"];
    
    UIImage *ret = [self imageNamed:imageUrl cache:YES];
    self.posterView.image = ret;    
    
    self.posterView.alpha = 0.0;
    [UIView animateWithDuration:5.0 animations:^{
        self.posterView.alpha = 1.0;
    }];

}

- (UIImage*)imageNamed:(NSString*)imageNamed cache:(BOOL)cache
{
    UIImage* retImage = [self.staticImageDictionary objectForKey:imageNamed];
    if (retImage == nil)
    {
        retImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageNamed]]];
        if (cache)
        {
            if (self.staticImageDictionary == nil)
                self.staticImageDictionary = [NSMutableDictionary new];
            
            [self.staticImageDictionary setObject:retImage forKey:imageNamed];
        }
    }
    return retImage;
}

@end
