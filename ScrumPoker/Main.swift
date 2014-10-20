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
    @IBOutlet weak var boardContainer: UIView!
    @IBOutlet weak var background: UIImageView!

    var board: DeckUIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        board = DeckUIScrollView()
        board.center = view.center
        view.addSubview(board)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
