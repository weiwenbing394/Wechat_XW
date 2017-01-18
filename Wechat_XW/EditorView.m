//
//  EditorView.m
//  Wechat_XW
//
//  Created by 大家保 on 2017/1/17.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "EditorView.h"
#import "ChatroomViewController.h"

@interface EditorView ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton* voiceButton;

@property (strong, nonatomic) IBOutlet UIButton* emotionButton;

@property (strong, nonatomic) IBOutlet UIButton* additionalButton;

@property (strong, nonatomic) IBOutlet UITextView* textView;

@end

@implementation EditorView

+ (instancetype)editor{
    return [[[NSBundle mainBundle]loadNibNamed:@"EditorView" owner:nil options:nil] lastObject];
};

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor=[UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1];
    self.layer.borderWidth=0.5;
    self.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.1].CGColor;
    
    self.textView.layer.borderWidth=1;
    self.textView.layer.cornerRadius=3;
    self.textView.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.1].CGColor;
    self.textView.delegate=self;
    [self appendKeyboardNotifications];
}

//添加通知
- (void)appendKeyboardNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangedExt:) name:UITextViewTextDidChangeNotification object:nil];
}

//键盘将要弹出
- (void)keyboardWasShown:(NSNotification*)aNotification{
    NSDictionary *info=[aNotification userInfo];
    CGSize keyboardSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration=[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animCurveKey=[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if (self.keyboardWasShown) {
        self.keyboardWasShown(animCurveKey, duration, keyboardSize);
    }
}

//键盘将要隐藏
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary *info=[aNotification userInfo];
    CGSize keyboardSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration=[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animCurveKey=[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    if (self.keyboardWillBeHidden) {
        self.keyboardWillBeHidden(animCurveKey, duration, keyboardSize);
    }
}

/*在复制文字进文本框时触发该通知*/
- (void)textChangedExt:(NSNotification*)notification
{
    [self textViewDidChange:self.textView];
}

#pragma mark - textview delegate
/*根据textView的行数调整视图高度*/
- (void)textViewDidChange:(UITextView *)textView{
    NSInteger lineHeight = self.textView.font.lineHeight;
    NSInteger lineCount = (NSInteger)(textView.contentSize.height / lineHeight);
    NSLog(@"%ld-------%ld",lineHeight,(NSInteger)textView.contentSize.height);
    if (lineCount > 5)
        return;
    
    NSInteger increase = (lineCount - 1) * lineHeight;
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.offset([ChatroomViewController EditorHeight] + increase);
    }];
    [UIView animateWithDuration:.3
                     animations:^{
                         [self.superview layoutIfNeeded];
                     }];
}

//点击发送
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        self.messageWasSend(self.textView.text, ChatMessageTypeText);
        //手动修改值不会触发textview的通知和事件，只有手动触发textViewDidChange
        self.textView.text = @"";
        [self textViewDidChange:self.textView];
        return false;
    }
    return true;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
