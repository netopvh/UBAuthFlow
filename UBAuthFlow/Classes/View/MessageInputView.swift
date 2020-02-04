//
//  MessageInputView.swift
//  MessageInputView
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import UIKit

let screenSize = UIScreen.main.bounds

protocol MessageInputViewDelegate: class {
    
    // TextViewDelegate methods
    func inputView(textView: UITextView, shouldChangeTextInRange: NSRange, replacementText: String) -> Bool
    func inputViewDidChange(textView: UITextView)
    func inputViewDidBeginEditing(textView: UITextView)
    func inputViewShouldBeginEditing(textView: UITextView) -> Bool
    func inputViewReturnPressed(textField: UITextField) -> Bool
    
    // Button tap callback methods
    func inputViewDidTapButton(button: UIButton)
}
enum KeyboardType {
    case mail
    case password
    case text
    case number
}
@IBDesignable
class MessageInputView: UIView {
    public typealias ReturnPressed = (String) -> Void
    var returnPressed: ReturnPressed?
    var editingChanged: ReturnPressed?
    
    var autocapitalizationType : UITextAutocapitalizationType = .words {
        didSet {
            self.textField.autocapitalizationType = autocapitalizationType
        }
    }
    
    var isSecureTextEntry: Bool = false {
        didSet {
            self.textField.isSecureTextEntry = isSecureTextEntry
        }
    }
    
    var returnKeyType: UIReturnKeyType = UIReturnKeyType.done {
        didSet {
            self.textField.returnKeyType = returnKeyType
        }
    }
    var enablesReturnKeyAutomatically: Bool = false {
        didSet {
            self.textField.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        }
    }
    var keyboardType: UIKeyboardType = UIKeyboardType.emailAddress {
        didSet {
            self.textField.keyboardType = keyboardType
        }
    }
    @IBInspectable public var textMask: String = "" {
        didSet {
            self.updateText()
        }
    }
    
    
    @IBInspectable var clearButton: Bool = true {
        didSet {
            self.setClearButton()
        }
    }
    
    var isNumber = false
    
