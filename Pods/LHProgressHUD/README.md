# LHProgressHUD
[![Build Status](https://travis-ci.org/LeoMobileDeveloper/LHProgressHUD.svg?branch=master)](https://travis-ci.org/LeoMobileDeveloper/LHProgressHUD)[![License: MIT](https://img.shields.io/cocoapods/l/LHProgressHUD.svg?style=flat)](http://opensource.org/licenses/MIT)    [![Version](https://img.shields.io/cocoapods/v/LHProgressHUD.svg?style=flat)](http://cocoapods.org/pods/LHProgressHUD)

## GIf

<img src="https://raw.github.com/LeoMobileDeveloper/LHProgressHUD/master/ScreenShots/main.gif" width="200">

## Requirements

* iOS 8+
* ARC

## Installation

LHProgressHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LHProgressHUD"
```

## Basic Usage

If you have used [MBProgressHUD](https://github.com/jdg/MBProgressHUD) before,it will be easy to use these API.

Show HUD and add it as a subview,then hide it

```
    LHProgressHUD * hud = [LHProgressHUD showSuccessAddedToView:self.view animated:YES];
    hud.textLabel.text = @"Loading...";
    [hud hideAfterDelay:1.0 hiddenBlock:^{
        NSLog(@"HUD is hidden");
    }];
```
LHProgressHUD have four basic sub state

* Animating
* Success
* Failure
* Info

You can use these function to switch between sub state

```
-(void)resetWithStatus:(NSString *)status;

-(void)showInfoWithStatus:(NSString *)status animated:(BOOL)animated;

-(void)showSuccessWithStatus:(NSString *)status animated:(BOOL)animated;

-(void)showFailureWithStatus:(NSString *)status animated:(BOOL)animated;
```

## Pure Text

<img src="https://raw.github.com/LeoMobileDeveloper/LHProgressHUD/master/ScreenShots/text.png" width="200">


```
LHProgressHUD * hud = [LHProgressHUD showAddedToView:self.view];
hud.mode = LHProgressHUDModeTextOnly;
hud.textLabel.text = @"Loading...";
[hud hideAfterDelay:1.0];
```

## Activity Indicator
<img src="https://raw.github.com/LeoMobileDeveloper/LHProgressHUD/master/ScreenShots/ai.png" width="200">


```
LHProgressHUD * hud = [LHProgressHUD showAddedToView:self.view];
hud.mode = LHProgressHUDModeActivityIdenticator;
[hud hideAfterDelay:1.0];
```

## Full Screen blur
<img src="https://raw.github.com/LeoMobileDeveloper/LHProgressHUD/master/ScreenShots/blur.png" width="200">


```
LHProgressHUD * hud = [LHProgressHUD showAddedToView:self.view];
hud.textLabel.text = @"Loading...";
hud.spinnerColor = [UIColor whiteColor];
hud.infoColor = [UIColor orangeColor];
hud.backgroundView.blurStyle = LHBlurEffectStyleDark;
hud.centerBackgroundView.blurStyle = LHBlurEffectStyleNone;
hud.centerBackgroundView.backgroundColor = [UIColor clearColor];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [hud showSuccessWithStatus:@"Success" animated:YES];
    [hud hideAfterDelay:1.0 hiddenBlock:^{
        NSLog(@"HUD is hidden");
    }];
});
```
## GIf

```
LHProgressHUD * hud = [LHProgressHUD showAddedToView:self.view];
hud.mode = LHPRogressHUDModeGif;
hud.centerBackgroundView.blurStyle = LHBlurEffectStyleNone;
hud.centerBackgroundView.backgroundColor = [UIColor clearColor];
hud.gifImageView = [[LHGifImageView alloc] initWithGifImageName:@"gif"];
[hud hideAfterDelay:3.0];
```

<font color="red" size=4>You can get more deail by running the Example project </font>
##中文

如果你懂中文，可以在我的博客上看到[中文文档](http://blog.csdn.net/hello_hwc/article/details/51649610)

## Author

Leo, leomobiledeveloper@gmail.com

## License

LHProgressHUD is available under the MIT license. See the LICENSE file for more info.
