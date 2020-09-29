//
//  MatrixColumnView.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit
protocol MatrixColumnViewDelegate where Self: MatrixViewController {
    func matrixColumnViewDidConfirmHighlight(matrixColumnView: MatrixColumnView)
}

class MatrixColumnView: UIView {
    let columnIndex: UInt
    let rowNumber: UInt
    let matrixColumnButton: MatrixColumnButton = MatrixColumnButton()
    let rowColors: [MatrixItemColors]
    let contentStackView: UIStackView
    weak var delegate: MatrixColumnViewDelegate?
    var isHighlight: Bool = false
    var highlightRow: UInt?
    
    var itemMap: [UInt:MatrixItemView] = [:]
    
    init(columnIndex: UInt, rowNumber: UInt, rowColors: [(top:UIColor, bottom:UIColor)]) {
        self.columnIndex = columnIndex
        self.rowNumber = rowNumber
        self.rowColors = rowColors
        self.contentStackView = UIStackView(arrangedSubviews: [])
        super.init(frame: .zero)
        configure()
        setupViews()
        toggleHighlight(false)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fillEqually
        contentStackView.spacing = 4
        matrixColumnButton.delegate = self
    }
    
    private func setupViews() {
        for i in 1...rowNumber {
            let matrixItem = MatrixItemView(itemColors: rowColors[Int(i) - 1])
            contentStackView.addArrangedSubview(matrixItem)
            itemMap[i] = matrixItem
        }
        contentStackView.addArrangedSubview(matrixColumnButton)
        addSubview(contentStackView)
        contentStackView.fillSuperview()
        obserHighlightNotification()
    }
    
    fileprivate func toggleHighlight(_ isHighlight:Bool, highlightRow: UInt? = nil) {
        self.isHighlight = isHighlight
        layer.borderWidth = self.isHighlight ? 3 : 1
        layer.borderColor = self.isHighlight ? UIColor(red: 27/256.0, green: 211/256.0, blue: 213/256.0, alpha: 1).cgColor : UIColor.white.cgColor
        matrixColumnButton.toggleHighlight(self.isHighlight)
        layer.cornerRadius = self.isHighlight ? 4 : 0
        //If there is a item highlighted, toggle it
        if self.highlightRow != nil {
            itemMap[self.highlightRow!]?.toggleHighlight()
            self.highlightRow = nil
        }
        
        if let highlightRow = highlightRow {
            self.highlightRow = highlightRow
            itemMap[self.highlightRow!]?.toggleHighlight()
        }
    }
    
    private func obserHighlightNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification), name: Notification.Name(MatrixViewController.highlightMatrixItemNotificationName), object: nil)
    }
    
    @objc private func didReceiveNotification(noti:Notification) {
        if let matrix = noti.object as? Matrix, matrix.column == columnIndex {
            // Ready to highlight, check if has been highlighted
            if isHighlight,let highlightRow = highlightRow, highlightRow == matrix.row {
                //has highlight, and new highlight row is identical
                return
            }
            //highlight
            toggleHighlight(true, highlightRow: matrix.row)
        }else if isHighlight {
            // Not been notificated, but is the previous highlighted column
            toggleHighlight(false, highlightRow: nil)
        }
    }
    
    private func removeObserHighlightNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        removeObserHighlightNotification()
    }
}

extension MatrixColumnView: MatrixColumnButtonDelegate {
    func matrixColumnButtonDidTap(matrixColumnButton: MatrixColumnButton) {
        if !isHighlight { return }
        toggleHighlight(false)
        self.delegate?.matrixColumnViewDidConfirmHighlight(matrixColumnView: self)
    }
}
