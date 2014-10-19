//
//  Cards.swift
//  ScrumPoker
//
//  Created by Jan Hug on 05.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit
import CoreData

class Main: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var boardContainer: UIView!
    @IBOutlet weak var board: BoardUIScrollView!
    @IBOutlet weak var background: UIImageView!
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cardMargin: CGFloat!
    var cardWidth: CGFloat!
    var cardHeight: CGFloat!
    
    var cardIsFullScreen: Bool = false
    var numberOfCards: Int = 0
    var currentCardIndex: Int! = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.board.delegate = self
        calculateGlobalVariables()
        createCards()
        
        UIView.animateWithDuration(1, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
            self.slideInCards()
            }, completion: { success in
                UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: nil, animations: {
                    self.board.transform = CGAffineTransformMakeScale(1, 1)
                }, nil)
        })
        
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
            board.viewWithTag(index + 1)?.frame.origin = CGPoint(x: currentXposition, y: 0)
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
        
        // Calculate the board width:
        var boardWidth: CGFloat = (CGFloat(numberOfCards) * (cardWidth + cardMargin))
        
        
        
        // Init the container for the board
        
        boardContainer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: cardHeight)
        boardContainer.center = view.center
        
        // Init the board
        board.frame = CGRect(x: 0, y: 0, width: cardWidth + cardMargin, height: cardHeight)
        board.pagingEnabled = true
        board.clipsToBounds = false
        board.showsHorizontalScrollIndicator = false
        board.contentSize = CGSize(width: boardWidth, height: cardHeight)
        board.center.x = boardContainer.center.x
        
        
        // Iterate through plist
        for (index, cardValue) in enumerate(defaultCardDecks) {
            // Instantiate new CardView
            var card = CardView(index: index, height: cardHeight, width: cardWidth, margin: cardMargin, text: cardValue)
            
            card.frame.origin.x = (CGFloat(4) * cardWidth) + CGFloat(4) * cardMargin + (cardMargin / 2) - 10
            
            // Add a TapGestureRecognizer to the card
            var tapGesture = UITapGestureRecognizer(target: self, action: "handleCardTap:")
            card.addGestureRecognizer(tapGesture)
            
            
            board.addSubview(card)
        }
        
        
        
        
        boardContainer.addSubview(board)
        view.addSubview(boardContainer)
        board.transform = CGAffineTransformMakeScale(0.25, 0.25)
        board.contentOffset.x = (CGFloat(4) * cardWidth) + CGFloat(4) * cardMargin + (cardMargin / 2) - 10
        board.bringSubviewToFront(board.viewWithTag(5)!)
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
        
        var currentCard: UIView = self.board.viewWithTag(self.currentCardIndex)!
        
        if (action == "zoomIn") {
            currentScale = 1.5
            siblingScale = 0.8
            siblingAlpha = 0.0
            backgroundAlpha = 0.5
            self.cardIsFullScreen = true
            board.scrollEnabled = false
            board.bringSubviewToFront(currentCard)
        } else {
            currentScale = 1.0
            siblingScale = 1.0
            siblingAlpha = 1.0
            backgroundAlpha = 1.0
            self.cardIsFullScreen = false
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
