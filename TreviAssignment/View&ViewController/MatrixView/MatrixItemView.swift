//
//  MatrixItemView.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit
typealias MatrixItemColors = (top:UIColor, bottom:UIColor)
class MatrixItemView: UIView {
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "random"
        label.textColor = .black
        return label
    }()

    let maxtrixItemColors: MatrixItemColors
    let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(itemColors: MatrixItemColors) {
        self.maxtrixItemColors = itemColors
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = maxtrixItemColors.top
        addSubview(titleLabel)
        titleLabel.centerInSuperview()
        bottomView.backgroundColor = maxtrixItemColors.bottom
        addSubview(bottomView)
        bottomView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 10))
        titleLabel.isHidden = true
    }
    
    
    /// Show/High titleLabel
    func toggleHighlight() {
        titleLabel.isHidden = !titleLabel.isHidden
    }
}
