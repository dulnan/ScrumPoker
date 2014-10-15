//
//  Cards.swift
//  ScrumPoker
//
//  Created by Jan Hug on 05.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit
import CoreData

class Cards: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var ClipView: UIView!
    @IBOutlet weak var board: BoardUIScrollView!
    @IBOutlet weak var background: UIImageView!
    
    var cardIsFullScreen: Bool!
    var numberOfCards: Int!
    var currentCardIndex: Int! = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.board.delegate = self
        
        self.cardIsFullScreen = false
        self.numberOfCards = 0
        
        createCards()
    }
    
    func scrollViewDidScroll(scrollView: BoardUIScrollView) {
        // parallax effect
        var offset = (board.contentOffset.x - (2 * board.contentOffset.x)) / 4
        background.transform = CGAffineTransformMakeTranslation(offset, 0)
    }
    
    func scrollViewDidEndDecelerating(scrollView: BoardUIScrollView) {
        currentCardIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width) + 1;
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    
    
    /*
    This generates the cards and adds them to the UIScrollView board
    */
    func createCards() {
        // Get screen sizes
        var screenWidth = CGFloat(UIScreen.mainScreen().applicationFrame.size.width)
        var screenHeight = CGFloat(UIScreen.mainScreen().applicationFrame.size.height)
        
        
        // Settings
        self.numberOfCards = 10
        let cardMargin: CGFloat = 20
        let cardWidth: CGFloat = (screenWidth / 2) + cardMargin
        let cardHeight: CGFloat = cardWidth * 1.5
        
        // Calculate the board width:
        var boardWidth: CGFloat = (CGFloat(numberOfCards) * (cardWidth + cardMargin))
        
        
        
        // Init the container for the custom UIScrollView
        
        ClipView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: cardHeight)
        ClipView.center = view.center
        
        // Init the board
        board.frame = CGRect(x: 0, y: 0, width: cardWidth + cardMargin, height: cardHeight)
        board.pagingEnabled = true
        board.clipsToBounds = false
        board.showsHorizontalScrollIndicator = false
        board.contentSize = CGSize(width: boardWidth, height: cardHeight)
        board.center.x = ClipView.center.x
        
        for index in 0...numberOfCards - 1 {
            // Instantiate new CardView
            var card = CardView(index: index, height: cardHeight, width: cardWidth,
                margin: cardMargin, text: String(index + 1))
            
            //Calculate where to put the next card and set the origin
            var currentXposition = (CGFloat(index) * cardWidth) + CGFloat(index) * cardMargin + (cardMargin / 2)
            card.frame.origin = CGPoint(x: currentXposition, y: 0)
            
            // Add a TapGestureRecognizer to the card
            var tapGesture = UITapGestureRecognizer(target: self, action: "handleCardTap:")
            card.addGestureRecognizer(tapGesture)
            
            
            board.addSubview(card)
        }
        
        ClipView.addSubview(board)
        view.addSubview(ClipView)
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
        
        var currentCard: UIView = self.board.viewWithTag(currentCardIndex)!
        
        if (action == "zoomIn") {
            currentScale = 1.5
            siblingScale = 0.8
            siblingAlpha = 0.0
            backgroundAlpha = 0.5
            cardIsFullScreen = true
            board.scrollEnabled = false
            board.bringSubviewToFront(currentCard)
        } else {
            currentScale = 1.0
            siblingScale = 1.0
            siblingAlpha = 1.0
            backgroundAlpha = 1.0
            cardIsFullScreen = false
            board.scrollEnabled = true
        }
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
            currentCard.transform = CGAffineTransformMakeScale(currentScale, currentScale)
            
            if (self.currentCardIndex > 1) {
                var prevCard: UIView = self.board.viewWithTag(self.currentCardIndex - 1)!
                prevCard.transform = CGAffineTransformMakeScale(siblingScale, siblingScale)
                prevCard.alpha = siblingAlpha
            }
            
            if (self.currentCardIndex < self.numberOfCards) {
                var nextCard: UIView = self.board.viewWithTag(self.currentCardIndex + 1)!
                nextCard.transform = CGAffineTransformMakeScale(siblingScale, siblingScale)
                nextCard.alpha = siblingAlpha
            }
            
            self.background.alpha = backgroundAlpha
            
        }, nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
