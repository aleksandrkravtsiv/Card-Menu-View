//
//  CardView.swift
//  CardsMenu
//
//  Created by Aleksandr Kravtsiv on 29.11.2019.
//  Copyright © 2019 Aleksandr Kravtsiv. All rights reserved.
//

import UIKit

protocol CardViewOutput: class {
    func didClickOnView(cardView: UIView, with card: CardViewObject)
}

class CardView: UIControl {

    //MARK: - Outlets
    
    @IBOutlet weak var cardContentView: UIView!
    
    //small card
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardSubtitleLabel: UILabel!
    @IBOutlet weak var stackViewVerticalConstraint: NSLayoutConstraint!
    
    //large card
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var largeTitle: UILabel!
    @IBOutlet weak var largeStackViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var disclosureImageView: UIImageView!
    
    //topAlertView
    @IBOutlet weak var markImageView: UIImageView!
    @IBOutlet weak var topAlertView: UIView!
    
    @IBOutlet weak var diclosureImageVerticalConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    weak var viewOutput: CardViewOutput?
    private var card: CardViewObject?
    
    //MARK: - Override

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CardView.self), owner: self, options: nil)
        cardContentView.frame = self.bounds
        cardContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.cardContentView.layer.roundCorners(radius: 13)
        self.cardContentView.layer.borderWidth = 1
        self.cardContentView.layer.borderColor = UIColor.white.cgColor
        self.cardContentView.layer.addShadow(offset: CGSize(width: 0, height: -2))
        self.isUserInteractionEnabled = true
        self.cardContentView.isUserInteractionEnabled = false
        
        topAlertView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMinYCorner]
        topAlertView.layer.cornerRadius = 13
        
        self.addTarget(self, action: #selector(didTapOnView), for: .touchUpInside)
        
        addSubview(cardContentView)
    }
    
    //MARK: - Actions
    
    @objc private func didTapOnView(){
        
        guard let card = self.card else {
            return
        }
        
        viewOutput?.didClickOnView(cardView: self, with: card)
    }
    
    //MARK: - Public
    
    func configureWith(card: CardViewObject, shift: CGFloat? = nil, viewOutput: CardViewOutput, contentType: CardContentType? = nil) {
        
        self.viewOutput = viewOutput
        self.card = card
        
        if let shift = shift {
            if contentType == .small {
                configureWithSmallCard(shift)
            } else {
                configureWithLargeCard(shift)
            }
        }
        
        configureAlertView()
    }
    
    private func configureWithLargeCard(_ shift: CGFloat) {
        
        guard let card = self.card else { return }
        
        self.iconImageView.isHidden     = true
        self.cardTitleLabel.isHidden    = true
        self.cardSubtitleLabel.isHidden = true
        
        self.largeImageView.image    = card.cardViewType?.iconImage ?? UIImage()
        self.largeTitle.text         = card.cardTitle
        self.markImageView.tintColor = UIColor.init(hexString: card.hexColor ?? "FFFFFF")
        
        largeStackViewVerticalConstraint.constant = largeStackViewVerticalConstraint.constant - shift/2
        diclosureImageVerticalConstraint.constant = largeStackViewVerticalConstraint.constant
    }
    
    private func configureWithSmallCard(_ shift: CGFloat) {
        
        guard let card = self.card else { return }
        
        self.largeImageView.isHidden      = true
        self.largeTitle.isHidden          = true
        self.disclosureImageView.isHidden = true
        
        if shift > 20 {
            stackViewVerticalConstraint.constant = stackViewVerticalConstraint.constant - shift/2
            diclosureImageVerticalConstraint.constant = stackViewVerticalConstraint.constant
        }
        
        cardTitleLabel.text = card.cardTitle
        cardSubtitleLabel.isHidden = card.subtitle.isEmpty
        cardSubtitleLabel.text = card.subtitle

        self.markImageView.tintColor = UIColor.init(hexString: card.hexColor ?? "FFFFFF")
        self.iconImageView.image = card.cardViewType?.iconImage ?? UIImage()
    }
    
    private func configureAlertView() {
        
        guard let card = self.card else { return }
        
        markImageView.isHidden = false
        topAlertView.isHidden = false
        
        switch card.itemState {
        case .alert:
            markImageView.image = UIImage(named: "card_menu_attention")
        case .locked:
            markImageView.image = UIImage(named: "card_menu_locked")
        default:
            markImageView.isHidden = true
            topAlertView.isHidden = true
        }
    }
}
