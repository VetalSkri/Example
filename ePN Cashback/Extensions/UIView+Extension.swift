//
//  UIView+Extension.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 10/10/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

extension UIView{
    
    
    func setBottomBorder(withColor color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height + 3 , width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    func topRoundCorners(cornerRadius: Double) {
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = CGFloat(cornerRadius)
            self.clipsToBounds = true
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            
            self.layer.mask = maskLayer
        }
    }
    
    func bottomRoundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func diagonalRoundCornersLeft(cornerRadius: CGFloat) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func diagonalRoundCornersRight(cornerRadius: CGFloat) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    
    func tripleRoundCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, name: String? = nil) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0 , 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        if let name = name {
            gradientLayer.name = name
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradientBackground() {
        guard let sublayers = self.layer.sublayers else { print("not found sublayers"); return }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
    
    func addSyblayerDashed(name: String) {
        self.removeSublayerBy(name: name)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.minsk.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: self.bounds.height), CGPoint(x: self.bounds.width, y: self.bounds.height)])
        shapeLayer.path = path
        shapeLayer.name = name
        self.layer.addSublayer(shapeLayer)
    }
    
    func removeSublayerBy(name: String? = nil) {
        guard let sublayers = self.layer.sublayers else { print("not found sublayers"); return }
        for layer in sublayers {
            if let name = name, layer.name == name {
                layer.removeFromSuperlayer()
            }
        }
    }
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

//For draw 4 dash line of the corner in QR scanner view
extension UIView {

    private struct Properties {

        static var _radius: CGFloat = 0.0
        static var _color: UIColor = .red
        static var _strokeWidth: CGFloat = 1.0
        static var _length: CGFloat = 20.0

    }

    private var radius: CGFloat {
        get {
            return Properties._radius
        }
        set {
            Properties._radius = newValue
        }
    }

    private var color: UIColor {
        get {
            return Properties._color
        }
        set {
            Properties._color = newValue
        }
    }

    private var strokeWidth: CGFloat {
        get {
            return Properties._strokeWidth
        }
        set {
            Properties._strokeWidth = newValue
        }
    }

    private var length: CGFloat {
        get {
            return Properties._length
        }
        set {
            Properties._length = newValue
        }
    }

    func drawCorners(radius: CGFloat? = nil, color: UIColor? = nil, strokeWidth: CGFloat? = nil, length: CGFloat? = nil) {
        if let radius = radius {
            self.radius = radius
        }
        if let color = color {
            self.color = color
        }
        if let strokeWidth = strokeWidth {
            self.strokeWidth = strokeWidth
        }
        if let length = length {
            self.length = length
        }
        createTopLeft()
        createTopRight()
        createBottomLeft()
        createBottomRight()
    }

    private func createTopLeft() {
        let topLeft = UIBezierPath()
        topLeft.move(to: CGPoint(x: strokeWidth/2, y: radius+length))
        topLeft.addLine(to: CGPoint(x: strokeWidth/2, y: radius))
        topLeft.addQuadCurve(to: CGPoint(x: radius, y: strokeWidth/2), controlPoint: CGPoint(x: strokeWidth/2, y: strokeWidth/2))
        topLeft.addLine(to: CGPoint(x: radius+length, y: strokeWidth/2))
        setupShapeLayer(with: topLeft)
    }

    private func createTopRight() {
        let topRight = UIBezierPath()
        topRight.move(to: CGPoint(x: frame.width-radius-length, y: strokeWidth/2))
        topRight.addLine(to: CGPoint(x: frame.width-radius, y: strokeWidth/2))
        topRight.addQuadCurve(to: CGPoint(x: frame.width-strokeWidth/2, y: radius), controlPoint: CGPoint(x: frame.width-strokeWidth/2, y: strokeWidth/2))
        topRight.addLine(to: CGPoint(x: frame.width-strokeWidth/2, y: radius+length))
        setupShapeLayer(with: topRight)
    }

    private func createBottomRight() {
        let bottomRight = UIBezierPath()
        bottomRight.move(to: CGPoint(x: frame.width-strokeWidth/2, y: frame.height-radius-length))
        bottomRight.addLine(to: CGPoint(x: frame.width-strokeWidth/2, y: frame.height-radius))
        bottomRight.addQuadCurve(to: CGPoint(x: frame.width-radius, y: frame.height-strokeWidth/2), controlPoint: CGPoint(x: frame.width-strokeWidth/2, y: frame.height-strokeWidth/2))
        bottomRight.addLine(to: CGPoint(x: frame.width-radius-length, y: frame.height-strokeWidth/2))
        setupShapeLayer(with: bottomRight)
    }

    private func createBottomLeft() {
        let bottomLeft = UIBezierPath()
        bottomLeft.move(to: CGPoint(x: radius+length, y: frame.height-strokeWidth/2))
        bottomLeft.addLine(to: CGPoint(x: radius, y: frame.height-strokeWidth/2))
        bottomLeft.addQuadCurve(to: CGPoint(x: strokeWidth/2, y: frame.height-radius), controlPoint: CGPoint(x: strokeWidth/2, y: frame.height-strokeWidth/2))
        bottomLeft.addLine(to: CGPoint(x: strokeWidth/2, y: frame.height-radius-length))
        setupShapeLayer(with: bottomLeft)
    }

    private func setupShapeLayer(with path: UIBezierPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = strokeWidth
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }

}
