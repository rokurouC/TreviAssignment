//
//  MatrixInputView.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit

protocol MatrixInputViewDelegate where Self: UIViewController {
    func matrixInputViewDidConfirmMatrix(matrixInputView: MatrixInputView, matrix: Matrix)
    func matrixInputViewDidCancel(matrixInputView: MatrixInputView)
}

enum MatrixInputViewError: String {
    case InvaildColumn = "请输入有效的列数，必须为大于0的整数。"
    case InvaildRow = "请输入有效的行数，必须为大于0的整数。"
    case MatrixNotSet = "请先设置行与列"
}

class MatrixInputView: UIView {
    static func genInputTextField() -> UITextField {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }
    
    static func genControlButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .init(red: 74/256.0, green: 144/256.0, blue: 226/256.0, alpha: 1)
        return button
    }
    
    static func genRowTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }
    
    var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "请输入行与列"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(red: 208/256.0, green: 2/256.0, blue: 27/256.0, alpha: 1)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    var columnNumberTextField: UITextField = MatrixInputView.genInputTextField()
    var rowNumberTextField: UITextField = MatrixInputView.genInputTextField()
    
    var cancelButton = MatrixInputView.genControlButton(title: "取消")
    var confirmButton = MatrixInputView.genControlButton(title: "确认")
    
    weak var delegate: MatrixInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the configuration of self and subviews.
    private func configure() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .white
        columnNumberTextField.delegate = self
        rowNumberTextField.delegate = self
        cancelButton.addTarget(self, action: #selector(onCancelButtonTap), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(onConfirmButtonTap), for: .touchUpInside)
    }
    
    /// Setup layout of the subviews.
    private func setSubViewsLayout() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignAllResponse))
        self.addGestureRecognizer(tap)
        
        let columnLabel = MatrixInputView.genRowTitleLabel(title: "列")
        let rowLabel = MatrixInputView.genRowTitleLabel(title: "行")
        
        let columnInputStackView = UIStackView(arrangedSubviews: [columnLabel, columnNumberTextField])
        columnInputStackView.axis = .horizontal
        columnInputStackView.alignment = .center
        columnInputStackView.distribution = .fillProportionally
        
        let rowInputStackView = UIStackView(arrangedSubviews: [rowLabel, rowNumberTextField])
        rowInputStackView.axis = .horizontal
        rowInputStackView.alignment = .center
        rowInputStackView.distribution = .fillProportionally
        
        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 30
        
        let inputStackView = UIStackView(arrangedSubviews: [ columnInputStackView, rowInputStackView])
        inputStackView.axis = .vertical
        inputStackView.spacing = 15
        inputStackView.distribution = .fillEqually
        
        self.addSubview(hintLabel)
        hintLabel.centerXInSuperview()
        hintLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50).isActive = true
        
        self.addSubview(inputStackView)
        inputStackView.anchor(top: hintLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 60))
        inputStackView.centerXInSuperview()
        columnLabel.constrainWidth(constant: 30)
        rowLabel.constrainWidth(constant: 30)
        
        self.addSubview(errorLabel)
        errorLabel.centerXInSuperview()
        errorLabel.anchor(top: inputStackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        self.addSubview(buttonStackView)
        buttonStackView.centerXInSuperview()
        buttonStackView.anchor(top: errorLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 15, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 30))
    }
    
    @objc func resignAllResponse() {
        columnNumberTextField.resignFirstResponder()
        rowNumberTextField.resignFirstResponder()
    }
    
    func showError(_ error:MatrixInputViewError) {
        errorLabel.text = error.rawValue
    }
}

// MARK: UITextFieldDelegate
extension MatrixInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.text = ""
    }
}

// MARK: Selectors
extension MatrixInputView {
    @objc fileprivate func onCancelButtonTap() {
        resignAllResponse()
        self.delegate?.matrixInputViewDidCancel(matrixInputView: self)
    }
    
    @objc fileprivate func onConfirmButtonTap() {
        resignAllResponse()
        guard let column = UInt(columnNumberTextField.text ?? ""), column >= 1 else {
            showError(.InvaildColumn)
            return
        }
        guard let row = UInt(rowNumberTextField.text ?? ""), row >= 1 else {
            showError(.InvaildRow)
            return
        }
        self.delegate?.matrixInputViewDidConfirmMatrix(matrixInputView: self, matrix: Matrix(column: column, row: row))
    }
}


