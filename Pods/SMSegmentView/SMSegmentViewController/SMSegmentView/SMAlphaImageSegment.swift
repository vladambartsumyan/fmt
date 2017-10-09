//
//  SMAlphaImageSegment.swift
//  SMSegmentViewController
//
//  Created by mlaskowski on 01/10/15.
//  Copyright © 2015 si.ma. All rights reserved.
//

import Foundation
import UIKit
public class SMAlphaImageSegment: SMBasicSegment {
    
    // UI Elements
    override public var frame: CGRect {
        didSet {
            self.resetContentFrame()
        }
    }
    
    @objc public var margin: CGFloat = 5.0 {
        didSet {
            self.resetContentFrame()
        }
    }
    
    @objc var vertical = false
    
    @objc public var animationDuration: TimeInterval = 0.5
    @objc public var selectedAlpha: CGFloat = 1.0
    @objc public var unselectedAlpha: CGFloat = 0.3
    @objc public var pressedAlpha: CGFloat = 0.65
    
    
    @objc internal(set) var imageView: UIImageView = UIImageView()
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public init(margin: CGFloat, selectedAlpha: CGFloat, unselectedAlpha: CGFloat, pressedAlpha: CGFloat, image: UIImage?) {
        
        self.margin = margin
        self.selectedAlpha = selectedAlpha
        self.unselectedAlpha = unselectedAlpha
        self.pressedAlpha = pressedAlpha
        self.imageView.image = image
        self.imageView.alpha = unselectedAlpha
        
        super.init(frame: CGRect.zero)
        self.setupUIElements()
    }
    
    override public func orientationChangedTo(mode: SegmentOrganiseMode) {
       self.vertical = mode == .SegmentOrganiseVertical
        //resetContentFrame(vertical)
    }
    
    @objc func setupUIElements() {
        
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
    }
    
    
    // MARK: Update Frame
    @objc func resetContentFrame() {
        let margin = self.vertical ? (self.margin * 1.5) : self.margin;
        let imageViewFrame = CGRect.init(x: margin, y: margin, width: self.frame.size.width - margin*2, height: self.frame.size.height - margin*2)
        
        self.imageView.frame = imageViewFrame
        
    }
    
    // MARK: Selections
    override func setSelected(selected: Bool, inView view: SMBasicSegmentView) {
        super.setSelected(selected: selected, inView: view)
        if selected {
            self.startAnimationToAlpha(alpha: self.selectedAlpha)
        }
        else {
            self.startAnimationToAlpha(alpha: self.unselectedAlpha)
        }
    }
    
    @objc func startAnimationToAlpha(alpha: CGFloat){
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: [.curveEaseInOut, .beginFromCurrentState], animations: { () -> Void in
            self.imageView.alpha = alpha
            }, completion: nil)
    }
    
    // MARK: Handle touch
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if self.isSelected == false {
            self.startAnimationToAlpha(alpha: self.pressedAlpha)
        }
    }
}
