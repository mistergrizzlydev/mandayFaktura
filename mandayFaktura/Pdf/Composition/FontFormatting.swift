//
//  FontFormatting.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz


class FontFormatting {
    let fontAttributesBoldLeft: [NSAttributedString.Key: NSObject]
    let fontAttributesLeft: [NSAttributedString.Key: NSObject]
    let fontAttributesLeftGrey: [NSAttributedString.Key: NSObject]
    let fontAttributesHeaderLeft: [NSAttributedString.Key: NSObject]
    let fontAttributesCenter: [NSAttributedString.Key: NSObject]
    let fontAttributesRight: [NSAttributedString.Key: NSObject]
    let fontAttributesBoldCenter: [NSAttributedString.Key: NSObject]

    
    private let paragraphStyleLeft = NSMutableParagraphStyle()
    private let paragraphStyleCenter = NSMutableParagraphStyle()
    private let paragraphStyleRight = NSMutableParagraphStyle()
    
    private let fontBold = NSFont(name: "Helvetica Bold", size: 11.0)
    private let fontHeader = NSFont(name: "Helvetica Bold", size: 16.0)
    private let font = NSFont(name: "Helvetica", size: 11.0)
  
    
    init () {
        paragraphStyleLeft.alignment = .left
        paragraphStyleCenter.alignment = .center
        paragraphStyleRight.alignment = .right


        fontAttributesBoldLeft = [
            NSAttributedString.Key.font: fontBold ?? NSFont.labelFont(ofSize: 12),
            NSAttributedString.Key.paragraphStyle:paragraphStyleLeft,
        ]
        
        fontAttributesLeft = [
            NSAttributedString.Key.font: font ?? NSFont.labelFont(ofSize: 12),
            NSAttributedString.Key.paragraphStyle:paragraphStyleLeft,
        ]
        
        fontAttributesLeftGrey = [
            NSAttributedString.Key.font: font ?? NSFont.labelFont(ofSize: 12),
            NSAttributedString.Key.paragraphStyle:paragraphStyleLeft,
            NSAttributedString.Key.foregroundColor: NSColor.lightGray
        ]
        
        fontAttributesHeaderLeft = [
            NSAttributedString.Key.font: fontHeader ?? NSFont.labelFont(ofSize: 18),
            NSAttributedString.Key.paragraphStyle:paragraphStyleLeft,
        ]
        
        fontAttributesCenter = [
            NSAttributedString.Key.font: font ?? NSFont.labelFont(ofSize: 12),
            NSAttributedString.Key.paragraphStyle:paragraphStyleCenter
        ]
        
        fontAttributesRight = [
            NSAttributedString.Key.font: font ?? NSFont.labelFont(ofSize: 12),
            NSAttributedString.Key.paragraphStyle:paragraphStyleRight
        ]
        
        fontAttributesBoldCenter = [
            NSAttributedString.Key.font: fontBold ?? NSFont.labelFont(ofSize: 12),
            NSAttributedString.Key.paragraphStyle:paragraphStyleCenter,
        ]
    }
}
