# CreoleTextField

[![CI Status](http://img.shields.io/travis/Nirmalsinh07/CreoleTextField.svg?style=flat)](https://travis-ci.org/Nirmalsinh07/CreoleTextField)
[![Version](https://img.shields.io/cocoapods/v/CreoleTextField.svg?style=flat)](http://cocoapods.org/pods/CreoleTextField)
[![License](https://img.shields.io/cocoapods/l/CreoleTextField.svg?style=flat)](http://cocoapods.org/pods/CreoleTextField)
[![Platform](https://img.shields.io/cocoapods/p/CreoleTextField.svg?style=flat)](http://cocoapods.org/pods/CreoleTextField)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 3.0 
iOS 10 and above

## Description

CreoleTextfield is a textfield object which manage to do automatically validation based of type which you have select.

    Supported Textfield Type:
    1.None
    2.Email
    3.Password
    4.PhoneNumber
    5.Postal code
    6.Date of birth

## Manual Installation

If you don't want use pod, then you can drag CreoleTextField file into your project and directly use it. 
Here is Swift Code:
```ruby
   let yourTextField = CSTextField.init(frame: CGRect.init(x: 50, y: 50, width: 200, height: 30))//create textfield object and set frame
   yourTextField.TextfieldType = CSTextFieldType.email.rawValue// set textfield type like email, none,             password,dateofbirth,phone,postalcode
   yourTextField.maxLength = 200//set textfield length
   yourTextField.setTextFieldView()//set all property that given up
   yourTextField.delegateObj = self//set delegate if user want to implement some functionality when user typing or after typing
   ```

## Installation

CreoleTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CreoleTextField"
```

## Author

Nirmalsinh Rathod, 
nirmasinh@creolestudios.com
www.creolestudios.com

## License

CreoleTextField is available under the MIT license. See the LICENSE file for more info.
