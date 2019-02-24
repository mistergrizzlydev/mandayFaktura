//
//  InvoicePdf.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 30.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Quartz

class InvoicePdfDocument: PdfDocument{
    let invoice: Invoice
    
    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    func getDocument() -> PDFDocument {       
        let doc = PDFDocument()
        for (index, element) in self.getInvoicePages(copies: [CopyTemplate.original, CopyTemplate.copy]).enumerated() {
            doc.insert(element, at: index)
        }
    
        return doc
    }
    
    func save(dir: URL) {
        let original = self.getDocument(copyTemplate: .original)
        original.write(toFile: "\(dir.path)/Downloads/\(self.invoice.number.encodeToFilename)-org.pdf")
        let copy = self.getDocument(copyTemplate: .copy)
        copy.write(toFile: "\(dir.path)/Downloads/\(self.invoice.number.encodeToFilename)-kopia.pdf")
    }
    
    func getInvoicePages(copies: [CopyTemplate]) -> [DocumentPdfPage] {
        return copies.flatMap({copy in getInvoicePagesForCopy(copy)})
    }
    
    fileprivate func getInvoicePagesForCopy(_ copy: CopyTemplate) -> [DocumentPdfPage] {
        let invoicePageDistribution = InvoicePageDistribution(copyTemplate: copy, invoice: self.invoice)
        return invoicePageDistribution.distributeInvoiceOverPageCompositions()
            .map({pageComposition in DocumentPdfPage(pageComposition: pageComposition)})
    }
    
    private func getDocument(copyTemplate: CopyTemplate) -> PDFDocument {
        let doc = PDFDocument()
        for (index, element) in self.getInvoicePages(copies: [CopyTemplate.original]).enumerated() {
            doc.insert(element, at: index)
        }
        return doc
    }
}
