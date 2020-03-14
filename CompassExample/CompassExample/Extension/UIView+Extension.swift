//
//  UIView+Extension.swift

//
//  Created by Liu Chuan on 2018/4/7.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit


let screenH: CGFloat = UIScreen.main.bounds.height
let screenW: CGFloat = UIScreen.main.bounds.width


// MARK: - 扩展UIView
extension UIView {

    /// 视图的X值
    var LeftX: CGFloat {
        get {
            return self.frame.origin.x
        }
    }
    /// 视图右边的X值
    var RightX: CGFloat {
        get {
            return self.frame.origin.x + self.bounds.width
        }
    }
    /// 视图顶部Y值
    var TopY: CGFloat {
        get {
            return self.frame.origin.y
        }
    }
    /// 视图底部Y值
    var BottomY: CGFloat {
        get {
            return self.frame.origin.y + self.bounds.height
        }
    }

    /// 视图的宽度
    var Width: CGFloat {
        get {
            return self.bounds.width
        }
    }

    /// 视图的高度
    var Height: CGFloat {
        get {
            return self.bounds.height
        }
    }
}
