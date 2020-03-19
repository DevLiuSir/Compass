//
//  GeographyInfoView.swift
//  CompassExample
//
//  Created by Liu Chuan on 2020/5/14.
//  Copyright © 2020 LC. All rights reserved.
//

import UIKit


/// 地理位置信息视图
class GeographyInfoView: UIView {
    
    //MARK: - Control Properties
    /// 角度label
    @IBOutlet weak var angleLabel: UILabel!
    /// 方向label
    @IBOutlet weak var directionLabel: UILabel!
    /// 经纬度Label
    @IBOutlet weak var latitudeAndLongitudeLabel: UILabel!
    /// 地理位置Label
    @IBOutlet weak var positionLabel: UILabel!
    /// 海拔Label
    @IBOutlet weak var altitudeLabel: UILabel!
    
}

//MARK: - View Life Cycle
extension GeographyInfoView {
    
    /* 加载nib时，调用*/
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

//MARK: - 提供一个通过 Xib 快速创建的类方法
extension GeographyInfoView {
    
    /// 提供一个通过 Xib 快速创建的类方法
    ///
    /// - Returns: GeographyInfoView
    class func loadingGeographyInfoView() -> GeographyInfoView {
        return Bundle.main.loadNibNamed("GeographyInfoView", owner: nil, options: nil)?.first as! GeographyInfoView
    }
    
}
