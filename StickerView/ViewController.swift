//
//  ViewController.swift
//  StickerView
//
//  Created by Rashed Nizam on 26/2/21.
//

import UIKit

var screenBound : CGRect!
var stickerMenuView : StickerMenuView!
var stickerArray : NSMutableArray!

class ViewController: UIViewController, StickerMenuViewDelegate, ImageStickerViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var bgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 15/255.0, green: 23/255.0, blue: 31/255.0, alpha: 1.0)
        screenBound = UIScreen.main.bounds
        
        stickerArray = NSMutableArray()
        
        // Sticker Menu
        let kMenuHeight:CGFloat = screenBound.width*1.0
        let rect = CGRect(x: 0, y: screenBound.height-kMenuHeight, width: screenBound.width, height: kMenuHeight)
        stickerMenuView = StickerMenuView(frame: rect)
        view.addSubview(stickerMenuView)
        stickerMenuView.isUserInteractionEnabled = true
        stickerMenuView.delegate = self;
        
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
        bgView.addGestureRecognizer(tapGesture)
        
        
    }
    
    @IBAction func stickerButtonAction(_ sender: Any) {
        stickerMenuView.appear()
    }
    
    // MARK: Sticker View Delegate
    func stickerMenuView_BackButtonTapped() {
        print("Back Button")
        
    }
    
    func stickerMenuView_TickButtonTapped() {
        print("Tick Button")
        
    }
    
    func stickerMenuView_didSelectStickerName(stickerName: String) {
        
        let image: UIImage = CommonMethods.ins.uiImageWithName(named: stickerName)
        
        // Image Sticker
        let imageSticker = ImageStickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), image: image)
        self.view.addSubview(imageSticker);
        imageSticker.center = CGPoint(x: screenBound.width/2, y: 200)
        imageSticker.delegate = self
        imageSticker.select()
        stickerArray.add(imageSticker)
    }
    
    
    // Tap
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        
        deselectAllStickers()
    }
    
    func deselectAllStickers() {
        for sticker in stickerArray as! [ImageStickerView] {
            sticker.deselect()
        }
    }
    
// MARK: ImageStickerViewDelegate
    func imageStickerView_WillBeSelected() {
        deselectAllStickers( )
    }
    func imageStickerView_Selected() {
        
    }
    
    func imageStickerView_WillBeDeselected() {
        
    }
    func imageStickerView_Deselected() {
        
    }
    
}
