//
//  ViewController.swift
//  Example
//
//  Created by wangcong on 11/05/2017.
//  Copyright © 2017 ApterKing. All rights reserved.
//

import UIKit
import AKDashboardView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.black
        
        let dashboardView = AKDashboardView(frame: CGRect(x: (UIScreen.main.bounds.size.width - 300) / 2.0, y: 200, width: 300, height: 150))
        dashboardView.gradientColors = [UIColor.green, UIColor.orange, UIColor.red]
        dashboardView.needleColor = UIColor.white
        dashboardView.shortScaleColor = UIColor.white.withAlphaComponent(0.6)
        dashboardView.shortScales = 5
        dashboardView.longScales = 11
        dashboardView.longScaleColor = UIColor.white
        dashboardView.longScaleTexts = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        
        dashboardView.scale = 0.6
        self.view.addSubview(dashboardView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

