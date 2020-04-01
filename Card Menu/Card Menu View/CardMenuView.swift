//
//  CardMenuView.swift
//  W4h
//
//  Created by Aleksandr Kravtsiv on 17.12.2019.
//  Copyright © 2019 Aleksandr Kravtsiv. All rights reserved.
//

import UIKit

enum CardContentType {
    case small
    case large
}

enum CardViewItemState: Int {
    
    case locked
    case ready
    case alert
}

enum CardViewType {
    
    case daily
    case news
    case photo
    case settings
    
    var iconImage: UIImage {
        
        var imageName = "icon-"
        
        switch self {
        case .daily:
            imageName += "daily"
            
        case .news:
            imageName += "news"
            
        case .photo:
            imageName += "photo"
        case .settings:
            imageName += "settings"
        }
        
        return UIImage(named: imageName)!
    }
}

protocol CardViewObject {
    
    var cardTitle: String { get }
    var subtitle: String  { get }
    var hexColor: String?  { get set}
    var isLocked: Bool    { get }
    var cardViewType: CardViewType? { get set}
    var itemState: CardViewItemState? {get set}
}

protocol CardMenuViewOutput: class {
    func didClickOnCard(_ card: CardViewObject)
}

protocol CardMenuDataInput: class {
    func configureWith(content: [CardViewObject], contentType: CardContentType, viewOutput: CardMenuViewOutput?)
}


class CardMenuView: UIView {
    
    //MARK: - Properties
    
    private var content: [CardViewObject]?
    
    private var viewOutput: CardMenuViewOutput?
    private var contentType: CardContentType = .small
    private var cardViews = [CardView]()
    private var yPos: CGFloat?
    private var minShift: CGFloat = 20
    
    //MARK: - Initializers
    
    override func draw(_ rect: CGRect) {
        
        guard let content = content else { return }
        
        if cardViews.isEmpty {
            for (i,cellObj) in content.enumerated(){
                createView(cellObj: cellObj, idx: i)
            }
        }
        else {
            for (i,cellObj) in content.enumerated() {
                cardViews[i].configureWith(card: cellObj, viewOutput: self)
            }
        }
        
        self.minShift = 20
    }
    

    //MARK: - Public
    
    func configureWith(content: [CardViewObject], contentType: CardContentType, viewOutput: CardMenuViewOutput?) {
    
        self.content?.removeAll()
        self.cardViews.removeAll()
        self.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        
        yPos = 0
        
        self.isUserInteractionEnabled = true
        self.content     = content
        self.viewOutput  = viewOutput
        self.contentType = contentType
        
        setNeedsDisplay()
    }
    
    //MARK: - Private
    
    func createView(cellObj: CardViewObject, idx: Int){
        
        guard let content = self.content else { return }
        
        let count = content.count
        let cardViewHeight = self.bounds.height / ((count > 1) ? CGFloat(count - 1) : CGFloat(count))
        
        let viewHeight: CGFloat = contentType == .small ? (cardViewHeight < 140 ? 140 : cardViewHeight) : 350
        
        if CGFloat(content.count) * (viewHeight - self.minShift) > CGFloat(self.bounds.height){
            
            let newShift = (self.bounds.height - (CGFloat(content.count) * viewHeight)) / CGFloat(content.count)
            
            minShift = abs(newShift)
        }
        
        let yNew = (self.yPos ?? 0)
        
        let cardView = CardView()
        
        cardView.frame = CGRect(x: 0, y: yNew, width: self.bounds.width, height: viewHeight)
        cardView.cardContentView.backgroundColor = UIColor.init(hexString: cellObj.hexColor ?? "FFFFFF")
        cardView.layer.zPosition = 1
        
        cardView.configureWith(card: cellObj, shift: minShift, viewOutput: self, contentType: contentType)
        
        self.yPos = (self.yPos ?? 0) + viewHeight - minShift
        
        self.cardViews.append(cardView)
        self.addSubview(cardView)
    }
}

extension CardMenuView: CardViewOutput {
    
    func didClickOnView(cardView: UIView, with card: CardViewObject) {
        
        self.cardViews.forEach { (cView) in
            if cView == cardView{
                UIView.animate(withDuration: 0.2, animations: {
                    cView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    self.viewOutput?.didClickOnCard(card)
                }) { (finished) in
                    UIView.animate(withDuration: 0.1) {
                        cView.transform = .identity
                    }
                }
            }
        }
    }
}
