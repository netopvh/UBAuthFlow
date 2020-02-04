//
//  PinTextInputView.swift
//  PinTextField
//
//  Created by Usemobile on 13/06/19.
//  Copyright © 2019 Tulio Parreiras. All rights reserved.
//

import UIKit

public protocol PinTextInputViewDelegate: class {
    func pinTextInputViewShouldReturn(_ view: PinTextInputView) -> Bool
    func pinTextInputView(_ view: PinTextInputView, didChange code: String)
}

public class PinTextInputView: UIView {
    
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = self.font
        textField.leftView = self.leftView
        textField.leftViewMode = .always
        textField.keyboardType = .numberPad
        textField.tintColor = .clear
        textField.textContentType = self.textContentType
//        textField.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
        self.addSubview(textField)
        return textField
    }()
    
    private lazy var leftView: UIView = {
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 10, height: 20)))
        view.backgroundColor = .clear
        return view
    }()
    
    weak public var delegate: PinTextInputViewDelegate?
    
    public var text: String?
    
    @IBInspectable public var borderLineHeight: CGFloat = 2
    @IBInspectable public var borderColor: UIColor = .black {
        didSet {
            self.setupBorders()
        }
    }
    @IBInspectable public var maxNumberOfCharacters: CGFloat = 4
    @IBInspectable public var borderSpacing: CGFloat = 10
    @IBInspectable public var textContentType: UITextContentType? = nil {
        didSet {
            self.textField.textContentType = self.textContentType
        }
    }
    @IBInspectable public var font: UIFont = .systemFont(ofSize: 30) {
        didSet {
            self.textField.font = self.font
        }
    }
    @IBInspectable public var textColor: UIColor = .black {
        didSet {
            self.textField.textColor = self.textColor
        }
    }
    
    
    private var lastKernWidth: CGFloat = 0
    private var borderWidth: CGFloat {
        return (self.bounds.width - self.borderSpacing * (self.maxNumberOfCharacters - 1)) / self.maxNumberOfCharacters
    }
    private var attributedKerns: [CGFloat] = []
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTextField()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTextField()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setupBorders()
        self.leftView.frame.size.width = self.borderWidth / 2
    }
    
    
    private func setupTextField() {
        self.backgroundColor = .clear
        self.textField.delegate = self
        self.addConstraints([
            self.textField.topAnchor.constraint(equalTo: self.topAnchor),
            self.textField.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.textField.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
    }
    
    private func setupBorders() {
        let borderName = "BorderLayer"
        self.layer.sublayers?.filter({ $0.name == borderName }).forEach({ $0.removeFromSuperlayer() })
        
        let borderLayer = CAShapeLayer()
        borderLayer.name = borderName
        
        borderLayer.path = self.getBorderPath().cgPath
        borderLayer.lineWidth = self.borderLineHeight
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = self.borderColor.cgColor
        
        self.layer.addSublayer(borderLayer)
    }
    
    private func getBorderPath() -> UIBezierPath {
        let height = self.bounds.height
        let width = self.bounds.width
        let borderYPosition = height
        let path = UIBezierPath()
        
        for index in 0 ..< Int(self.maxNumberOfCharacters) {
            switch index {
            case 0:
                // Add First Border Line
                path.move(to: .init(x: 0, y: borderYPosition))
                path.addLine(to: .init(x: self.borderWidth, y: borderYPosition))
                path.move(to: .init(x: self.borderWidth, y: borderYPosition))
            case (Int(self.maxNumberOfCharacters) - 1):
                // Add Last Border Line
                path.move(to: .init(x: CGFloat(index) * (self.borderWidth + self.borderSpacing), y: borderYPosition))
                path.addLine(to: .init(x: width, y: borderYPosition))
                path.move(to: .init(x: width, y: borderYPosition))
            default:
                // Add Others Borders Lines
                path.move(to: .init(x: CGFloat(index) * (self.borderWidth + self.borderSpacing), y: borderYPosition))
                let point = CGPoint.init(x: CGFloat(index + 1) * self.borderWidth + CGFloat(index) * self.borderSpacing, y: borderYPosition)
                path.addLine(to: point)
                path.move(to: point)
            }
        }
        
        path.close()
        return path
    }
    
    override public func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        return self.textField.resignFirstResponder()
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        self.delegate?.pinTextInputView(self, didChange: textField.text ?? "")
    }
    
}

extension PinTextInputView: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return self.delegate?.pinTextInputViewShouldReturn(self) ?? true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if !self.attributedKerns.isEmpty {
                self.attributedKerns.removeLast()
            }
            if textField.text != "" {
                var text = textField.text
                text?.removeLast()
                self.delegate?.pinTextInputView(self, didChange: text ?? "")
            }
            return true
        }
        let text = textField.text ?? ""
        if text.count == Int(self.maxNumberOfCharacters) {
            textField.resignFirstResponder()
            let _ = self.textFieldShouldReturn(self.textField)
            return false
        }
        let attributedText = text + string
        let attributedString = NSMutableAttributedString(string: attributedText)
        attributedString.addAttribute(.font, value: self.font, range: NSRange(location: 0, length: attributedText.count))
        attributedString.addAttribute(.foregroundColor, value: self.textColor, range: NSRange(location: 0, length: attributedText.count))
        let textWidth = NSString(string: string).size(withAttributes: [NSAttributedString.Key.font: self.font]).width
        let textSpacing: CGFloat = (self.borderWidth - textWidth) / 2
        
        if text.isEmpty {
            textField.defaultTextAttributes.updateValue(textSpacing, forKey: NSAttributedString.Key.kern)
            self.leftView.frame.size.width = textSpacing
        } else {
            let adjustedSpacing: CGFloat = self.lastKernWidth + self.borderSpacing + textSpacing
            self.attributedKerns.append(adjustedSpacing)
        }
        
        for (index, value) in self.attributedKerns.enumerated() {
            if attributedText.count > index + 1 {
                attributedString.addAttribute(.kern, value: value, range: NSRange(location: index, length: 1))
            }
        }
        if attributedText.count == Int(self.maxNumberOfCharacters) {
            attributedString.addAttribute(.kern, value: 0, range: NSRange(location: Int(self.maxNumberOfCharacters - 1), length: 1))
        }
        self.lastKernWidth = textSpacing
        textField.attributedText = attributedString
        self.text = attributedString.string
        if attributedText.count == Int(self.maxNumberOfCharacters) {
            textField.resignFirstResponder()
            let _ = self.textFieldShouldReturn(self.textField)
            self.textDidChange(textField)
            return false
        }
        self.textDidChange(textField)
        return false
        
    }
}
