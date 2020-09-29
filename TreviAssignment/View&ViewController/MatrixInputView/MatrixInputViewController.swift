//
//  MatrixInputViewController.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit

class MatrixInputViewController: UIViewController {
    weak var delegate: MatrixInputViewDelegate?

    private var matrixInputView: MatrixInputView = {
        let view = MatrixInputView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    /// Setup the layout and subviews.
    private func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(emptyAreaDidTap))
        self.view.addGestureRecognizer(tap)
        view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        view.fillSuperview()
        view.addSubview(matrixInputView)
        matrixInputView.delegate = self.delegate
        matrixInputView.centerInSuperview()
        matrixInputView.constrainHeight(constant: 300)
        matrixInputView.constrainWidth(constant: 300)
    }
    
    @objc private func emptyAreaDidTap() {
        matrixInputView.resignAllResponse()
    }
    
    func showMatrixNotSetError() {
        matrixInputView.showError(.MatrixNotSet)
    }
}
