//
//  ImageStickerView.swift
//  StickerView
//
//  Created by Rashed Nizam on 19/3/21.
//

import UIKit

public protocol ImageStickerViewDelegate {
    func imageStickerView_WillBeSelected()
    func imageStickerView_WillBeDeselected()
    func imageStickerView_Selected()
    func imageStickerView_Deselected()
    func imageStickerView_Deleted()
}

class ImageStickerView: UIView, UIGestureRecognizerDelegate {
    
    var delegate: ImageStickerViewDelegate?
    
    let screenRect = UIScreen.main.bounds
    
    var borderView: UIView!
    var imageView: UIImageView!
    var imageInset:CGFloat = 18
    
    var crossButton:UIButton!
    var scaleButton:UIImageView!
    var isScaleButtonPanning = false
    
    var initialDistance: CGFloat!
    var deltaAngle: Float!
    
    func getSelfFrame(frame:CGRect) -> CGRect {
        return CGRect(x: -imageInset*1.5, y: -imageInset*1.5, width: frame.width+imageInset*3, height: frame.height+imageInset*3)
    }
    
    func getBorderFrame(frame:CGRect) -> CGRect {
        return CGRect(x: -imageInset, y: -imageInset, width: frame.width+imageInset*2, height: frame.height+imageInset*2)
    }
    
    func getCrossButtonFrame() -> CGRect {
        let bWidth = imageInset*2;
        return CGRect(x: borderView.frame.origin.x-bWidth/2, y: borderView.frame.origin.y-bWidth/2, width: bWidth, height: bWidth)
    }
    
