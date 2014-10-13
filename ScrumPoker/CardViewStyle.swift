//
//  CardViewStyle.swift
//  ScrumPoker
//
//  Created by Jan Hug on 13.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit

class CardViewStyle {
   
    var backgroundColor: UIColor
    var textColor: UIColor
    var shadow: Bool
    var font: String
    var cornerRadius: CGFloat
    
    init(styleIdentifier: String) {
        let path = NSBundle.mainBundle().pathForResource("CardStyles", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let style: AnyObject = dict.objectForKey(styleIdentifier)!
        
        let backgroundcolor: AnyObject = style.objectForKey("backgroundcolor")!
        let textcolor: AnyObject = style.objectForKey("textcolor")!
        let font = style.objectForKey("font") as String
        
        self.backgroundColor = UIColor.whiteColor()
        self.textColor = UIColor(red: 110 / 255, green: 166 / 255, blue: 68 / 255, alpha: 1)
        self.shadow = true
        self.font = font
        self.cornerRadius = 14
    }

    
}
