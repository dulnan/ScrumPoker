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
    
    var cardIsFullScreen = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.board.delegate = self
        createCards()
    }
    
    func scrollViewDidScroll(scrollView: BoardUIScrollView) {
        // parallax effect
        var offset = (board.contentOffset.x - (2 * board.contentOffset.x)) / 4
        background.transform = CGAffineTransformMakeTranslation(offset, 0)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleCardTap(recognizer: UITapGestureRecognizer!) {
        var currentCard = recognizer.view
        var currentCardIndex = Int(board.contentOffset.x / board.bounds.size.width);
        var numberOfCards = self.board.tag - 1
        NSLog("currentCardIndex: " + currentCardIndex.description)

        board.bringSubviewToFront(currentCard!)
        
        currentCard?.layer.transform.m34 = 1.0 / -280
        
        if (cardIsFullScreen == false) {
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
                currentCard?.transform = CGAffineTransformMakeScale(1.5, 1.5)
                if (currentCardIndex != 0) {
                    var prevCard = self.board.viewWithTag(currentCardIndex - 1)
                    prevCard?.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    prevCard?.alpha = 0
                }
                if (currentCardIndex < numberOfCards) {
                    var nextCard = self.board.viewWithTag(currentCardIndex + 1)
                    nextCard?.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    nextCard?.alpha = 0
                }
                
                self.background.alpha = 0.8
                self.cardIsFullScreen = true
                self.board.scrollEnabled = false
                
            }, nil)
        } else {
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
                currentCard?.transform = CGAffineTransformMakeScale(1, 1)
                if (currentCardIndex > 0) {
                    var prevCard = self.board.viewWithTag(currentCardIndex - 1)
                    prevCard?.transform = CGAffineTransformMakeScale(1, 1)
                    prevCard?.alpha = 1
                }
                
                if (currentCardIndex < self.board.subviews.count) {
                    var nextCard = self.board.viewWithTag(currentCardIndex + 1)
                    nextCard?.transform = CGAffineTransformMakeScale(1, 1)
                    nextCard?.alpha = 1
                }
                self.background.alpha = 1
                self.cardIsFullScreen = false
                self.board.scrollEnabled = true
                
            }, nil)
        }
    
        
        
    }
    
    
    /*
    This generates the cards and adds them to the UIScrollView board
    */
    func createCards() {
        // Get screen sizes
        var screenWidth = CGFloat(UIScreen.mainScreen().applicationFrame.size.width)
        var screenHeight = CGFloat(UIScreen.mainScreen().applicationFrame.size.height)
        
        
        // Settings
        let numberOfCards = 10
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
        
        board.tag = numberOfCards
        
        
        for index in 0...numberOfCards - 1 {
            // Instantiate new CardView
            var card = CardView(index: index, height: cardHeight, width: cardWidth,
                                margin: cardMargin, text: String(index))

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
    

}
