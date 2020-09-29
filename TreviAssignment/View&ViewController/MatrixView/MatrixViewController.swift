//
//  MatrixViewController.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit

class MatrixViewController: UIViewController {
    
    /// The notification name of post matrix item to highlight
    static let highlightMatrixItemNotificationName = "NighlightMatrixItemNotificationName"
    
    /// Generating array of MatrixItemColors
    /// - Parameter number: how many MatrixItemColors to be generate
    static func genRandomMatrixItemColors(_ number: UInt) -> [MatrixItemColors] {
        var colors:[(top:UIColor, bottom:UIColor)] = []
        guard number > 0 else { return colors }
        for _ in 0...number - 1 {
            colors.append(
                (
                    .init(red: .randomLess256(), green: .randomLess256(), blue: .randomLess256(), alpha: 1),
                    .init(red: .randomLess256(), green: .randomLess256(), blue: .randomLess256(), alpha: 1)
                )
            )
        }
        return colors
    }
    
    let matrix: Matrix
    var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    let rowColors: [(top:UIColor, bottom:UIColor)]
    var timer: Timer?
    
    init(matrix: Matrix) {
        self.matrix = matrix
        self.rowColors = MatrixViewController.genRandomMatrixItemColors(matrix.row)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        fireTimerToPostNotification()
    }
    
    fileprivate func fireTimerToPostNotification() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(postNotification), userInfo: nil, repeats: true)
    }
    
    @objc private func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(MatrixViewController.highlightMatrixItemNotificationName), object: Matrix.genRandomMatrixBy(column: matrix.column, row: matrix.row), userInfo: nil)
    }
    
    /// setup layout of sebviews
    private func setupSubviews() {
        for columnIndex in 1...matrix.column {
            let matrixColumnView = MatrixColumnView(columnIndex:columnIndex, rowNumber: matrix.row, rowColors: rowColors)
            matrixColumnView.delegate = self
            contentStackView.addArrangedSubview(matrixColumnView)
        }
        view.addSubview(contentStackView)
        contentStackView.fillSuperview()
    }
}

extension MatrixViewController: MatrixColumnViewDelegate {
    func matrixColumnViewDidConfirmHighlight(matrixColumnView: MatrixColumnView) {
        fireTimerToPostNotification()
    }
}
