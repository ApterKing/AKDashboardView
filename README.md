# AKDashboardView
类似汽车🚘油量仪表盘

## Usage:   
 
- 通过pod 方式引入

``` pod 'AKDashboardView' ```
	
- 初始化

	``` swift
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
	```
	
	![](http://ww1.sinaimg.cn/large/92ce04b2gy1ffh640nrbaj20ks0bsmyj.jpg)	
	
## Author

ApterKing, wangccong@foxmail.com

## License

AKDashboardView is available under the MIT license. See the LICENSE file for more info.