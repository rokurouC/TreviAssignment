//
//  File.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import Foundation

struct Matrix {
    static func genRandomMatrixBy(column: UInt, row: UInt) -> Matrix {
        return Matrix(column: UInt.random(in: 1...column), row: UInt.random(in: 1...row))
    }
    let column: UInt
    let row: UInt
}