    var borderColor: UIColor = .gray {
        didSet {
            self.setBorderColor(borderColor)
        }
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            self.setPlaceholder()
        }
    }
    
    var defaultText: String? {
        didSet {
            self.textField.text = self.defaultText
        }
    }
    var text: String? {
        didSet {
            self.editingChanged?(self.text ?? "")
        }
    }
    var formattedText: String? {
        didSet {
            self.textField.text = self.formattedText
            if let text = self.formattedText {
                self.text = self.clearFormatCoponents(text)
            }
        }
    }
    
    open var allowWhiteSpaces: Bool = true
    
    // Views
    var mainView = UIView()
    private var textField = UITextField(frame: .zero)//UITextView(frame: .zero)
    
    // Heights
    var originalViewHeight: CGFloat = 0.0
    var containerViewHeight: CGFloat {
        let top: CGFloat = 4.0
        let bottom: CGFloat = 4.0
        return originalViewHeight - (top + bottom)
    }
    var lineHeight: CGFloat = 0.0
    
    // Delegate
    var delegate: MessageInputViewDelegate?
    
    private var btnSecurity = UIButton(type: .system)
    private var arrowView = ArrowView()
    
    var settings: TextFieldSettings
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            self.textField.textColor = self.settings.textColor.withAlphaComponent(self.isUserInteractionEnabled ? 1 : 0.1)
        }
    }
    
    init(settings: TextFieldSettings) {
        self.settings = settings
        super.init(frame: .zero)
        self.setupView()
        self.setTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.settings = .default
        super.init(coder: aDecoder)
        self.setupView()
        self.setTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if originalViewHeight == 0 {
            originalViewHeight = frame.height
        }
        
        mainView.layer.borderWidth = self.settings.borderWidth
        DispatchQueue.main.async {
            self.mainView.layer.cornerRadius = self.containerViewHeight / 2.0
        }
    }
    
    fileprivate func setupView() {
        setContainerView()
    }
    
    fileprivate func setContainerView() {
        mainView = UIView(frame: .zero)
        addSubview(mainView)
        self.setBorderColor(self.settings.unSelectedBorderColor)
        
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: mainView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: mainView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 4)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: 4)
        
        addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    func setBorderColor(_ color: UIColor) {
        mainView.layer.borderColor = color.cgColor
    }
    
    func setClearButton() {
        textField.clearButtonMode = clearButton ? .unlessEditing : .never
    }
    
    func setPlaceholder() {
        textField.attributedPlaceholder = NSAttributedString(string: self.placeholder, attributes: [NSAttributedString.Key.font: self.settings.placeholderFont, NSAttributedString.Key.foregroundColor: self.settings.placeholderColor])
    }
    
    fileprivate func setTextView() {
        
        if textField.delegate == nil {
            textField = UITextField(frame: .zero)
            textField.delegate = self
            
            
            self.setClearButton()
            textField.font = self.settings.font
            textField.textColor = UIColor.gray
            
            self.setPlaceholder()
            
            let rightPadding: CGFloat = clearButton ? -8.0 : -12.0
            
            mainView.addSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12.0).isActive = true
            self.cnstTxvTralling = textField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: rightPadding)
            self.cnstTxvTralling.isActive = true
            //            textView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: rightPadding).isActive = true
            
            textField.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0.0).isActive = true
            textField.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0.0).isActive = true
            textField.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
            
        }
    }
    
    private var cnstTxvTralling = NSLayoutConstraint()
    
    private func updatePassConstrains() {
        self.cnstTxvTralling.constant = -(4 + (self.bounds.height))
    }
    
    func setupNumber() {
        textField.keyboardType = .numberPad
    }
    
    func setupText() {
        textField.returnKeyType = .next
        textField.keyboardType = .asciiCapable
        textField.enablesReturnKeyAutomatically = true
        
    }
    
    func setupEmail() {
        textField.returnKeyType = .next
        textField.enablesReturnKeyAutomatically = true
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
    }
    
    func setupPassword() {
        textField.isSecureTextEntry = true
        textField.keyboardType = .asciiCapable
        textField.enablesReturnKeyAutomatically = true
        self.clearButton = false
        DispatchQueue.main.async {
            self.addSecButton()
            self.updatePassConstrains()
        }
    }
    
    func setupPhone(language: String) {
        textField.keyboardType = .phonePad
        if language == "es-BO"{
            textMask = "########"
        }else{
           textMask = "(##) #####-####"
        }
        
        self.isNumber = true
    }
    
    func setupCPF(language: String) {
        textField.keyboardType = .phonePad
        if language == "es-BO"{
            textMask = "#######"
        }else{
            textMask = "###.###.###-##"
        }
        self.isNumber = true
    }
    
    var pickerArray: [String]?
    var pickerTitle: String?
    var pickerSelectedIndex: Int?
    
    func setupPicker(_ array: [String], pickerTitle: String? = nil) {
        self.clearButton = false
        self.pickerArray = array
        self.pickerTitle = pickerTitle
        self.addArrowView()
    }
    
    fileprivate func addSecButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let settingsImage = self.textField.isSecureTextEntry ? self.settings.noSecurityImage : self.settings.hasSecurityImage
        let imageName = self.textField.isSecureTextEntry ? "eye" : "eye-closed"
        button.setImage(settingsImage ?? UIImage.getFrom(customClass: MessageInputView.self, nameResource: imageName), for: .normal)
        button.addTarget(self, action: #selector(self.secPressed(_:)), for: .touchUpInside)
        self.addSubview(button)
        self.addConstraints([
            button.heightAnchor.constraint(equalToConstant: self.bounds.height),
            button.widthAnchor.constraint(equalTo: button.heightAnchor),
            button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        self.btnSecurity = button
    }
    
    fileprivate func addArrowView() {
        let view = ArrowView()
        view.color = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.addConstraints([
            view.heightAnchor.constraint(equalToConstant: 9),
            view.widthAnchor.constraint(equalToConstant: 16),
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        self.arrowView = view
    }
    
    @objc private func secPressed(_ sender: UIButton) {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        let settingsImage = self.textField.isSecureTextEntry ? self.settings.noSecurityImage : self.settings.hasSecurityImage
        let imageName = self.textField.isSecureTextEntry ? "eye" : "eye-closed"
        self.btnSecurity.setImage(settingsImage ?? UIImage.getFrom(customClass: MessageInputView.self, nameResource: imageName), for: .normal)
        if textField.isFirstResponder {
            self.textField.becomeFirstResponder()
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
    
    @objc fileprivate func didTapButton(sender: UIButton) {
        if let delegate = delegate {
            delegate.inputViewDidTapButton(button: sender)
        }
    }
    
    private func updateText() {
        let newString0 = self.formattedText ?? self.defaultText ?? ""
        guard newString0.count <= self.textMask.count else { return }
        let newString1 = self.clearFormatCoponents(string: newString0)
        let newString = self.getNumberFormatted(number: newString1)
        self.formattedText = newString
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        if self.textMask.isEmpty {
            self.text = textField.text
        }
    }
    
    func presentActionSheet(title: String?, array: [String], completion: @escaping(_ value: String?, _ index: Int?, _ cancel: Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for (index, text) in array.enumerated() {
            alertController.addAction(UIAlertAction(title: text, style: .default, handler: { _ in
                completion(array[index], index, false)
            }))
        }
        alertController.addAction(UIAlertAction(title: .cancel, style: .destructive, handler: { _ in
            completion(nil, nil, true)
        }))
        
        alertController.popoverPresentationController?.sourceView = self.superview
        UIViewController.top?.present(alertController, animated: true, completion: nil)
    }
}
extension MessageInputView: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.text = ""
        self.defaultText = ""
        self.textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 && range.location == 0 && string == " " { return false }
        guard !textMask.isEmpty else {
            if !self.allowWhiteSpaces && string == " " { return false }
            //            self.textDidChange(textField)
            return true
        }
        let newString0 = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        guard newString0.count <= self.textMask.count else {
            let _ = self.textFieldShouldReturn(textField)
            return false
        }
        let newString1 = self.clearFormatCoponents(string: newString0)
        let newString = self.getNumberFormatted(number: newString1)
        self.setTextWithoutChangingRange(old: range, newString: newString, replacementString: string)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.borderColor = self.settings.selectedBorderColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.pickerArray != nil {
            if let isEmpty = self.formattedText?.isEmpty {
                self.borderColor = isEmpty ? self.settings.unSelectedBorderColor : self.settings.hasContentBorderColor
            }
        } else {
            if let isEmpty = textField.text?.isEmpty {
                self.borderColor = isEmpty ? self.settings.unSelectedBorderColor : self.settings.hasContentBorderColor
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let array = self.pickerArray {
            self.borderColor = self.settings.selectedBorderColor
            self.presentActionSheet(title: self.pickerTitle ?? self.placeholder, array: array) { (selectedValue, selectedIndex, cancel) in
                if !cancel {
                    self.formattedText = selectedValue
                    self.text = selectedValue
                    self.pickerSelectedIndex = selectedIndex
                    self.returnPressed?(self.formattedText ?? "")
                } else {
                    let _ = self.resignFirstResponder()
                }
                self.borderColor = self.formattedText == nil ? self.settings.unSelectedBorderColor : self.settings.hasContentBorderColor
            }
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let _returnPressed = returnPressed {
            _returnPressed(textField.text!)
        }
        return true
    }
}

extension MessageInputView {
    
    private func isNumber(_ char: Character) -> Bool {
        return Int("\(char)") != nil
    }
    
    private func clearFormatCoponents(string: String) -> String {
        return self.clearFormatCoponents(string)
    }
    
    private func getNumberFormatted(number: String) -> String {
        return self.getNumberFormatted(number: number, mask: self.textMask)
    }
    
    private func setTextWithoutChangingRange(old range: NSRange, newString: String, replacementString string: String) {
        if range.location != (self.formattedText ?? "").count,
            let oldRange = self.textField.selectedTextRange, !(self.text ?? "").isEmpty {
            let isUp = string != ""
            if range.length > 1 && !isUp {
                UIPasteboard.general.string = self.formattedText?[range]
            }
            self.formattedText = newString
            if let position = self.textField.position(from: oldRange.start, offset: isUp ? 1 : range.length > 1 ? 0 : -1) {
                self.textField.selectedTextRange = self.textField.textRange(from: position, to: position)
            } else {
                self.textField.selectedTextRange = self.textField.textRange(from: oldRange.start, to: oldRange.start)
            }
        } else {
            self.formattedText = newString
        }
        self.textDidChange(self.textField)
    }
    
    @objc func cancelAction() {
        let _ = resignFirstResponder()
    }
    
    func clearFormatCoponents(_ string: String) -> String {
        let pattern = UnicodeScalar("0")..."9"
        return String(string.unicodeScalars
            .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    func getNumberFormatted(number: String, mask: String) -> String {
        var returnText = ""
        var i = 0
        let maskArray = Array(mask)
        for char in number {
            let currCharMask = maskArray[i]
            if currCharMask == "#" {
                returnText.append(char)
            } else {
                returnText.append("\(currCharMask)")
                i += 1
                var found = false
                for j in i..<maskArray.count {
                    if !found {
                        let mask = maskArray[j]
                        if mask == "#" {
                            returnText.append("\(char)")
                            found = true
                        } else {
                            returnText.append("\(mask)")
                            i += 1
                        }
                    }
                }
            }
            i += 1
        }
        return returnText
    }
    
}



extension String {
    
    subscript(_ range: NSRange) -> String? {
        var substring = ""
        guard range.location + range.length - 1 < self.count else { return nil }
        let string = Array(self)
        for i in range.location..<(range.location + range.length) {
            substring.append(string[i])
        }
        return substring
    }
    
    subscript(value: CountableClosedRange<Int>) -> String {
        get {
            return "\(self[index(at: value.lowerBound)...index(at: value.upperBound)])"
        }
    }
    
    subscript(value: CountableRange<Int>) -> String {
        get {
            return String(self[index(at: value.lowerBound)..<index(at: value.upperBound)])
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> String {
        get {
            return String(self[..<index(at: value.upperBound)])
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> String {
        get {
            return String(self[...index(at: value.upperBound)])
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> String {
        get {
            return String(self[index(at: value.lowerBound)...])
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}
