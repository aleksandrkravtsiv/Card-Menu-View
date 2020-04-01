//
//  ViewController.swift
//  Card Menu
//
//  Created by Aleksandr Kravtsiv on 01.04.2020.
//  Copyright © 2020 Aleksandr Kravtsiv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var cardMenu: CardMenuView!
    
    
    //MARK: - Properties
    
    lazy var cardMenuInteractor: CardMenuInteractor = {
        return CardMenuInteractor()
    }()
    
    private var contentType: CardContentType = .large {
        didSet{
            drawMenu()
        }
    }
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawMenu()
    }

    //MARK - Actions
    
    @IBAction func didChangeMenuType(_ sender: UISwitch) {
        contentType = sender.isOn ? .large : .small
    }
    
    
    //MARK: - Private
    
    private func drawMenu() {
        
        let content = cardMenuInteractor.obtainCardMenuContent(contentType)
        
        cardMenu.configureWith(content: content, contentType: contentType, viewOutput: self)
    }
    
}

extension ViewController: CardMenuViewOutput {
   
    func didClickOnCard(_ card: CardViewObject) {
        print(card.cardTitle)
    }
    
}
