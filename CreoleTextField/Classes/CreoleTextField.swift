//
//  CreoleTextField.swift
//  MasterDemo
//
//  Created by Nirmalsinh Rathod on 3/17/17.
//  Copyright © 2017 Creole02. All rights reserved.
//

import UIKit
//MARK: - enumeration -

enum CreoleTextFieldType:Int {
  case none = 0
  case email = 1
  case postalcode = 2
  case dateOfBirth = 3
  case password = 4
  case phone = 5
}

//MARK: - Protocol -
@objc protocol CreoleTextFieldDelegate {
   func textFieldDidBeginEditing(_ textField: CreoleTextField)
   func textFieldShouldEndEditing(_ textField: CreoleTextField) -> Bool
   func textFieldDidEndEditing(_ textField: CreoleTextField)
   func textField(_ textField: CreoleTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) ->Bool
}

@IBDesignable
public class CreoleTextField: UITextField {
  var leftPaddingValue:CGFloat = 0.0//leftpadding space
  var rightPaddingValue:CGFloat = 0.0//right padding space
  var maxLength:Int = 255//set maximum length of textfield
  var currentTextFieldType:CreoleTextFieldType = .none//none = 0,email = 1.mobileNumber = 2,dateOfBirth = 3,password = 4
  weak var delegateObj:CreoleTextFieldDelegate?
  var isValidTextField:Bool = true
  var isFloatingTextField:Bool = false
  
  let animationDuration = 0.3//FloatLabelTextField
  var title = UILabel()//FloatLabelTextField
  
