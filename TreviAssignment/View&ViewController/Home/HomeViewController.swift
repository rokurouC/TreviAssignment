//
//  HomeViewController.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var matrixInputViewController: MatrixInputViewController?
    var matrix: Matrix? {
        didSet {
            genMatrixViews()
        }
    }
    var matrixViewController: MatrixViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    /// Setup the layout and subviews.
    private func setupViews() {
        view.backgroundColor = .white
        toggleMatrixInputView()
    }
    
    fileprivate func toggleMatrixInputView() {
        guard matrixInputViewController == nil else {
            matrixInputViewController?.delegate = nil
            matrixInputViewController?.view.removeFromSuperview()
            matrixInputViewController = nil
            return
        }
        matrixInputViewController = MatrixInputViewController()
        matrixInputViewController?.delegate = self
        self.view.addSubview(matrixInputViewController!.view)
        self.view.bringSubviewToFront(matrixInputViewController!.view)
        matrixInputViewController!.view.fillSuperview()
    }
    
    private func genMatrixViews() {
        if matrixViewController != nil {
            matrixViewController?.view.removeFromSuperview()
            matrixViewController = nil
        }
        if let matrix = matrix {
            matrixViewController = MatrixViewController(matrix: matrix)
            view.addSubview(matrixViewController!.view)
            matrixViewController?.view.fillSuperview()
        }
    }
}

// MARK: MatrixInputViewDelegate
extension HomeViewController: MatrixInputViewDelegate {
    func matrixInputViewDidConfirmMatrix(matrixInputView: MatrixInputView, matrix: Matrix) {
        self.matrix = matrix
        toggleMatrixInputView()
    }
    
    func matrixInputViewDidCancel(matrixInputView: MatrixInputView) {
        guard matrix != nil else {
            matrixInputViewController?.showMatrixNotSetError()
            return
        }
        toggleMatrixInputView()
    }
}
