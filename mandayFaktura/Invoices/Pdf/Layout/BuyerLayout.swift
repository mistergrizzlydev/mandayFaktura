//
//  BuyerLayout.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class BuyerLayout : AbstractComponent {
    static let height = CGFloat(90.0)
    static let marginTop = CGFloat(20)
    static let yPosition = HeaderInvoiceDatesLayout.yPosition - marginTop - height
    
    let content: String
    init(content: String) {
        self.content = content
        super.init(debug: InvoicePageComposition.debug)
    }
    
    func draw() {
        let xPosition = 1/2 * InvoicePageComposition.pdfWidth
        let width = 1/2 * InvoicePageComposition.pdfWidth
        markBackgroundIfDebug(xPosition, SellerLayout.yPosition, width, SellerLayout.height)
        let rect = NSMakeRect(xPosition, SellerLayout.yPosition, width, SellerLayout.height)
        content.draw(in: rect, withAttributes: self.fontFormatting.fontAttributesBoldLeft)
    }
}
