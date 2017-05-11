//
//  AKDashboardView.swift
//  AKSwifty
//
//  Created by wangcong on 01/04/2017.
//  Copyright © 2017 ApterKing. All rights reserved.
//

import UIKit

// 指针
class AKNeedleView: UIView {
    
    public var color = UIColor.red {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.setStrokeColor(color.cgColor)
        
        // 绘制第一条线
        context?.setLineWidth(1)
        context?.move(to: CGPoint(x: 0, y: rect.height / 2.0))
        context?.addLine(to: CGPoint(x: rect.width * 2.0 / 3.0, y: rect.height / 2.0))
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        // 绘制第二条线
        context?.setLineWidth(2)
        context?.setLineCap(CGLineCap.round)
        context?.move(to: CGPoint(x: rect.width * 2.0 / 3.0, y: rect.height / 2.0))
        context?.addLine(to: CGPoint(x: rect.width - 12, y: rect.height / 2.0))
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        // 绘制小圆圈
        context?.setLineWidth(2)
        context?.addArc(center: CGPoint(x: rect.width - 8, y: rect.height / 2.0), radius: 4, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        
        // 绘制小圆边缘阴影
        context?.setStrokeColor(color.withAlphaComponent(0.5).cgColor)
        context?.addArc(center: CGPoint(x: rect.width - 8, y: rect.height / 2.0), radius: 6, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        context?.strokePath()
    }
}

open class AKDashboardView: UIView {
    
    // Edge
    private lazy var outEdgeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineCap = kCALineCapButt
        return shapeLayer
    }()
    
    private lazy var inEdgeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineCap = kCALineCapButt
        return shapeLayer
    }()
    
    public var edgeColor = UIColor.white {
        didSet {
            self.outEdgeLayer.strokeColor = edgeColor.cgColor
            self.inEdgeLayer.strokeColor = edgeColor.cgColor
        }
    }
    
    public var edgeWidth: CGFloat = 2.0 {
        didSet {
            self.outEdgeLayer.lineWidth = edgeWidth
            self.resetAll()
        }
    }
    
    public var edgeSpacing: CGFloat = 40 {
        didSet {
            self.maskLayer.lineWidth = edgeSpacing
            self.longScaleLayer.lineWidth = edgeSpacing / 3
            self.shortScaleLayer.lineWidth = edgeSpacing / 4
            self.resetAll()
        }
    }
    
