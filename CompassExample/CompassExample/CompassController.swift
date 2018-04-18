//
//  CompassController.swift
//  CompassExample
//
//  Created by Liu Chuan on 2018/3/10.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

/// 指南针控制器
class CompassController: UIViewController {

    // MARK: - Lazy Loading View
    
    // 位置信息
    /// 定位管理器
    private lazy var locationManager : CLLocationManager = CLLocationManager()
    private lazy var currLocation: CLLocation = CLLocation()
    
    /// 刻度视图
    fileprivate lazy var dScaView: DegreeScaleView = {
        let viewF = CGRect(x: 0, y: 0, width: view.frame.size.width - 30, height: view.frame.size.width - 30)
        let scaleV = DegreeScaleView(frame: viewF)
        scaleV.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        scaleV.backgroundColor = .black
        return scaleV
    }()
    
    /// 角度label
    private lazy var angleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: dScaView.frame.maxY, width: view.frame.size.width / 2, height: 100))
        label.font = UIFont.systemFont(ofSize: 60)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    /// 方向label
    private lazy var directionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: view.frame.size.width / 2, y: angleLabel.frame.origin.y, width: view.frame.width / 2, height: 25))
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()

    /// 地理位置Label
    private lazy var positionLabel: UILabel = {
        let viewF = CGRect(x: view.frame.size.width / 2, y: directionLabel.frame.maxY, width: view.frame.size.width / 2, height: directionLabel.Height * 2)
        let label = UILabel(frame: viewF)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    /// 经纬度Label
    private lazy var latitudeAndLongitudeLabel: UILabel = {
        let viewF = CGRect(x: 0, y: angleLabel.frame.maxY, width: view.frame.size.width, height: 30)
        let label = UILabel(frame: viewF)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    /// 海拔高度Label
    private lazy var altitudeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: latitudeAndLongitudeLabel.frame.maxY, width: view.frame.maxX, height: 30))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - 销毁(destroy)
    // deinit() 类反初始化（析构方法）
    deinit {
        locationManager.stopUpdatingHeading()   // 停止获得航向数据，省电
        locationManager.delegate = nil
    }
    
    // MARK: - System Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        createLocationManager()
    }
}

// MARK: - Custom Method
extension CompassController {
    
    /// 配置UI界面
    private func configUI() {
        view.backgroundColor = .black
        addSub()
    }
    
    /// 添加视图
    private func addSub() {
        view.addSubview(dScaView)
        view.addSubview(angleLabel)
        view.addSubview(directionLabel)
        view.addSubview(positionLabel)
        view.addSubview(latitudeAndLongitudeLabel)
        view.addSubview(altitudeLabel)
    }
    
    /// 创建初始化定位装置
    private func createLocationManager() {
        
        /**
         * 定位信息
         *
         * 经度：currLocation.coordinate.longitude
         * 纬度：currLocation.coordinate.latitude
         * 海拔：currLocation.altitude
         * 方向：currLocation.course
         * 速度：currLocation.speed
         *  ……
         */
        
        locationManager.delegate = self
        
        // 位置定位管理器更新频率. 定位要求的精度越高，distanceFilter属性的值越小.
        // 它指设备（水平或垂直）移动多少米后才将另一个更新发送给委托。
        locationManager.distanceFilter = 0
        
        // 设置定位的精准度. 越精确，耗电量越高.
        // kCLLocationAccuracyBestForNavigation: 精度最高，一般用于导航.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        /** 发送授权申请 **/
        // 总是授权: 允许在前台获取用户位置的授权
        //locationManager.requestAlwaysAuthorization()
        // 当使用时: 请求授权
        locationManager.requestWhenInUseAuthorization()
        
        // 允许后台定位更新,进入后台后有蓝条闪动
        locationManager.allowsBackgroundLocationUpdates = true

        // 判断定位设备是否允许使用定位服务 和 是否获得导航数据
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.headingAvailable() {
            locationManager.startUpdatingLocation()     // 开始定位服务
            locationManager.startUpdatingHeading()      // 开始获取设备朝向
            print("定位开始")
        }else {
            print("不能获得航向数据")
        }
    }
    
    /// 更新当前手机（摄像头)朝向方向
    ///
    /// - Parameter newHeading: 朝向
    private func update(_ newHeading: CLHeading) {
        
        /// 朝向
        let theHeading: CLLocationDirection = newHeading.magneticHeading > 0 ? newHeading.magneticHeading : newHeading.trueHeading
        
        /// 角度
        let angle = Int(theHeading)
        
        switch angle {
        case 0:
            directionLabel.text = "北"
        case 90:
            directionLabel.text = "东"
        case 180:
            directionLabel.text = "南"
        case 270:
            directionLabel.text = "西"
        default:
            break
        }
        
        if angle > 0 && angle < 90 {
            directionLabel.text = "东北"
        }else if angle > 90 && angle < 180 {
            directionLabel.text = "东南"
        }else if angle > 180 && angle < 270 {
            directionLabel.text = "西南"
        }else if angle > 270 {
            directionLabel.text = "西北"
        }
    }
    
    /// 获取当前设备朝向(磁北方向)
    ///
    /// - Parameters:
    ///   - heading: 朝向
    ///   - orientation: 设备方向
    /// - Returns: Float
    private func heading(_ heading: Float, fromOrirntation orientation: UIDeviceOrientation) -> Float {
        
        var realHeading: Float = heading
        
        switch orientation {
        case .portrait:
            break
        case .portraitUpsideDown:
            realHeading = heading - 180
        case .landscapeLeft:
            realHeading = heading + 90
        case .landscapeRight:
            realHeading = heading - 90
        default:
            break
        }
        if realHeading > 360 {
            realHeading -= 360
        }else if realHeading < 0.0 {
            realHeading += 366
        }
        return realHeading
    }
}


