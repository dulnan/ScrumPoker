//
//  Cards.swift
//  ScrumPoker
//
//  Created by Jan Hug on 05.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit
import CoreData

class Main: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBAction func goFullscreen(sender: AnyObject) {
        deck.setMode("open")
        board.scrollEnabled = false
        //board.contentSize.width = screenWidth
    }

    var deck: DeckUIScrollView!
    var board: UIScrollView!
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = CGFloat(UIScreen.mainScreen().applicationFrame.size.width)
        screenHeight = CGFloat(UIScreen.mainScreen().applicationFrame.size.height)
        
        board = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 2))
        board.backgroundColor = UIColor.blueColor()
        
        
        board.pagingEnabled = true
        board.clipsToBounds = false
        board.userInteractionEnabled = true
        
        board.contentSize = CGSize(width: screenWidth, height: (screenHeight / 2) * 6)
        
        
        for index in 0...5 {
            deck = DeckUIScrollView()
            deck.frame.origin.y = CGFloat(index) * screenHeight / 2
            deck.center.x = board.center.x
            board.addSubview(deck)
        }
        
        
        board.center = view.center
        view.addSubview(board)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
