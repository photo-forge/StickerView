//
//  CommonMethods.swift
//  StickerView
//
//  Created by Rashed Nizam on 17/3/21.
//

import UIKit

class CommonMethods: NSObject {

    static let ins = CommonMethods()
    
    func uiImageWithName(named: String) -> UIImage{
        var image = UIImage(contentsOfFile: Bundle.main.path(forResource: named, ofType: "png")!)
        if image == nil {
            image = UIImage(contentsOfFile: Bundle.main.path(forResource: named, ofType: "jpg")!)
        }
        return image ?? UIImage(named: named)!
    }
    
    

}
