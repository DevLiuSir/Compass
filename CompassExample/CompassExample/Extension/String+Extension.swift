//
//  String+Extension.swift
//  CompassExample
//
//  Created by Liu Chuan on 2018/5/17.
//  Copyright © 2018 LC. All rights reserved.
//

import UIKit

/*
 度 → 度分秒：
 lon = 104.07167°

 度 = 104°
 分 = 0.07167 * 60 = 4.3002（取整） = 4’
 秒 = 0.3002 * 60 = 18.012（取整） = 18''
 转换后 lon = 104°4’18’’

     public static String D2Dms(double d_data){
         int d = (int)d_data;
         int m = (int)((d_data-d)*60);
         int s = (int)(((d_data-d)*60-m)*60);
         return  d+"°"+m+"′"+s+"″";
 }
 */

extension String {
    
    /// 经、纬度转换：（度°分′秒″格式）
    /// - Parameter d: 需要转换的经、纬度数值
    func DegreeToString(d: Double) -> String {
        /// 度
        let degree = Int(d)
        print("度：\(degree)°")
        /// 临时分
        let tempMinute = Float(d - Double(degree)) * 60
        /// 分
        let minutes = Int(tempMinute)   // 取整
        print("分：\(minutes)‘")
        /// 秒
        let second = Int((tempMinute - Float(minutes)) * 60)
        print("秒： \(second)\"")
        return "\(degree)°\(minutes)′\(second)″"
    }
}
