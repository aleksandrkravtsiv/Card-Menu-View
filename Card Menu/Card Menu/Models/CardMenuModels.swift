//
//  CardMenuModels.swift
//  Card Menu
//
//  Created by Aleksandr Kravtsiv on 01.04.2020.
//  Copyright © 2020 Aleksandr Kravtsiv. All rights reserved.
//

import Foundation
import UIKit

class CardMenuDisplayModel: CardViewObject {
    
    var cardTitle: String
    var subtitle: String
    var hexColor: String?
    var cardViewType: CardViewType?
    var itemState: CardViewItemState?
    var isLocked: Bool {
        return false
    }
    
    internal init(cardTitle: String, subtitle: String, hexColor: String?, itemState: CardViewItemState?, cardViewType: CardViewType?) {
          self.cardTitle = cardTitle
          self.subtitle = subtitle
          self.hexColor = hexColor
          self.itemState = itemState
          self.cardViewType = cardViewType
      }
    
}