  //MARK: - Initialization -
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.setTextFieldView()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setTextFieldView()
  }
  
  override public func awakeFromNib() {
    setDelegate()
  }
  
  //MARK: - Ibinspactable -
  //textfield type like,none = 0,email = 1.mobileNumber = 2,dateOfBirth = 3,password = 4
  @IBInspectable public var TextfieldType:Int = 0{
    didSet{
      self.currentTextFieldType = CreoleTextFieldType(rawValue:TextfieldType)!
    }
  }
  //set corner radius
  @IBInspectable public var CornerRadius:CGFloat = 1.0{
    didSet{
      self.layer.cornerRadius = CornerRadius
      self.clipsToBounds = true
    }
  }
  //set leftpadding space into textfield
  @IBInspectable public var leftPadding:CGFloat = 0.0{
    didSet{
      self.leftPaddingValue = leftPadding
      //setLeftImage(leftImage: UIImage.init(named: "image5.jpeg")!)
    }
  }
  //set rightpadding space into textfield
  @IBInspectable public var rightPadding:CGFloat = 0.0{
    didSet{
      self.rightPaddingValue = rightPadding
    }
  }
  //set left image into textfield
  @IBInspectable public var leftImage:UIImage?{
    didSet{
      self.setLeftImage(leftImage: leftImage!)
    }
  }
  //set right image into texfield
  @IBInspectable public var rightImage:UIImage?{
    didSet{
      self.setRightImage(rightImage: rightImage!)
    }
  }
  //set maximum length of textfield text
  @IBInspectable public var maximumTextLength:Int = 255{
    didSet{
      if (maximumTextLength != 0)
      {
        self.maxLength = maximumTextLength
      }
    }
  }
  //cursor focus set or not into textfield
  @IBInspectable public var isResign:Bool = false{
    didSet{
      if isResign{
        self.resignFirstResponder()
      }
    }
  }
  //set becomefirstresponder
  @IBInspectable public var isBeginEditing:Bool = false{
    didSet{
      if isBeginEditing{
        self.becomeFirstResponder()
      }
    }
  }
  
  // MARK:- Properties
  override public var accessibilityLabel:String? {
    get {
      if let txt = text , txt.isEmpty {
        return title.text
      } else {
        return text
      }
    }
    set {
      self.accessibilityLabel = newValue
    }
  }
  
  override public var placeholder:String? {
    didSet {
      title.text = placeholder
      title.sizeToFit()
    }
  }
  
  override public var attributedPlaceholder:NSAttributedString? {
    didSet {
      title.text = attributedPlaceholder?.string
      title.sizeToFit()
    }
  }
  
  public var titleFont:UIFont = UIFont.systemFont(ofSize: 12.0) {
    didSet {
      title.font = titleFont
      title.sizeToFit()
    }
  }
  
  @IBInspectable public var hintYPadding:CGFloat = 0.0
  
  @IBInspectable public var titleYPadding:CGFloat = 0.0 {
    didSet {
      var r = title.frame
      r.origin.y = titleYPadding
      title.frame = r
    }
  }
  
  @IBInspectable public var titleTextColour:UIColor = UIColor.gray {
    didSet {
      if !isFirstResponder {
        title.textColor = titleTextColour
      }
    }
  }
  
  @IBInspectable public var titleActiveTextColour:UIColor! {
    didSet {
      if isFirstResponder {
        title.textColor = titleActiveTextColour
      }
    }
  }
  
  @IBInspectable public var isFloated:Bool = false{
    didSet{
      self.isFloatingTextField = isFloated
    }
  }
  
  //MARK: - set View and set delegate -
  
  public func setTextFieldView()
  {
    //  self.layer.borderColor = UIColor.white.cgColor
    //  self.layer.borderWidth = 2.0
    self.textColor = UIColor.black
    self.tintColor = UIColor.black//change cursor color
    //set keyboardtype into textfield and set other properties
    if(self.currentTextFieldType.rawValue == CreoleTextFieldType.dateOfBirth.rawValue){
      let datePicker = UIDatePicker()
      datePicker.datePickerMode = .date
      datePicker.maximumDate = Date()
      self.inputView = datePicker
      datePicker.addTarget(self, action: #selector(CreoleTextField.changeDatePickerValue(_:)), for: .valueChanged)
    }
    else if(self.currentTextFieldType.rawValue == CreoleTextFieldType.postalcode.rawValue){
      self.keyboardType = .numberPad
    }
    else if(self.currentTextFieldType.rawValue == CreoleTextFieldType.phone.rawValue){
      self.maxLength = 10
      self.keyboardType = .phonePad
    }
    else if (self.currentTextFieldType.rawValue == CreoleTextFieldType.password.rawValue){
      self.isSecureTextEntry = true
    }else if (self.currentTextFieldType.rawValue == CreoleTextFieldType.email.rawValue){
      self.keyboardType = .emailAddress
    }
    if self.isFloatingTextField{
      self.setup()
    }
  }
  
  //set only delegate
  public func setDelegate()
  {
    self.delegate = self
  }
  
  // set leftImage into textfield
  public func setLeftImage(leftImage:UIImage)
  {
    let leftView:UIView = UIView.init(frame: CGRect(x: 15, y: 7, width: self.frame.size.height/2.0 , height: self.frame.size.height/2.0))
    let leftImageView:UIImageView = UIImageView.init(frame: leftView.frame)
    leftImageView.contentMode = .scaleAspectFit
    leftImageView.image = leftImage
    leftView.addSubview(leftImageView)
    self.leftView = leftView
    self.leftViewMode = .always
  }
  
  // set rightImage into textfield
  public func setRightImage(rightImage:UIImage)
  {
    let rightView:UIView = UIView.init(frame: CGRect(x: 0, y: 4, width:  self.frame.size.height - 8, height: self.frame.size.height - 8))
    let rigthImageView:UIImageView = UIImageView.init(frame: rightView.frame)
    rigthImageView.image = rightImage
    rightView.addSubview(rigthImageView)
    self.rightView = rightView
    self.rightViewMode = .always
  }
  /*
   //adding space in left side of textfield
   public public func setLeftPadding(paddingSize:CGFloat)
   {
   let leftView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: paddingSize, height: self.frame.size.height))
   leftView.backgroundColor = UIColor.clear
   self.leftView = leftView
   self.leftViewMode = .always
   }
   //adding space in Right side of textfield
   public  setRightPadding(paddingSize:CGFloat)
   {
   let rightView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: paddingSize, height: self.frame.size.height))
   rightView.backgroundColor = UIColor.clear
   self.rightView = rightView
   self.rightViewMode = .always
   }
   */
  
  //check textfield validate or not
  public func validateTextField()
  {
    if (self.checkTextFieldNil()){
      self.isValidTextField = true
      if(self.currentTextFieldType.rawValue == CreoleTextFieldType.email.rawValue)
      {
        if !self.text!.TRIM().isValidEmail(){
          self.isValidTextField = false
        }
      }
      else if(self.currentTextFieldType.rawValue == CreoleTextFieldType.postalcode.rawValue)
      {
        
      }
      else if(self.currentTextFieldType.rawValue == CreoleTextFieldType.phone.rawValue){
        if !self.text!.TRIM().isValidMobile(){
          self.isValidTextField = false
        }
      }
    }
    else{
      self.isValidTextField = false
    }
  }
  
  
  
  //Action for change datepicker-when textfield type is date of birth
  public func changeDatePickerValue(_ sender:UIDatePicker)
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy"
    dateFormatter.dateFormat = "dd-MMM-yyyy"
    self.text = dateFormatter.string(from: sender.date)
  }
  
  //check textfiled nil or not
  public func checkTextFieldNil() -> Bool
  {
    let strTrimmed = self.text!.TRIM()//get trimmed string
    if(strTrimmed.characters.count == 0)//check textfield is nil or not ,if nil then return false
    {
      return false
    }
    return true
  }
  
}
//MARK: - Textfield delegate -

