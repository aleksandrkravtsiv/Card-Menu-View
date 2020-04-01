//
//  CardMenuInteractor.swift
//  Card Menu
//
//  Created by Aleksandr Kravtsiv on 01.04.2020.
//  Copyright © 2020 Aleksandr Kravtsiv. All rights reserved.
//

import UIKit

class CardMenuInteractor: NSObject {

    func obtainCardMenuContent(_ contentType: CardContentType) -> [CardViewObject] {
        
        let objectsCount = contentType == .small ? 8 : 4
        let hexColors = ["FFDBAC","F1C27D","E0AC69","C68642","8D5524","843722","3D0C02","260701"]
        let itemState: [CardViewItemState] = [.locked, .ready, .alert]
        let cardViewType: [CardViewType] = [.daily, .photo, .news, .settings]
        
        var content = [CardViewObject]()
        
        for i in 0..<objectsCount {
            
            let card = CardMenuDisplayModel(cardTitle: "Item \(i+1)", subtitle: "Subtitle", hexColor: hexColors[i], itemState: itemState[Int.random(in: 0...itemState.count-1)], cardViewType: cardViewType[Int.random(in: 0...cardViewType.count-1)])
            
            content.append(card)
        }
        
        return content
    }
    
    
}
