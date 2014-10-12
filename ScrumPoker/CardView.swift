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
    
    convenience init(index: Int, height: CGFloat, width: CGFloat, margin: CGFloat, text: String) {
        var frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        self.init(frame: frame)
        self.bounds = frame
        
        self.layer.cornerRadius = 14
        self.backgroundColor = UIColor.whiteColor()
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        
        self.tag = index
        
        
        // Styling
        var number = UILabel(frame: CGRectMake(0, 0, width, 100))
        self.addSubview(number)
        number.center.y = self.center.y
        number.textAlignment = NSTextAlignment.Center
        number.text = String(index)
        number.font = UIFont(name: "LiipEticaBd", size: 100)
        number.textColor = UIColor(red: 0.431, green: 0.651, blue: 0.267, alpha: 1)
        
        self.index = index
        self.height = height
        self.width = width
        self.text = text

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