    // 长刻度
    private lazy var longScaleLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 40 / 6
        shapeLayer.lineCap = kCALineCapButt
        return shapeLayer
    }()
    public var longScaleColor = UIColor.white {
        didSet {
            longScaleLayer.strokeColor = longScaleColor.cgColor
        }
    }
    public var longScales: Int = 5 {
        didSet {
            resetLongScaleLayer()
            resetLongScaleTextLayer()
        }
    }
    
    // 长刻度文字
    private var longScaleTextLayer: CALayer = CALayer()
    public var longScaleTextColor = UIColor.white {
        didSet {
            guard let sublayers = longScaleTextLayer.sublayers else {
                return
            }
            for sublayer in sublayers {
                if let textLayer = sublayer as? CATextLayer {
                    textLayer.foregroundColor = longScaleTextColor.cgColor
                }
            }
        }
    }
    public var longScaleTexts: [String] = [] {
        didSet {
            resetLongScaleTextLayer()
        }
    }
    
    // 短刻度
    private lazy var shortScaleLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 40 / 8
        shapeLayer.lineCap = kCALineCapButt
        return shapeLayer
    }()
    public var shortScaleColor = UIColor.white {
        didSet {
            shortScaleLayer.strokeColor = shortScaleColor.cgColor
        }
    }
    
    public var shortScales: Int = 1 { // 短的刻度是：在长刻度区间内的分度值
        didSet {
            resetShortScaleLayer()
        }
    }
    
    // 进度条
    private lazy var maskLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 40
        shapeLayer.strokeStart = 0.0
        shapeLayer.strokeEnd = 0.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        return shapeLayer
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.orange.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        return gradientLayer
    }()
    
    public var gradientColors: [UIColor] = [UIColor.green, UIColor.orange, UIColor.red] {
        didSet {
            var cgColors = [CGColor]()
            for color in gradientColors {
                cgColors.append(color.cgColor)
            }
            gradientLayer.colors = cgColors
        }
    }
    
    // 指针
    private var needleView = AKNeedleView()
    public var needleColor: UIColor = UIColor.white {
        didSet {
            needleView.color = needleColor
        }
    }
    
    // 设置刻度
    public var scale: CGFloat = 0.0 {
        didSet {
            setSacle(scale, animated: false)
        }
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.mask = maskLayer
        self.layer.addSublayer(gradientLayer)
        
        shortScaleLayer.lineWidth = edgeSpacing / 4
        self.layer.addSublayer(shortScaleLayer)
        
        longScaleLayer.lineWidth = edgeSpacing / 3
        self.layer.addSublayer(longScaleLayer)
        
        self.layer.addSublayer(outEdgeLayer)
        self.layer.addSublayer(inEdgeLayer)
        
        needleView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.addSubview(needleView)
        
        self.layer.addSublayer(longScaleTextLayer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        longScaleTextLayer.frame = self.bounds
        resetAll()
    }
    
    // 重置Layer 及View
    fileprivate func resetAll() {
        
        resetLongScaleLayer()
        resetLongScaleTextLayer()
        resetShortScaleLayer()
        
        let radius = frame.size.width / 2 > frame.size.height ?
            frame.size.height - edgeWidth / 2: frame.size.width / 2 - edgeWidth / 2
        
        maskLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height), radius: radius - edgeWidth / 2 - edgeSpacing / 2, startAngle: CGFloat(Float.pi), endAngle: CGFloat(Float.pi * 2), clockwise: true).cgPath
        
        outEdgeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height), radius: radius, startAngle: CGFloat(Float.pi), endAngle: CGFloat(Float.pi * 2), clockwise: true).cgPath
        
        inEdgeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height), radius: radius - edgeWidth / 2 - edgeSpacing, startAngle: CGFloat(Float.pi), endAngle: CGFloat(Float.pi * 2), clockwise: true).cgPath
        
        needleView.frame = CGRect(x: frame.size.width / 2 - radius + edgeSpacing - 2 * edgeWidth, y: frame.size.height - 15 / 2, width: radius - edgeSpacing + 2 * edgeWidth, height: 15)
    }
    
    fileprivate func resetLongScaleLayer() {
        let radius = frame.size.width / 2 > frame.size.height ?
            frame.size.height - edgeWidth / 2: frame.size.width / 2 - edgeWidth / 2
        let longScaleRadius = radius - edgeWidth / 2 - edgeSpacing / 6
        let C = CGFloat.pi * longScaleRadius
        longScaleLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height), radius: longScaleRadius, startAngle: CGFloat(Float.pi), endAngle: CGFloat(Float.pi * 2), clockwise: true).cgPath
        longScaleLayer.lineDashPattern = [2, NSNumber(value: Float((C - CGFloat(2 * longScales)) / CGFloat(longScales - 1)))]
    }
    
    fileprivate func resetLongScaleTextLayer() {
        
        if let sublayers = self.longScaleTextLayer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let textSize: CGFloat = 12
        let radius = frame.size.width / 2 > frame.size.height ?
            frame.size.height - edgeWidth / 2: frame.size.width / 2 - edgeWidth / 2
        let longScaleTextRadius = radius - edgeWidth / 2 - edgeSpacing / 6 - textSize
        let angleSpacing = CGFloat.pi / CGFloat(longScales - 1)
        
        var angle = CGFloat.pi
        for index in 0 ..< longScales {
            let textLayer = CATextLayer()
            textLayer.foregroundColor = longScaleTextColor.cgColor
            textLayer.fontSize = 10
            textLayer.string = index >= longScaleTexts.count ? "" : longScaleTexts[index % longScaleTexts.count]
            textLayer.allowsEdgeAntialiasing = true
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.alignmentMode = kCAAlignmentCenter
            
            let x = longScaleTextRadius * cos(angle)
            let y = longScaleTextRadius * sin(angle)
            textLayer.frame = CGRect(origin: CGPoint(x: self.frame.size.width / 2.0 + x - textSize / 2.0, y: self.frame.size.height + y - (index == 0 || index == longScales - 1 ? textSize : textSize / 2.0)), size: CGSize(width: 12, height: 12))
            angle += angleSpacing
            
            self.longScaleTextLayer.addSublayer(textLayer)
        }
        
    }
    
    fileprivate func resetShortScaleLayer() {
        let radius = frame.size.width / 2 > frame.size.height ?
            frame.size.height - edgeWidth / 2: frame.size.width / 2 - edgeWidth / 2
        let shortScaleRadius = radius - edgeWidth / 2 - edgeSpacing / 8
        let C = CGFloat.pi * shortScaleRadius
        let realShortScales = (longScales - 1) * (shortScales + 1) + 1
        shortScaleLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height), radius: shortScaleRadius, startAngle: CGFloat(Float.pi), endAngle: CGFloat(Float.pi * 2), clockwise: true).cgPath
        shortScaleLayer.lineDashPattern = [2, NSNumber(value: Float((C - CGFloat(2 * realShortScales)) / CGFloat(realShortScales - 1)))]
    }
    
    // MARK: 设置dashScale
    open func setSacle(_ scale: CGFloat, animated: Bool) {
        let realScale = scale > 1.0 ? 1.0 : (scale < 0 ? 0 : scale)
        if animated {
            let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnim.duration = 0.25
            strokeAnim.toValue = realScale
            strokeAnim.fillMode = kCAFillModeForwards
            strokeAnim.isRemovedOnCompletion = false
            maskLayer.add(strokeAnim, forKey: "strokeEnd")
        } else {
            self.maskLayer.strokeEnd = realScale
        }
        
        let rotatedAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotatedAnim.duration = animated ? 0.25 : 0.01
        rotatedAnim.toValue = realScale * CGFloat.pi
        rotatedAnim.isRemovedOnCompletion = false
        rotatedAnim.fillMode = kCAFillModeForwards
        needleView.layer.add(rotatedAnim, forKey: "transform.rotation")
    }
}

