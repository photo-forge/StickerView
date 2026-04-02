//
//  StickerMenuView.swift
//  StickerView
//
//  Created by Rashed Nizam on 26/2/21.
//

import UIKit


public protocol StickerMenuViewDelegate {
    func stickerMenuView_didSelectStickerName(stickerName:String);
    func stickerMenuView_BackButtonTapped()
    func stickerMenuView_TickButtonTapped()
}

//enum StickerCategory {
//    case baloon
//    case bird
//    case flower
//    case gift
//    case lips
//    case love
//}

class StickerMenuView: UIView, StickerTopMenuBarDelegate, StickerCategoryViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var delegate:StickerMenuViewDelegate!
    
    var stickerNamesDic: NSDictionary?
    var stickerNames: NSArray!
    
    var collectionView: UICollectionView!
    var initialFrame : CGRect!
    
    let numberOfBaloons : Int = 14;
    let numberOfBirds : Int = 20;
    let numberOfFlowers : Int = 16;
    let numberOfGifts : Int = 12;
    let numberOfLips : Int = 12;
    let numberOfLoves : Int = 9;
    
    var numberOfSelectedSticker : Int = 14;
    var stickerName = "sticker_baloon_0"
    
//    var stickerNamePrefix = "sticker_baloon_"
//    var selectedStickerCategory : StickerCategory = .baloon

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        initialFrame = frame
        
        super.init(frame: CGRect(x: 0, y: initialFrame.origin.y + initialFrame.height, width: initialFrame.width, height: initialFrame.height))
        self.backgroundColor = UIColor(red: 23/255.0, green: 35/255.0, blue: 47/255.0, alpha: 1.0)
        
        populateSticker()
        
        createInterface()
        
    }
    
    func populateSticker() {
        
        // Populate category array from plist
        var stickerInfoDic: NSDictionary?
        let path = Bundle.main.path(forResource: "StickerImagesInfo", ofType: "plist")
        if FileManager.default.fileExists(atPath: path ?? "") {
            stickerInfoDic = NSDictionary(contentsOfFile: path ?? "") as NSDictionary?
        }
        stickerNamesDic = stickerInfoDic?["StickerItems"] as? NSDictionary
        
        stickerNames = stickerNamesDic?["sticker_category_baloon"] as? NSArray
    }
    
    func createInterface() {
        
        // Top Bar
        let topBarHeight:CGFloat = 44
        let tbRect = CGRect(x: -2, y: 0, width: self.bounds.width+4, height: topBarHeight)
        let topBar:SimpleTopMenuBar = SimpleTopMenuBar(frame: tbRect, title: "stickers")
        self.addSubview(topBar)
        topBar.delegate = self
        
        // Main Categories
        let categoryViewHeight:CGFloat = 48
        let rect = CGRect(x: 0, y: topBarHeight, width: self.bounds.width, height: categoryViewHeight)
        let stickerCategoryView: StickerCategoryView = StickerCategoryView(frame: rect)
        self.addSubview(stickerCategoryView)
        stickerCategoryView.delegate = self
        
        
        // Collection View
        let cvFrame = CGRect(x: 0, y: topBarHeight+categoryViewHeight, width: self.bounds.width, height: self.bounds.height-topBarHeight-categoryViewHeight)
        
        let inset:CGFloat = 8.0
        let numberOfCells:CGFloat = 4;
        let cellSize:CGFloat = (cvFrame.width - inset*(numberOfCells+2)-1)/CGFloat(numberOfCells)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset*1.5, left: inset*1.5, bottom: inset, right: inset*1.5)
        layout.minimumInteritemSpacing = inset
        layout.minimumLineSpacing = inset
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: cvFrame, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StickerMenuStickerCell.self, forCellWithReuseIdentifier: "StickerCell")
        
    }
    
    // MARK: Top Bar
    func stickerTopMenuBar_BackButtonTapped() {
        self.disappear()
        
        if (delegate != nil) {
            delegate.stickerMenuView_BackButtonTapped()
        }
    }
    
    func stickerTopMenuBar_TickButtonTapped() {
        self.disappear()
        
        if (delegate != nil) {
            delegate.stickerMenuView_TickButtonTapped()
        }
    }
    
    // MARK: Category View
    func strickerCategoryView_didSelectAt(stickerCategoryName: String) {
        print(stickerCategoryName)
        
        stickerNames = stickerNamesDic?[stickerCategoryName] as? NSArray
        collectionView.reloadData()
    }
    
    
    // MARK: Collection View Data Source & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stickerNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCell", for: indexPath) as! StickerMenuStickerCell
        
        let name = stickerNames?[indexPath.row] as! String
        cell.imageView.image = CommonMethods.ins.uiImageWithName(named: String.init(format: "%@_thumb", name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (delegate != nil) {
            let name = stickerNames?[indexPath.row] as! String
            delegate.stickerMenuView_didSelectStickerName(stickerName: name)
        }
    }
    
    func appear() {
        UIView.animate(withDuration: 0.2) { [self] in
            self.frame = initialFrame
        }
    }
    
    func disappear() {
        UIView.animate(withDuration: 0.2) { [self] in
            self.frame = CGRect(x: 0, y: initialFrame.origin.y + initialFrame.height, width: initialFrame.width, height: initialFrame.height)
        }
    }
    
}

class StickerMenuStickerCell: UICollectionViewCell {

    var imageView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
}
