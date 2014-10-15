//
//  BoardUIScrollView.swift
//  ScrumPoker
//
//  Created by Jan Hug on 08.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit

class BoardUIScrollView: UIScrollView, UIScrollViewDelegate {
    
    var numberOfCards: Int = 0
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return true
    }

}
