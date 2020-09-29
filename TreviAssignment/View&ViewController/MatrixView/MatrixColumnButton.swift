//
//  MatrixColumnButton.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit
protocol MatrixColumnButtonDelegate where Self: MatrixColumnView {
    func matrixColumnButtonDidTap(matrixColumnButton:MatrixColumnButton)
}

class MatrixColumnButton: UIView {
    weak var delegate: MatrixColumnButtonDelegate?
    
    let button:UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = UIColor(red: 75/256.0, green: 75/256.0, blue: 75/256.0, alpha: 1).cgColor
        return btn
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "确定"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .init(red: 48/256.0, green: 48/256.0, blue: 48/256.0, alpha: 1)
        setupViews()
        toggleHighlight(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        toggleHighlight(false)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        addSubview(button)
        button.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        titleLabel.textColor = UIColor(red: 75/256.0, green: 75/256.0, blue: 75/256.0, alpha: 1)
        addSubview(titleLabel)
        titleLabel.centerXInSuperview()
        titleLabel.anchor(top: nil, leading: nil, bottom: button.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    func toggleHighlight(_ isHigtlight: Bool) {
        button.layer.borderColor = isHigtlight ? UIColor.clear.cgColor : UIColor(red: 75/256.0, green: 75/256.0, blue: 75/256.0, alpha: 1).cgColor
        button.backgroundColor = isHigtlight ? UIColor(red: 27/256.0, green: 211/256.0, blue: 213/256.0, alpha: 1) : UIColor.clear
        titleLabel.textColor = isHigtlight ? .white : UIColor(red: 75/256.0, green: 75/256.0, blue: 75/256.0, alpha: 1)
    }
    
    @objc private func buttonDidTap() {
        delegate?.matrixColumnButtonDidTap(matrixColumnButton: self)
    }
}