extension CreoleTextField:UITextFieldDelegate{
  public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //calling CSDelegate
    if delegateObj != nil{
      return (delegateObj?.textFieldShouldEndEditing(textField as! CreoleTextField))!
    }
    return true
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    self.validateTextField()//check validation and setvariable isValidTextField
    if (delegateObj != nil)
    {
      delegateObj?.textFieldDidEndEditing(textField as! CreoleTextField)
    }
  }
  
  //checking textfieldlength, if greater then return false
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    var isValidTextFieldTemp:Bool = true
    
    let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
    
    let strTrimmed = newString.TRIM()//get trimmed string
    //check length max or not
    isValidTextFieldTemp = (strTrimmed.characters.count <= self.maxLength)
    
    //checking mobilenumber field or not
    if(self.currentTextFieldType.rawValue == CreoleTextFieldType.postalcode.rawValue || self.currentTextFieldType.rawValue == CreoleTextFieldType.phone.rawValue){
      if isValidTextFieldTemp{
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        isValidTextFieldTemp = (string == numberFiltered)
      }
    }
    if isValidTextFieldTemp{
      if delegateObj != nil{
        isValidTextFieldTemp = (delegateObj?.textField(textField as! CreoleTextField, shouldChangeCharactersIn: range, replacementString: string))!
      }
    }
    
    return isValidTextFieldTemp
  }
  
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    if (delegateObj != nil){
      delegateObj?.textFieldDidBeginEditing(textField as! CreoleTextField)
    }
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  
//  set textRect and editing area into textfield
//    override public func textRect(forBounds bounds: CGRect) -> CGRect {
//      return CGRect(x: bounds.origin.x + self.leftPaddingValue, y: bounds.origin.y, width: bounds.width - rightPaddingValue - self.leftPaddingValue, height: bounds.height)
//    }
//  
//    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
//      return CGRect(x: bounds.origin.x + self.leftPaddingValue, y: bounds.origin.y, width: bounds.width - rightPaddingValue - self.leftPaddingValue, height: bounds.height)
//    }
  
  
  // MARK:- Overrides
  override public func layoutSubviews() {
    super.layoutSubviews()
    setTitlePositionForTextAlignment()
    let isResp = isFirstResponder
    if let txt = text , !txt.isEmpty && isResp {
      title.textColor = titleActiveTextColour
    } else {
      title.textColor = titleTextColour
    }
    // Should we show or hide the title label?
    if let txt = text , txt.isEmpty {
      // Hide
      hideTitle(isResp)
    } else {
      // Show
      showTitle(isResp)
    }
  }
  
  // MARK:- Private Methods/FloatLabelTextField
   public func setup() {
    borderStyle = UITextBorderStyle.none
    titleActiveTextColour = tintColor
    // Set up title label
    title.alpha = 0.0
    title.font = titleFont
    title.textColor = titleTextColour
    if let str = placeholder , !str.isEmpty {
      title.text = str
      title.sizeToFit()
    }
    self.addSubview(title)
  }
  
   public func maxTopInset()->CGFloat {
    if let fnt = font {
      return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0))
    }
    return 0
  }
  
   public func setTitlePositionForTextAlignment() {
    let r = textRect(forBounds: bounds)
    var x = r.origin.x
    if textAlignment == NSTextAlignment.center {
      x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
    } else if textAlignment == NSTextAlignment.right {
      x = r.origin.x + r.size.width - title.frame.size.width
    }
    title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
  }
  
   public func showTitle(_ animated:Bool) {
    let dur = animated ? animationDuration : 0
    UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
      // Animation
      self.title.alpha = 1.0
      var r = self.title.frame
      r.origin.y = self.titleYPadding
      self.title.frame = r
    }, completion:nil)
  }
  
  public func hideTitle(_ animated:Bool) {
    let dur = animated ? animationDuration : 0
    UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
      // Animation
      self.title.alpha = 0.0
      var r = self.title.frame
      r.origin.y = self.title.font.lineHeight + self.hintYPadding
      self.title.frame = r
    }, completion:nil)
  }
  
  
  override public func textRect(forBounds bounds:CGRect) -> CGRect {
    
    var r =  CGRect(x: bounds.origin.x + self.leftPaddingValue, y: bounds.origin.y, width: bounds.width - rightPaddingValue - self.leftPaddingValue, height: bounds.height)
    // var r = super.textRect(forBounds: bounds)
    if let txt = text , !txt.isEmpty {
      var top = ceil(title.font.lineHeight + hintYPadding)
      top = min(top, maxTopInset())
      r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
    }
    return r.integral
  }
  
  override public func editingRect(forBounds bounds:CGRect) -> CGRect {
    var r =  CGRect(x: bounds.origin.x + self.leftPaddingValue, y: bounds.origin.y, width: bounds.width - rightPaddingValue - self.leftPaddingValue, height: bounds.height)
    if let txt = text , !txt.isEmpty {
      var top = ceil(title.font.lineHeight + hintYPadding)
      top = min(top, maxTopInset())
      r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top,0.0, 0.0, 0.0))
      // Initialization code
    }
    return r.integral
  }
  
  override public func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
    var r = super.clearButtonRect(forBounds: bounds)
    if let txt = text , !txt.isEmpty {
      var top = ceil(title.font.lineHeight + hintYPadding)
      top = min(top, maxTopInset())
      r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
    }
    return r.integral
  }
  
  
}

extension String{
  
  //MARK: - Email Validation
  
  public func isValidEmail() -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
  }
  
  //MARK:- Trimming
  
  //     removing whitespace (remove space from leading and trailing  of text)
  public func TRIM() -> String{
    let strTrimmed = (NSString(string:self)).trimmingCharacters(in: CharacterSet.whitespaces)
    return strTrimmed
  }
  
  
  //MARK: - Mobile Validation
  
 public func isValidMobile() -> Bool{
    let PHONE_REGEX = "^\\d{10}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: self)
    return result
  }
  
  
 public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    return boundingBox.height + 24
  }
  
 public func toBool() -> Bool? {
    switch self {
    case "True", "true", "yes", "1":
      return true
    case "False", "false", "no", "0":
      return false
    default:
      return nil
    }
  }
  
  
}
