//
//  TGCameraFlash.m
//  TGCameraViewController
//
//  Created by Bruno Tortato Furtado on 14/09/14.
//  Copyright (c) 2014 Tudo Gostoso Internet. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TGCameraFlash.h"
#import "TGCameraColor.h"
#import "TGTintedButton.h"

@implementation TGCameraFlash

#pragma mark -
#pragma mark - Public methods

+ (void)changeModeWithCaptureSession:(AVCaptureSession *)session andButton:(UIButton *)button
{
    AVCaptureDevice *device = [session.inputs.lastObject device];
    AVCaptureFlashMode mode = [device flashMode];

    [device lockForConfiguration:nil];
    
    switch ([device flashMode]) {
        case AVCaptureFlashModeAuto:
            mode = AVCaptureFlashModeOn;
            break;
            
        case AVCaptureFlashModeOn:
            mode = AVCaptureFlashModeOff;
            break;
            
        case AVCaptureFlashModeOff:
            mode = AVCaptureFlashModeAuto;
            break;
    }
    
    if ([device isFlashModeSupported:mode]) {
        device.flashMode = mode;
    }
    
    [device unlockForConfiguration];
    
    [self flashModeWithCaptureSession:session andButton:button];
}

+ (void)flashModeWithCaptureSession:(AVCaptureSession *)session andButton:(UIButton *)button
{
    AVCaptureDevice *device = [session.inputs.lastObject device];
    AVCaptureFlashMode mode = [device flashMode];
    UIImage *image = UIImageFromAVCaptureFlashMode(mode);
    UIColor *tintColor = TintColorFromAVCaptureFlashMode(mode);
    button.enabled = [device isFlashModeSupported:mode];
    
    if ([button isKindOfClass:[TGTintedButton class]]) {
        [(TGTintedButton*)button setCustomTintColorOverride:tintColor];
    }
    
    [button setImage:image forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - Private methods

UIImage *UIImageFromAVCaptureFlashMode(AVCaptureFlashMode mode)
{
    NSArray *array = @[@"CameraFlashOff", @"CameraFlashOn", @"CameraFlashAuto"];
    NSString *imageName = [array objectAtIndex:mode];
    return [UIImage imageNamed:imageName];
}

UIColor *TintColorFromAVCaptureFlashMode(AVCaptureFlashMode mode)
{
    NSArray *array = @[[UIColor grayColor], [TGCameraColor tintColor], [TGCameraColor tintColor]];
    UIColor *color = [array objectAtIndex:mode];
    return color;
}

@end