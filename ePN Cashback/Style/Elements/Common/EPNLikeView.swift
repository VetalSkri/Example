//
//  EPNLikeView.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 26/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import UIKit

public enum LikeState: Int {
    case favorite
    case notFavorite
    case inProgress
}

@IBDesignable
final class EPNLikeView: UIView {
    
    private let button = UIButton(type: .custom)
    
    let imageView = UIImageView()
    
    private lazy var redHeart = UIImage(named: "favorite")
    private lazy var emptyHeart = UIImage(named: "unfavorite")
    
    var handler: ((EPNLikeView, Bool) -> ())?
    
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        
        borderWidth = CommonStyle.borderWidth
        borderColor = .montreal
        backgroundColor = .zurich
        
        // ImageView
        imageView.contentMode = .center
        
        addSubview(imageView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.contentMode = .scaleAspectFit
        
        // Button
        addSubview(button)
        button.backgroundColor = .clear
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    func setStatusLiked(_ status: LikeState) {
        styleType = status.rawValue
    }
    
    private var style: LikeState = .notFavorite {
        didSet {
            switch style {
            case .favorite:
                imageView.image = redHeart
                setEnable()
            case .inProgress:
                imageView.image = redHeart
                setDisable()
            case .notFavorite:
                imageView.image = emptyHeart
                setEnable()
            }
        }
    }
    
    @IBInspectable
    private var styleType: Int {
        get { return style.rawValue }
        
        set {
            if let newStyle = LikeState(rawValue: newValue) {
                style = newStyle
            }
        }
    }
    
    func getStatus() -> LikeState {
        return style
    }
    
    private func setEnable() {
        imageView.alpha = 1.0
        imageView.isUserInteractionEnabled = true
        button.isEnabled = false
    }
    
    private func setDisable() {
        imageView.alpha = 0.5
        imageView.isUserInteractionEnabled = false
        button.isEnabled = true
    }
}

extension EPNLikeView {
    
    @objc private func didTapButton() {
        alpha = 0.5
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.alpha = 1.0
        }) { [weak self] (_) in
            guard let strongSelf = self else { return }
            
                switch strongSelf.style {
                case .favorite:
                    strongSelf.handler?(strongSelf, false)
                case .notFavorite:
                    strongSelf.handler?(strongSelf, true)
                default:
                    print("LOG Likes: status of like in progress incorrect behavior")
                    break
                }
            
        }
    }
}
