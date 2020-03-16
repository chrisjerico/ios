# STPickerView

![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)
![Pod version](https://img.shields.io/cocoapods/v/STPickerView.svg?style=flat)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform info](https://img.shields.io/cocoapods/p/STPickerView.svg?style=flat)](http://cocoadocs.org/docsets/STPickerView)

一个多功能的选择器,有城市选择，日期选择和单数组源自定的功能，方便大家的使用,低耦合,易扩展。如果大家喜欢请给个星星，我将不断提供更好的代码。

----------------------------

## 一、使用

1. 使用Pod方式 `pod 'STPickerView', '2.4'`
2. 使用Carthage方式 `github 'STShenzhaoliang/STPickerView' '2.4'`
3. Swift使用Pod方式，Podfile文件添加

```ruby
use_frameworks!
```

If you added `SVProgressHUD` manually, just add a [bridging header](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html) file to your project with the `SVProgressHUD` header included.

## 二、效果图展示
### 1.城市选择器效果图
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STPickerView/show0.gif)
### 2.日期选择器效果图
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STPickerView/show2.gif)
### 3.单数组效果图
#### 根据单数据的模式，可以扩展多数据的模式
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STPickerView/show1.gif)

### 4.中间的显示模式
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STPickerView/show4.png)

## 三、接口
### 1.显示模式枚举
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STPickerView/picture0.jpg)
### 2.视图接口
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STPickerView/picture1.jpg)
### 3.方法接口
![image](https://github.com/STShenZhaoliang/STImage/blob/master/STPickerView/picture2.jpg)

## 四、使用举例

```objective-c

STPickerSingle *pickerSingle = [[STPickerSingle alloc]init];
[pickerSingle setArrayData:arrayData];
[pickerSingle setTitle:@"请选择价格"];
[pickerSingle setTitleUnit:@"人民币"];
[pickerSingle setContentMode:STPickerContentModeCenter];
[pickerSingle setDelegate:self];
[pickerSingle show];

```

## 五、版本信息
## 2.4
1. 修复iphonePlus的显示问题

### 2.3
1. 地区选择器添加记录之前地区接口

### 2.2
1. 修改日期选择的问题

### 2.1
1. 支持横竖屏
2. 修改日期选择的问题
3. 优化界面

### 2.0
1. 添加Carthage的支持

### 1.0.0
1. 支持城市，时间，单项选择
2. 支持中间和下方显示