    func getScaleButtonFrame() -> CGRect {
        let bWidth = imageInset*2;
        return CGRect(x: borderView.frame.origin.x+borderView.frame.width-bWidth/2, y: borderView.frame.origin.y+borderView.frame.height-bWidth/2, width: bWidth, height: bWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, image: UIImage!) {
        
        var imageFrame = frame
        
        if image != nil {
            let imageSize = image.size
            if imageSize.width > imageSize.height {
                imageFrame.size = CGSize(width: imageFrame.width, height: imageFrame.width * imageSize.height/imageSize.width)
            } else {
                imageFrame.size = CGSize(width: imageFrame.height * imageSize.width/imageSize.height, height: imageFrame.height)
            }
        }
        
        let sFrame = CGRect(x: -imageInset*1.5, y: -imageInset*1.5, width: imageFrame.width+imageInset*3, height: imageFrame.height+imageInset*3)
        
        super.init(frame: sFrame)
        self.backgroundColor = .clear

        borderView = UIView(frame: self.getBorderFrame(frame: imageFrame))
        borderView.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addSubview(borderView)
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.backgroundColor = .clear
        
        // Image View
        imageView = UIImageView(frame: imageFrame)
        imageView.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.addSubview(imageView)
        imageView.image = image
        imageView.backgroundColor = .clear
        
        // Cross Button
        crossButton = UIButton(frame: self.getCrossButtonFrame())
        self.addSubview(crossButton)
        crossButton.backgroundColor = .clear
        crossButton.setImage(UIImage(named:"StickerCrossIcon"), for: UIControl.State())
        crossButton.imageView?.contentMode = .scaleAspectFit
        crossButton.addTarget(self, action: #selector(self.crossButtonTapped), for: .touchUpInside)
        
        // Scale Button
        scaleButton = UIImageView(frame: self.getScaleButtonFrame())
        self.addSubview(scaleButton)
        scaleButton.backgroundColor = .clear
        scaleButton.image = UIImage(named:"StickerScaleIcon")
        scaleButton.contentMode = .scaleAspectFit
        scaleButton.isUserInteractionEnabled = true
        
        // Pan Gesture
        let panGestureOnScaleButton = UIPanGestureRecognizer(target: self, action: #selector(handlePanOnScaleButton(_:)))
        panGestureOnScaleButton.delegate = self
        scaleButton.addGestureRecognizer(panGestureOnScaleButton)
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        // Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
        // Pinch Gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        self.addGestureRecognizer(pinchGesture)
        
        // Rotate Gesture
        let rotGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
        rotGesture.delegate = self
        self.addGestureRecognizer(rotGesture)
    }
    
    func updateWithFrame(scale: CGFloat) {
        
        let oldTrnsfrm = self.transform
        self.transform = CGAffineTransform.identity
        let center:CGPoint = self.center
        
        var sFrame = imageView.frame
        let ivSize = imageView.frame.size
        if (ivSize.width*ivSize.height < screenRect.height*screenRect.height || scale < 1) &&
            (ivSize.width*ivSize.height > screenRect.width || scale > 1)
        {
            sFrame = CGRect(x: 0, y: 0, width: imageView.frame.width*scale, height: imageView.frame.height*scale)
        }
        
        self.frame = self.getSelfFrame(frame: sFrame)
        self.center = center
        
        borderView.frame = self.getBorderFrame(frame: sFrame)
        borderView.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        imageView.frame = sFrame
        imageView.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        crossButton.frame = self.getCrossButtonFrame()
        scaleButton.frame = self.getScaleButtonFrame()
        
        self.transform = oldTrnsfrm
    }
    
    // Cross Button
    @objc func crossButtonTapped() {
        self.removeFromSuperview()
        if (delegate != nil) {
            delegate?.imageStickerView_Deleted()
        }
    }
    
    
    // MARK: - Gestures
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
    }
    
    // Tap
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.select()
    }
    
    // Pan
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        
        if isScaleButtonPanning {
            return;
        }
        
        if sender.state == .began {
            self.select()
        }
        
        let translation = sender.translation(in: self.superview)
        if let view = sender.view {
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func handlePanOnScaleButton(_ sender: UIPanGestureRecognizer) {
        
        let touchLocation = sender.location(in: self)
        let center = imageView.center
        
        if touchLocation.x < center.x || touchLocation.y < center.y {
            return
        }
        
        // Scale
        if sender.state == .began {
            isScaleButtonPanning = true
            initialDistance = CGPointDistance(from: touchLocation, to: center)
        }
        if sender.state == .changed {
            let scale = CGPointDistance(from: touchLocation, to: center) / initialDistance
            self.updateWithFrame(scale: scale)
            initialDistance = CGPointDistance(from: touchLocation, to: center)
        }
        
        // Rotate
        if sender.state == .began {
            let touchLocation = sender.location(in: self.superview)
            let center = self.center
            
            let oldRot = atan2( self.transform.b, self.transform.a)
            deltaAngle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x)) - Float(oldRot);
        }
        if sender.state == .changed {
            let touchLocation = sender.location(in: self.superview)
            let center = self.center
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDiff = angle - deltaAngle
            self.transform = CGAffineTransform(rotationAngle: CGFloat(angleDiff))
        }
        
        if sender.state == .cancelled || sender.state == .ended || sender.state == .failed {
            isScaleButtonPanning = false
        }
    }
    
    // Pinch
    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            self.select()
        }
        self.updateWithFrame(scale: sender.scale)
        sender.scale = 1
    }
    
    // Rotate
    @objc func handleRotateGesture(_ sender: UIRotationGestureRecognizer) {
        
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
        }
        sender.rotation = 0
    }
    
    func select() {
        if (delegate != nil) {
            delegate?.imageStickerView_WillBeSelected()
        }
        borderView.layer.borderWidth = 1
        crossButton.isHidden = false
        scaleButton.isHidden = false
        if (delegate != nil) {
            delegate?.imageStickerView_Selected()
        }
    }
    
    func deselect() {
        if (delegate != nil) {
            delegate?.imageStickerView_WillBeDeselected()
        }
        borderView.layer.borderWidth = 0
        crossButton.isHidden = true
        scaleButton.isHidden = true
        if (delegate != nil) {
            delegate?.imageStickerView_Deselected()
        }
    }
    
    func isSelected() -> Bool {
        if borderView.layer.borderWidth == 0 {
            return false
        }
        return true
    }
        
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
}
