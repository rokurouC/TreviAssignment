//
//  CGFloat+Random.swift
//  TreviAssignment
//
//  Created by 建達 陳 on 2020/9/29.
//  Copyright © 2020 RokurouC. All rights reserved.
//

import UIKit
extension CGFloat {
    static func randomLess256() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
