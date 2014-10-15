//
//  CardView.swift
//  ScrumPoker
//
//  Created by Jan Hug on 13.10.14.
//  Copyright (c) 2014 Jan Hug. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var index: Int!
    var height: CGFloat!
    var width: CGFloat!
    var margin: CGFloat!
    var text: String!
    var style: CardViewStyle!
    
    
    
    
    //
    //  convenience init with sizing, margin and the string
    //
    
    convenience init(index: Int, height: CGFloat, width: CGFloat, margin: CGFloat, text: String) {
        var frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        self.init(frame: frame)
        self.bounds = frame
        self.tag = index + 1
        
        self.style = CardViewStyle(styleIdentifier: "liip")
        self.index = index + 1
        self.height = height
        self.width = width
        self.text = text
        
        setCardStyle()
        addLabelsToCard(text, color: self.style.textColor)

    }
    
    
    
    //
    // sets the style of the card
    //
    
    func setCardStyle() {
        layer.cornerRadius = style.cornerRadius
        backgroundColor = style.backgroundColor
        
        if (style.shadow == true) {
            layer.shadowColor = UIColor.blackColor().CGColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 1
        }
    }
    
    
    //
    // adds the labels to the CardView
    //
    
    func addLabelsToCard(text: String, color: UIColor) {
        var label = UILabel(frame: CGRectMake(0, 0, self.width, 100))
        label.center.y = self.center.y
        label.textAlignment = NSTextAlignment.Center
        label.text = String(self.text)
        label.font = UIFont(name: style.font, size: 100)
        label.textColor = style.textColor
        
        self.addSubview(label)
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
