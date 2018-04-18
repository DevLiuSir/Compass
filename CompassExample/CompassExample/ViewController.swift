//
//  ViewController.swift
//  CompassExample
//
//  Created by Liu Chuan on 2018/3/10.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    /// 开启指南针按钮
    ///
    /// - Parameter sender: UIButton
    @IBAction func openCompassBtn(_ sender: UIButton) {
        let compassVC = CompassController()
        self.present(compassVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
