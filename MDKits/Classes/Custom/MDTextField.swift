//
//  MDTextField.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/12/3.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import UIKit

public protocol MDTextFieldDelegate: AnyObject {
    func textFieldDidBeginEditing(_ textField: MDTextField)
    func textFieldDidEndEditing(_ textField: MDTextField)
    func textFieldShouldReturn(_ textField: MDTextField) -> Bool
    func textField(_ textField: MDTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldDidChange(_ textField: MDTextField)
    func textFieldDidTapMultilineAction(_ textField: MDTextField)
}

public extension MDTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: MDTextField) {
        // Default empty implementation
    }

    func textFieldDidEndEditing(_ textField: MDTextField) {
        // Default empty implementation
    }

    func textFieldShouldReturn(_ textField: MDTextField) -> Bool {
        return true
    }

    func textField(_ textField: MDTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func textFieldDidChange(_ textField: MDTextField) {
     
    }

    func textFieldDidTapMultilineAction(_ textField: MDTextField) {
        
    }
}

public class MDTextField: UIView {

    private var underlineHeightConstraint: NSLayoutConstraint?
    
    public weak var delegate: MDTextFieldDelegate?
    
    
    public var placeholderText: String = "" {
        didSet {
            accessibilityLabel = placeholderText
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                                 attributes: [.foregroundColor: MDColor.textWhite])
        }
    }
    
    public var helpText: String? {
        didSet {
            helpTextLabel.text = helpText
        }
    }
    
    public var text: String? {
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isSecureMode: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureMode
        }
    }
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    var returnKeyType: UIReturnKeyType = .done {
        didSet {
            textField.returnKeyType = returnKeyType
        }
    }
    var textContentType: UITextContentType? {
        didSet {
            if #available(iOS 10.0, *) {
                textField.textContentType = textContentType
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    public var isValid: Bool = true {
        didSet {
            self.layoutIfNeeded()
            if isValid == false{
                self.state = .error
            }
            self.helpTextLabel.alpha = self.isValid ? 0 : 1.0
        }
    }

    
    private var state: State = .normal {
        didSet {
            transition(to: state)
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(textField)
        addSubview(underline)
        addSubview(helpTextLabel)
        
        textField.pin(edges: .left,.right,.top)
        
        underline.pin(edges: .left,.right)
        underline.pin(.top,off: textField,to: .bottom)
        underlineHeightConstraint = underline.md.height == 1
        
        helpTextLabel.pin(edges: .left,.right)
        helpTextLabel.pin(.bottom)
        helpTextLabel.pin(.top,off: textField,to: .bottom,offset: 10)
    }
    
    private lazy var underline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#FFFFFF", alpha: 0.8)
        return view
    }()
    
    private lazy var helpTextLabel: UILabel = {
        let label = UILabel(textColor: "#F5A623".hexColor(), fondSize: 12, TextAlignment: .left)
        label.alpha = 0
        return label
    }()
    
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = MDFont.regularFont(ofSize: 14)
        textField.textColor = MDColor.textWhite
        textField.tintColor = MDColor.textWhite
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        if #available(iOS 10.0, *) {
            textField.adjustsFontForContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        return textField
    }()
    
    private func transition(to state: State) {
        layoutIfNeeded()
        underlineHeightConstraint?.constant = state.underlineHeight

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.underline.backgroundColor = state.underlineColor
            self.helpTextLabel.textColor = state.accessoryLabelTextColor
        }
    }
    
    @objc private func textFieldDidChange() {
        delegate?.textFieldDidChange(self)
    }
}

// MARK: - UITextFieldDelegate
extension MDTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
        state = .focus
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(self)

        if let text = text, !text.isEmpty, !isValid {
            state = .error
        } else {
            state = .normal
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn(self) ?? true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}

public extension MDTextField {
    enum State {
        case normal,focus,disabled,error,readOnly
        
        var underlineHeight: CGFloat {
            switch self {
            case .normal, .disabled:
                return 1
            case .focus, .error:
                return 2
            case .readOnly:
                return 0
            }
        }
        
        var underlineColor: UIColor {
            switch self {
            case .normal,.disabled:
                return UIColor(hexString: "#FFFFFF", alpha: 0.8)
            case .focus:
                return MDColor.textWhite
            case .error:
                return "#F5A623".hexColor()
            case .readOnly:
                return .clear
            }
        }
        

        var accessoryLabelTextColor: UIColor {
            switch self {
            case .disabled, .readOnly, .normal, .focus:
                return .clear
            case .error:
                return "#F5A623".hexColor()
            }
        }
    }

}
