//
//  NumberedPageControl.swift
//  CashBackEPN
//
//  Created by Александр on 07/05/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol NumberedPageControlDelegate: class {
    func changePage(page: Int)
}

enum PageControlStyle{
    case Numbered
    case NonNumbered
}

@IBDesignable
class NumberedPageControl: UIControl {
    
    weak var delegate: NumberedPageControlDelegate?
    private var isFirstLayout = true
    
    //MARK:- Properties
    
    private var numberOfDots = [UIView]() {
        didSet{
//            if numberOfDots.count == numberOfPages {
//                setupViews()
//            }
        }
    }
    
    @IBInspectable var numberOfPages: Int = 0 {
        didSet{
            for tag in 0 ..< numberOfPages {
                let dot = getDotView(tag: tag)
                dot.backgroundColor = pageIndicatorTintColor
                self.numberOfDots.append(dot)
            }
        }
    }
    
    var currentPage: Int = 0 {
        didSet{
            setupSelectedDot(selectedPage: currentPage)
        }
    }
    
    var dotStyle : PageControlStyle = .Numbered {
        didSet{
            setupViews()
        }
    }
    
    @IBInspectable var selectedDotSize : Int = 25{
        didSet{
            setupViews()
        }
    }
    @IBInspectable var dotScaleFactor : Float = 0.3{
        didSet{
            setupViews()
        }
    }
    
    @IBInspectable var spacingBetweenItems : Int = 0{
        didSet{
            stackView.spacing = CGFloat(spacingBetweenItems)
        }
    }
    
    @IBInspectable var pageIndicatorTintColor: UIColor? = UIColor.montreal
    @IBInspectable var currentPageIndicatorTintColor: UIColor? = .sydney
    
    private lazy var stackView = UIStackView.init(frame: self.bounds)
    private lazy var constantSpace = ((stackView.spacing) * CGFloat(numberOfPages - 1) + ((self.bounds.height * 0.45) * CGFloat(numberOfPages)) - self.bounds.width)
    
    
    override var bounds: CGRect {
        didSet{
            self.numberOfDots.forEach { (dot) in
                self.setupDotAppearance(dot: dot)
            }
        }
    }
    
    //MARK:- Intialisers
    convenience init() {
        self.init(frame: .zero)
    }
    
    init(withNoOfPages pages: Int) {
        self.numberOfPages = pages
        self.currentPage = 0
        super.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        if isFirstLayout {
            isFirstLayout = false
            setupViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func setupViews() {
        self.numberOfDots.removeAll()
        for tag in 0 ..< numberOfPages {
            let dot = getDotView(tag: tag)
            dot.backgroundColor = pageIndicatorTintColor
            self.numberOfDots.append(dot)
        }
        self.stackView.subviews.forEach { (dot) in
            dot.removeFromSuperview()
        }
        
        self.numberOfDots.forEach { (dot) in
            self.stackView.addArrangedSubview(dot)
        }
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = CGFloat(spacingBetweenItems)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if(self.subviews.count==0){
            self.addSubview(stackView)
        }
        
        
        self.addConstraints([
            
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            ])
        
        for(index, dot) in self.numberOfDots.enumerated(){
            dot.removeConstraints(dot.constraints)
            self.addConstraints([
                
                dot.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
                dot.widthAnchor.constraint(equalToConstant: CGFloat(selectedDotSize)),
                dot.heightAnchor.constraint(equalToConstant: CGFloat(selectedDotSize))
                ])
            if(index != 0 || dotStyle == PageControlStyle.NonNumbered){
                (dot.subviews[0] as! UILabel).isHidden = true
            }
            if(index != 0){
                dot.transform = CGAffineTransform.init(scaleX:CGFloat(dotScaleFactor), y:CGFloat(dotScaleFactor))
            }else{
                dot.backgroundColor = self.currentPageIndicatorTintColor
            }
        }
    }
    
    @objc private func onPageControlTapped(_ sender: UITapGestureRecognizer) {
        
        guard let selectedDot = sender.view else { return }
        currentPage = selectedDot.tag
        delegate?.changePage(page: currentPage)
    }
    
    private func setupSelectedDot(selectedPage: Int){
        _ = numberOfDots.map { (dot) in
            setupDotAppearance(dot: dot)
            if dot.tag == selectedPage {
                UIView.animate(withDuration: 0.2, animations: {
                    if(self.dotStyle == PageControlStyle.Numbered){
                        (dot.subviews[0] as! UILabel).isHidden = false
                    }
                    dot.layer.cornerRadius = dot.bounds.height / 2
                    dot.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    dot.backgroundColor = self.currentPageIndicatorTintColor
                })
                self.sendActions(for: .valueChanged)
            }
            else{
                (dot.subviews[0] as! UILabel).isHidden = true
                dot.transform = CGAffineTransform.init(scaleX:CGFloat(dotScaleFactor), y:CGFloat(dotScaleFactor))
            }
        }
    }
    
    //MARK: Helper methods...
    private func getDotView(tag: Int) -> UIView {
        let dot = UIView()
        dot.bounds = CGRect(x: 0, y: 0, width: selectedDotSize, height: selectedDotSize)
        dot.clipsToBounds = false
        dot.tag = tag
        let numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: selectedDotSize, height: selectedDotSize))
        numberLabel.text = "\(tag+1)"
        numberLabel.font = .medium15
        numberLabel.textColor = .zurich
        numberLabel.textAlignment = .center
        dot.addSubview(numberLabel)
        dot.addConstraints([
            numberLabel.centerXAnchor.constraint(equalTo: dot.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: dot.centerYAnchor),
            numberLabel.heightAnchor.constraint(equalTo: dot.heightAnchor),
            numberLabel.widthAnchor.constraint(equalTo: dot.widthAnchor)
            ])
        self.setupDotAppearance(dot: dot)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onPageControlTapped(_:))))
        return dot
    }
    
    private func setupDotAppearance(dot: UIView) {
        dot.layer.cornerRadius = dot.bounds.height / 2
        dot.transform = .identity
        dot.layer.masksToBounds = true
        dot.backgroundColor = pageIndicatorTintColor
    }
    
}
