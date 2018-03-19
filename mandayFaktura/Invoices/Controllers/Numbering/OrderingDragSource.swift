//
//  OrderingDragSource.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 19.03.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa


extension NSView {
    /**
     Take a snapshot of a current state NSView and return an NSImage
     
     - returns: NSImage representation
     */
    func snapshot() -> NSImage {
        let pdfData = dataWithPDF(inside: bounds)
        let image = NSImage(data: pdfData)
        return image ?? NSImage()
    }
}


class OrderingDragSource: NSView {
    static let type = NSPasteboard.PasteboardType(rawValue: "com.github.wkicior.mandayFaktura")
    var action: String {
        get {
            return ""
        }
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString(self.action, forType: OrderingDragSource.type)
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        draggingItem.setDraggingFrame(self.bounds, contents: self.snapshot())
        
        beginDraggingSession(with: [draggingItem], event: theEvent, source: self)
        
    }
}

extension OrderingDragSource : NSDraggingSource {
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor
        context: NSDraggingContext) -> NSDragOperation {
        
        switch(context) {
        case .outsideApplication:
            return NSDragOperation()
        case .withinApplication:
            return .generic
        }
    }
}

class IncrementNumberSourceView: OrderingDragSource {
    override var action: String {
        get {
            return "increment number"
        }
    }
}

class FixedPartSourceView: OrderingDragSource {
    override var action: String {
        get {
            return "fixed part"
        }
    }
}

class YearSourceView: OrderingDragSource {
    override var action: String {
        get {
            return "year"
        }
    }
}