// MARK: - CLLocationManagerDelegate
extension CompassController: CLLocationManagerDelegate {
    
    //与导航有关方法
    
    // 定位成功之后的回调方法，只要位置改变，就会调用这个方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        // 获取最新的坐标
        currLocation = locations.last!
        
        /// 经度
        let longitudeStr = String(format: "%3.2f", currLocation.coordinate.longitude)
        
        /// 纬度
        let latitudeStr = String(format: "%3.2f", currLocation.coordinate.latitude)
        
        /// 海拔
        let altitudeStr = "\(Int(currLocation.altitude))"
        
        
        /***** 1.处理经度 *****/
        /// 字符串范围截取
        let stringRange = longitudeStr.range(of: ".")
        
        /// 整数: 根据某个字符串截取. 截取小数点前字符
        let wholeNumber = longitudeStr.prefix(upTo: stringRange!.lowerBound)
        
        /// 小数点后面部分 截取小数点后字符
        let decimalPointBehind = longitudeStr.suffix(from: stringRange!.upperBound)
        
        /// 拼接度数(°)后的整数
        let newWholeNumber = wholeNumber + "°"
        
        /// 拼接(')后的小数后面部分
        let newDecimalPointBehind = decimalPointBehind + "'"
        
        /// 新拼接的东经度
        let newLongitudeStr = newWholeNumber + newDecimalPointBehind
        
        /***** 2.处理纬度 *****/
        /// 字符串范围截取
        let stringRange2 = latitudeStr.range(of: ".")
        
        /// 整数: 根据某个字符串截取. 截取小数点前字符
        let wholeNumber2 = latitudeStr.prefix(upTo: stringRange2!.lowerBound)
        
        /// 小数点后面部分 截取小数点后字符
        let decimalPointBehind2 = latitudeStr.suffix(from: stringRange2!.upperBound)
        
        /// 拼接度数(°)后的整数
        let newWholeNumber2 = wholeNumber2 + "°"
        
        /// 拼接(')后的小数后面部分
        let newDecimalPointBehind2 = decimalPointBehind2 + "'"
        
        /// 新拼接的北纬度
        let newlatitudeStr = newWholeNumber2 + newDecimalPointBehind2
        
//        latitudeAndLongitudeLabel.text = "北纬：\(latitudeStr)  东经：\(longitudeStr)"
        
        latitudeAndLongitudeLabel.text = "北纬：\(newlatitudeStr)  东经：\(newLongitudeStr)"
        
        altitudeLabel.text = "海拔：\(altitudeStr) 米"

        // 反地理编码
        /// 创建CLGeocoder对象
        let geocoder = CLGeocoder()
        
        /*** 反向地理编码请求 ***/
        
        // 根据给的经纬度地址反向解析,得到字符串地址.
        geocoder.reverseGeocodeLocation(currLocation) { (placemarks, error) in
            
            guard let placeM = placemarks else { return }
            // 如果解析成功执行以下代码
            guard placeM.count > 0 else { return }
            /* placemark: 包含所有位置信息的结构体 */
            // 包含区，街道等信息的地标对象
            let placemark: CLPlacemark = placeM[0]
            
            /// 存放街道,省市等信息
            let addressDictionary = placemark.postalAddress
            
            /// 国家
            guard let country = addressDictionary?.country else { return }
            
            /// 城市
            guard let city = addressDictionary?.city else { return }
            
            /// 子地点
            guard let subLocality = addressDictionary?.subLocality else { return }
            
            /// 街道
            guard let street = addressDictionary?.street else { return }
       
            self.positionLabel.text = "\(country)\n\(city) \(subLocality) \(street)"
        }
 
    }

    // 获得设备地理和地磁朝向数据，从而转动地理刻度表以及表上的文字标注
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        /*
            trueHeading     : 真北方向
            magneticHeading : 磁北方向
         */
        /// 获得当前设备
        let device = UIDevice.current
        
        // 1.判断当前磁力计的角度是否有效(如果此值小于0,代表角度无效)越小越精确
        if newHeading.headingAccuracy > 0 {
            
            // 2.获取当前设备朝向(磁北方向)数据
            let magneticHeading: Float = heading(Float(newHeading.magneticHeading), fromOrirntation: device.orientation)
            
            // 地理航向数据: trueHeading
            //let trueHeading: Float = heading(Float(newHeading.trueHeading), fromOrirntation: device.orientation)
         
            /// 地磁北方向
            let headi: Float = -1.0 * Float.pi * Float(newHeading.magneticHeading) / 180.0
            // 设置角度label文字
            angleLabel.text = "\(Int(magneticHeading))°"

            // 3.旋转变换
            dScaView.resetDirection(CGFloat(headi))
            
            // 4.当前手机（摄像头)朝向方向
            update(newHeading)
        }
    }
   
    // 判断设备是否需要校验，受到外来磁场干扰时
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    // 定位代理失败回调
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败....\(error)")
    }
    
    /// 如果授权状态发生变化时,调用
    ///
    /// - Parameters:
    ///   - manager: 定位管理器
    ///   - status: 当前的授权状态
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
 
        switch status {
        case .notDetermined:
            print("用户未决定")
        case .restricted:
            print("受限制")
        case .denied:
            // 判断当前设备是否支持定位, 并且定位服务是否开启
            if CLLocationManager.locationServicesEnabled() {
                print("定位开启,被拒绝")
            }else {
                print("定位服务关闭")
            }
        case .authorizedAlways:
            print("前,后台定位授权")
        case .authorizedWhenInUse:
            print("前台定位授权")
        }
    }
    
 
}
