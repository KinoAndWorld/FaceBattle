//
//  BattleRecordCell.m
//  FaceBattle-iOS
//
//  Created by kino on 16/6/4.
//
//

#import "BattleRecordCell.h"

@implementation BattleRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _avatarView.layer.masksToBounds = YES;
    [_avatarView applyRoundStyle:30];
    
    _modeLabel.layer.masksToBounds = YES;
    [_modeLabel applyRoundBorderStyle:3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
