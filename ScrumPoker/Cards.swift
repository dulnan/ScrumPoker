//
//  Cards.swift
//  ScrumPoker
//
//  Created by Jan Hug on 05.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit

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
            
            
            //currentCard?.transform = CGAffineTransformMakeScale(1.6, 1.6)
            //currentCard?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            //currentCard?.layer.transform = CATransform3DMakeScale(1.6, 1.6, 1)
            //currentCard?.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
            
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
        var screenWidth = Int(UIScreen.mainScreen().applicationFrame.size.width)
        var screenHeight = Int(UIScreen.mainScreen().applicationFrame.size.height)
        
        
        // Settings
        let numberOfCards = 10
        let cardMargin = 20
        let cardWidth = (screenWidth / 2) + cardMargin
        let cardHeight = Int(Float(cardWidth) * 1.5)
        
        NSLog(String(cardWidth))
        NSLog(String(cardHeight))
        
        let liipGreen = UIColor(red: 0.431, green: 0.651, blue: 0.267, alpha: 1)
        
        
        var boardWidth = (numberOfCards * cardWidth) + ((numberOfCards) * cardMargin)

        // Init the UIScrollView container
        
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
        
        
        var cardFrame : CGRect = CGRectMake(0, 0, CGFloat(cardWidth), CGFloat(cardHeight))
        
        for index in 0...numberOfCards - 1 {
            var card = UIView()

            var currentXposition = (index * cardWidth) + index * cardMargin + (cardMargin / 2)
            card.bounds = cardFrame
            card.frame.origin = CGPoint(x: currentXposition, y: 0)
            card.layer.cornerRadius = 14
            card.backgroundColor = UIColor.whiteColor()
            
            card.layer.shadowColor = UIColor.blackColor().CGColor
            card.layer.shadowOffset = CGSize(width: 0, height: 0)
            card.layer.shadowOpacity = 0.5
            card.layer.shadowRadius = 2
            
            card.tag = index
            /*
            var number = UILabel(frame: CGRectMake(0, 0, CGFloat(cardWidth), 100))
            card.addSubview(number)
            number.center.y = card.center.y
            number.textAlignment = NSTextAlignment.Center
            number.text = String(index)
            number.font = UIFont(name: "LiipEticaBd", size: 100)
            number.textColor = liipGreen
            */
            var tapGesture = UITapGestureRecognizer(target: self, action: "handleCardTap:")
            card.addGestureRecognizer(tapGesture)
            
            board.addSubview(card)
        }
        
        ClipView.addSubview(board)
        view.addSubview(ClipView)
    }
    

}
