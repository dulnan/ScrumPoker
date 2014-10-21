//
//  BoardUIScrollView.swift
//  ScrumPoker
//
//  Created by Jan Hug on 08.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit

class DeckUIScrollView: UIScrollView, UIScrollViewDelegate {
    
    var cardIsFullScreen: Bool = false
    var numberOfCards: Int = 0
    var currentCardIndex: Int = 0
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cardMargin: CGFloat!
    var cardWidth: CGFloat!
    var cardHeight: CGFloat!
    
    override init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.delegate = self
        
        calculateGlobalVariables()
        
        self.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        self.pagingEnabled = true
        self.clipsToBounds = false
        self.showsHorizontalScrollIndicator = true
        self.center = super.center
        self.userInteractionEnabled = false
        
        self.contentSize = CGSize(width: cardWidth, height: cardHeight)
        
        createCards()
        
        self.backgroundColor = UIColor.redColor()
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return true
    }
    */
    func scrollViewDidScroll(scrollView: DeckUIScrollView) {
        var offset = (self.contentOffset.x - (2 * self.contentOffset.x)) / 4
        //background.transform = CGAffineTransformMakeTranslation(offset, 0)
    }
    
    func scrollViewDidEndDecelerating(scrollView: DeckUIScrollView) {
        currentCardIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width) + 1;
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    
    
    func setMode(mode: String) {
        if (mode == "open") {
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
                self.slideInCards()
            }, nil)
            var boardWidth: CGFloat = (CGFloat(numberOfCards) * (cardWidth + cardMargin))
            self.contentSize = CGSize(width: boardWidth, height: cardHeight)
            self.userInteractionEnabled = true
        } else {
            // close
        }
    }
    
    
    
    /*
    This generates the cards and adds them to the UIScrollView board
    */
    func createCards() {
        // Load the CardDecks Plist
        let pathToCardDecks = NSBundle.mainBundle().pathForResource("CardDecks", ofType: "plist")!;
        let cardDecks = NSDictionary(contentsOfFile: pathToCardDecks)
        var defaultCardDecks = cardDecks["default"] as Array<String>
        
        // Settings
        self.numberOfCards = defaultCardDecks.count
        
        // Iterate through plist
        for (index, cardValue) in enumerate(defaultCardDecks) {
            // Instantiate new CardView
            var card = CardView(index: index, height: cardHeight, width: cardWidth, margin: cardMargin, text: cardValue)
            
            //card.frame.origin.x = (CGFloat(4) * cardWidth) + CGFloat(4) * cardMargin + (cardMargin / 2) - 10
            card.frame.origin.x = 0
            
            // Add a TapGestureRecognizer to the card
            var tapGesture = UITapGestureRecognizer(target: self, action: "handleCardTap:")
            card.addGestureRecognizer(tapGesture)
            
            
            self.addSubview(card)
        }
        
        self.contentOffset.x = (CGFloat(4) * cardWidth) + CGFloat(4) * cardMargin + (cardMargin / 2) - 10
        self.bringSubviewToFront(self.viewWithTag(5)!)
    }
    
    
    
    
    func handleCardTap(recognizer: UITapGestureRecognizer!) {
        var currentCard = recognizer.view
        
        if (cardIsFullScreen == false) {
            cardTransition("zoomIn")
        } else {
            cardTransition("zoomOut")
        }
        
    }
    
    
    func cardTransition(action: String) {
        var currentScale: CGFloat
        var siblingScale: CGFloat
        var siblingAlpha: CGFloat
        var backgroundAlpha: CGFloat
        
        var currentCard: UIView = self.viewWithTag(self.currentCardIndex)!
        
        if (action == "zoomIn") {
            currentScale = 1.5
            siblingScale = 0.8
            siblingAlpha = 0.0
            backgroundAlpha = 0.5
            self.cardIsFullScreen = true
            self.scrollEnabled = false
            self.bringSubviewToFront(currentCard)
        } else {
            currentScale = 1.0
            siblingScale = 1.0
            siblingAlpha = 1.0
            backgroundAlpha = 1.0
            self.cardIsFullScreen = false
            self.scrollEnabled = true
        }
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
            currentCard.transform = CGAffineTransformMakeScale(currentScale, currentScale)
            
            if (self.currentCardIndex > 1) {
                var prevCard: UIView = self.viewWithTag(self.currentCardIndex - 1)!
                prevCard.transform = CGAffineTransformMakeScale(siblingScale, siblingScale)
                prevCard.alpha = siblingAlpha
            }
            
            if (self.currentCardIndex < self.numberOfCards) {
                var nextCard: UIView = self.viewWithTag(self.currentCardIndex + 1)!
                nextCard.transform = CGAffineTransformMakeScale(siblingScale, siblingScale)
                nextCard.alpha = siblingAlpha
            }
            
            }, nil)
    }
    
    
    
    
    
    func calculateGlobalVariables() {
        screenWidth = CGFloat(UIScreen.mainScreen().applicationFrame.size.width)
        screenHeight = CGFloat(UIScreen.mainScreen().applicationFrame.size.height)
        cardMargin = 20
        cardWidth = (screenWidth / 2) + cardMargin
        cardHeight = cardWidth * 1.5
    }
    
    
    
    
    
    func slideInCards() {
        for index in 0...numberOfCards - 1 {
            //Calculate where to put the next card and set the origin
            var currentXposition = (CGFloat(index) * cardWidth) + CGFloat(index) * cardMargin + (cardMargin / 2)
            self.viewWithTag(index + 1)?.frame.origin = CGPoint(x: currentXposition, y: 0)
        }
    }
    
    

}
