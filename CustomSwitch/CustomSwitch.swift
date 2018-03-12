//
//  CustomSwitch.swift
//  CustomSwitch
//
//  Created by Hanyu Koji on 2018/02/07.
//  Copyright © 2018年 gaussbeam. All rights reserved.
//

import UIKit

public class CustomSwitch: UIControl {
    
    enum LabelDisplayMode {
        case none
        case required(needsAnimating: Bool)
    }
    
    enum BackgroundAnimationType {
        case dissolve
        case scale
    }
    
    var isOn: Bool = true
    var isAnimating: Bool = false
    
    var animationDuration: TimeInterval = 0.5
    
    var onTintColor: UIColor = .blue
    var offTintColor: UIColor? = .lightGray
    
    var cornerRadiusScale: CGFloat = 0.5 {
        didSet {
            if cornerRadiusScale < 0.0 {
                cornerRadiusScale = 0.0
            } else if cornerRadiusScale > 0.5 {
                cornerRadiusScale = 0.5
            }
        }
    }
    
    var borderWidth: CGFloat = 1.0
    var borderColor: UIColor = .white
    
    var thumSize: CGSize {
        let diameter = min(self.frame.width, self.frame.height) - thumPadding * 2
        return CGSize(width: diameter, height: diameter)
    }
    var thumPadding: CGFloat = 2.0
    var thumOnColor: UIColor = .white
    var thumOffColor: UIColor = .white
    var thumShadowColor: UIColor = .black
    var thumShadowOffset: CGSize = CGSize(width: 0.75, height: 2.0)
    var thumShadowRadius: CGFloat = 1.5
    var thumShadowOppacity: Float = 0.4
    
    var labelDisplayMode: LabelDisplayMode = .required(needsAnimating: true)
    var backgroundAnimationtype: BackgroundAnimationType = .dissolve
    
    fileprivate var needsLabelAnimating: Bool {
        switch self.labelDisplayMode {
        case .required(let needsAnimating):
            return needsAnimating
        case .none:
            return false
        }
    }
    var labelPaddingX: CGFloat = 8.0
    var labelPaddingY: CGFloat = 0.0
    
    var onLabelText: String = "ON"
    var onLabelColor: UIColor = .white
    var onLabelFont: UIFont = .systemFont(ofSize: 12.0)
    
    var offLabelText: String = "OFF"
    var offLabelColor: UIColor = .white
    var offLabelFont: UIFont = .systemFont(ofSize: 12.0)
    
    // MARK: - Subviews
    fileprivate var frameView: UIView!
    fileprivate var thumbView: UIView!
    fileprivate var onLabel: UILabel!
    fileprivate var offLabel: UILabel!
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        if !self.isAnimating {
            self.animate {
                self.sendActions(for: .valueChanged)
            }
        }
        
        return true
    }
}

// MARK: - Interface

public extension CustomSwitch {
    func configure() {
        self.configureBackground()
        self.configureFrameView()
        self.configureThumbView()
        self.configureLabel()
    }
}

private extension CustomSwitch {
    var animateDistance: CGFloat {
        return self.frame.width / 2.0
    }
    
    // MARK: - Coordinates for thumbView
    var onPoint: CGPoint {
        return CGPoint(x: self.frame.size.width - self.thumSize.width - self.thumPadding, y: self.thumPadding)
    }
    var offPoint: CGPoint {
        return CGPoint(x: self.thumPadding, y: self.thumPadding)
    }
    
    // MARK: - Coordinates for label
    var labelSize: CGSize {
        let width = self.frame.width - self.labelPaddingX * 2
        let height = self.frame.height - self.labelPaddingY * 2.0
        return CGSize(width: width, height: height)
    }
    
    var onLabelCurrentPoint: CGPoint {
        var point = CGPoint(x: self.labelPaddingX, y: self.labelPaddingY)
        
        if self.needsLabelAnimating && !self.isOn {
            point.x -= self.animateDistance
        }
        
        return point
    }
    
    var offLabelCurrentPoint: CGPoint {
        var point = CGPoint(x: self.frame.width - self.labelSize.width - self.labelPaddingX, y: self.labelPaddingY)
        
        if self.needsLabelAnimating && self.isOn {
            point.x += self.animateDistance
        }
        
        return point
    }
}

private extension CustomSwitch {
    
