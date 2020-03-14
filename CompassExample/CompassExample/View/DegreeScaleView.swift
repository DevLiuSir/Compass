
//  DegreeScaleView.swift
//  CompassExample
//
//  Created by Liu Chuan on 2018/3/8.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

/// 刻度视图
class DegreeScaleView: UIView {
    
    /// 背景视图
    private lazy var backgroundView = UIView()
    
    /// 水平视图
    private lazy var levelView: UIView = {
        let levelView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 2, height: 1))
        levelView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        levelView.backgroundColor = .white
        return levelView
    }()
    
    /// 垂直视图
    private lazy var verticalView: UIView = {
        let verticalView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: self.frame.size.height / 2))
        verticalView.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        verticalView.backgroundColor = .white
        return verticalView
    }()
    
    /// 指针视图
    private lazy var lineView: UIView = {
        let lineView = UIView(frame: CGRect(x: self.frame.size.width / 2 - 1.5, y: self.frame.size.height/2 - (self.frame.size.width/2 - 50) - 50, width: 3, height: 60))
        lineView.backgroundColor = .white
        return lineView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 2
        backgroundView = UIView(frame: bounds)
        
        addSubview(backgroundView)
        addSubview(levelView)
        addSubview(verticalView)
        insertSubview(lineView, at: 0)
        configScaleDial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Update multiple times
extension DegreeScaleView {
    
    /// 计算中心坐标
    ///
    /// - Parameters:
    ///   - center: 中心点
    ///   - angle: 角度
    ///   - scale: 刻度
    /// - Returns: CGPoint
    private func calculateTextPositon(withArcCenter center: CGPoint, andAngle angle: CGFloat, andScale scale: CGFloat) -> CGPoint {
        let x = (self.frame.size.width / 2 - 50) * scale * CGFloat(cosf(Float(angle)))
        let y = (self.frame.size.width / 2 - 50) * scale * CGFloat(sinf(Float(angle)))
        return CGPoint(x: center.x + x, y: center.y + y)
    }
    
    /// 旋转重置刻度标志的方向
    ///
    /// - Parameter heading: 航向
    public func resetDirection(_ heading: CGFloat) {
        
        backgroundView.transform = CGAffineTransform(rotationAngle: heading)
        
        for label in backgroundView.subviews {
            label.transform = CGAffineTransform(rotationAngle: -heading)
        }
    }
    
}

//MARK: - Configure
extension DegreeScaleView {
    
    /// 配置刻度表
    private func configScaleDial() {
        
        /// 360度
        let degree_360: CGFloat = CGFloat.pi
        
        /// 180度
        let degree_180: CGFloat = degree_360 / 2
        
        /// 角度
        let angle: CGFloat = degree_360 / 90
        
        /// 方向数组
        let directionArray = ["北", "东", "南", "西"]
        
        /// 点
        let po = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        //画圆环，每隔2°画一个弧线，总共180条
        for i in 0 ..< 180 {
            
            /// 开始角度
            let startAngle: CGFloat = -(degree_180 + degree_360 / 180 / 2) + angle * CGFloat(i)
            
            /// 结束角度
            let endAngle: CGFloat = startAngle + angle / 2
            
            // 创建一个路径对象
            let bezPath = UIBezierPath(arcCenter: po, radius: frame.size.width / 2 - 50, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            /// 形变图层
            let shapeLayer = CAShapeLayer()
            
            if i % 15 == 0 {
                // 设置描边色
                shapeLayer.strokeColor = UIColor.white.cgColor
                shapeLayer.lineWidth = 20
            }else {
                shapeLayer.strokeColor = UIColor.gray.cgColor
                shapeLayer.lineWidth = 20
            }
            shapeLayer.path = bezPath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor    // 设置填充路径色
            backgroundView.layer.addSublayer(shapeLayer)
            
            // 刻度的标注
            if i % 15 == 0 {
                /// 刻度的标注 0 30 60...
                var tickText = "\(i * 2)"
                
                let textAngle: CGFloat = startAngle + (endAngle - startAngle) / 2
                
                let point: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 1.2)
                
                // UILabel
                let label = UILabel(frame: CGRect(x: point.x, y: point.y, width: 30, height: 20))
                label.center = point
                label.text = tickText
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 15)
                label.textAlignment = .center
                backgroundView.addSubview(label)
                
                if i % 45 == 0 {    //北 东 南 西
                    
                    tickText = directionArray[i / 45]
                    
                    let point2: CGPoint = calculateTextPositon(withArcCenter: po, andAngle: textAngle, andScale: 0.8)
                    // UILabel
                    let label2 = UILabel(frame: CGRect(x: point2.x, y: point2.y, width: 30, height: 20))
                    label2.center = point2
                    label2.text = tickText
                    label2.textColor = .white
                    label2.font = UIFont.systemFont(ofSize: 27)
                    label2.textAlignment = .center
                    
                    if tickText == "北" {
                        DrawRedTriangleView(point)
                        
                        
                        /// 红色箭头
//                        let redArrowLabel = UILabel(frame: CGRect(x: point.x, y: point.y, width: 8, height: 8))
//                        redArrowLabel.center = CGPoint(x: point.x, y: point.y + 10)
//                        redArrowLabel.clipsToBounds = true
//                        redArrowLabel.layer.cornerRadius = redArrowLabel.frame.size.height / 2
//                        redArrowLabel.backgroundColor = .red
//                        redArrowLabel.textAlignment = .center
//                        backgroundView.addSubview(redArrowLabel)


//                        /// 红色三角视图
//                        let redTriangleView = UIView(frame: CGRect(x: point.x, y: point.y, width: 10, height: 10))
//                        redTriangleView.center = CGPoint(x: point.x, y: point.y + 10)
//                        redTriangleView.backgroundColor = .clear
//                        backgroundView.addSubview(redTriangleView)
//
//                        // 画三角
//                        let trianglePath = UIBezierPath()
//                        var point = CGPoint(x: 0, y: 10)
//                        trianglePath.move(to: point)
//                        point = CGPoint(x: 10 / 2, y: 0)
//                        trianglePath.addLine(to: point)
//                        point = CGPoint(x: 10, y: 10)
//                        trianglePath.addLine(to: point)
//                        trianglePath.close()
//                        let triangleLayer = CAShapeLayer()
//                        triangleLayer.path = trianglePath.cgPath
//                        triangleLayer.fillColor = UIColor.red.cgColor
//                        redTriangleView.layer.addSublayer(triangleLayer)
                        
                        
                        
                    }
                    backgroundView.addSubview(label2)
                }
            }
        }
    }
    
    
    /// 绘制红色三角形视图
    private func DrawRedTriangleView(_ point: CGPoint) {
        
        /// 红色三角视图
        let redTriangleView = UIView(frame: CGRect(x: point.x, y: point.y, width: 10, height: 10))
        redTriangleView.center = CGPoint(x: point.x, y: point.y + 10)
        redTriangleView.backgroundColor = .clear
        backgroundView.addSubview(redTriangleView)
        
        
        // 画三角
        let trianglePath = UIBezierPath()
        var point = CGPoint(x: 0, y: 10)
        trianglePath.move(to: point)
        point = CGPoint(x: 10 / 2, y: 0)
        trianglePath.addLine(to: point)
        point = CGPoint(x: 10, y: 10)
        trianglePath.addLine(to: point)
        trianglePath.close()
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor.red.cgColor
        redTriangleView.layer.addSublayer(triangleLayer)
    }
    
}