    func animate(completion: @escaping (() -> Void)) {
        
        let scalingView: UIView?
        switch self.backgroundAnimationtype {
        case .dissolve:
            scalingView = nil
            
        case .scale:
            let length = self.isOn ? self.frame.width * 2.0 : CGFloat(0.0)
            let size = CGSize(width: length, height: length)
            let view = UIView(frame: CGRect(origin: .zero, size: size))
            
            view.clipsToBounds = true
            view.layer.cornerRadius = length / 2.0
            
            view.backgroundColor = self.onTintColor
            view.center = self.thumbView.center
            self.frameView.addSubview(view)
            
            self.frameView.backgroundColor = self.offTintColor

            scalingView = view
        }
        
        self.isOn = !self.isOn
        
        self.isAnimating = true
        
        UIView.animate(
            withDuration: self.animationDuration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: [UIViewAnimationOptions.curveEaseInOut],
            animations: {
                self.thumbView.frame.origin = self.isOn ? self.onPoint : self.offPoint
                self.thumbView.backgroundColor = self.isOn ? self.thumOnColor : self.thumOffColor
                
                switch self.backgroundAnimationtype {
                case .dissolve:
                    self.frameView.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
                    
                case .scale:
                    let length = self.isOn ? self.frame.width * 2.0 : CGFloat(0.0)
                    scalingView?.frame.size.width = length
                    scalingView?.frame.size.height = length
                    scalingView?.layer.cornerRadius = length / 2.0
                    scalingView?.center = self.thumbView.center
                }
                
                switch self.labelDisplayMode {
                case .required(let needsAnimating):
                    if needsAnimating {
                        self.onLabel.frame.origin = self.onLabelCurrentPoint
                        self.offLabel.frame.origin = self.offLabelCurrentPoint
                    }
                    self.updateLabelVisibility()
                    
                case .none:
                    break
                }
            },
            completion: { _ in
                scalingView?.removeFromSuperview()
                self.frameView.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor

                self.isAnimating = false
                completion()
        })
    }
    
    func updateLabelVisibility() {
        self.onLabel.isHidden = !self.isOn
        self.offLabel.isHidden = self.isOn
    }
}

private extension CustomSwitch {
    
    func cornerRadius(for view: UIView) -> CGFloat {
        let minLength = min(view.frame.size.width, view.frame.size.height)
        return minLength * self.cornerRadiusScale
    }
    
    func configureBackground() {
        self.clipsToBounds = false
        self.backgroundColor = .clear
    }
    
    func configureFrameView() {
        self.frameView = UIView(frame: CGRect(origin: .zero, size: self.frame.size))
        
        self.frameView.clipsToBounds = true
        self.frameView.layer.cornerRadius = self.cornerRadius(for: self)
        self.frameView.layer.borderColor = self.borderColor.cgColor
        self.frameView.layer.borderWidth = self.borderWidth
        self.frameView.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor

        self.frameView.isUserInteractionEnabled = false
        
        self.addSubview(self.frameView)
    }
    
    func configureThumbView() {
        let origin = self.isOn ? self.onPoint : self.offPoint
        self.thumbView = UIView(frame: CGRect(origin: origin, size: self.thumSize))
        self.thumbView.layer.cornerRadius = self.cornerRadius(for: self.thumbView)
        self.thumbView.backgroundColor = self.isOn ? self.thumOnColor : self.thumOffColor
        self.thumbView.isUserInteractionEnabled = false
        
        self.thumbView.clipsToBounds = false
        
        self.thumbView.layer.shadowColor   = self.thumShadowColor.cgColor
        self.thumbView.layer.shadowOffset  = self.thumShadowOffset
        self.thumbView.layer.shadowRadius  = self.thumShadowRadius
        self.thumbView.layer.shadowOpacity = self.thumShadowOppacity
        
        self.addSubview(self.thumbView)
    }
    
    func configureLabel() {
        switch self.labelDisplayMode {
        case .required(let needsAnimating):
            self.onLabel = UILabel(frame: CGRect(origin: self.onLabelCurrentPoint, size: self.labelSize))
            self.onLabel.font = self.onLabelFont
            self.onLabel.textColor = self.onLabelColor
            self.onLabel.textAlignment = .left
            self.onLabel.text = self.onLabelText
            self.insertSubview(self.onLabel, belowSubview: self.thumbView)
            
            self.offLabel = UILabel(frame: CGRect(origin: self.offLabelCurrentPoint, size: self.labelSize))
            self.offLabel.font = self.offLabelFont
            self.offLabel.textColor = self.offLabelColor
            self.offLabel.textAlignment = .right
            self.offLabel.text = self.offLabelText
            self.insertSubview(self.offLabel, belowSubview: self.thumbView)
            
            if !needsAnimating {
                self.updateLabelVisibility()
            }

        case .none:
            break
        }
    }
}
