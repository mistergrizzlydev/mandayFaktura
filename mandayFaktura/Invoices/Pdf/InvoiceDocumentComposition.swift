//
//  InvoiceDocumentComposition.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 03.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation


class InvoiceDocumentComposition {
    let invoice:Invoice
    init(invoice: Invoice) {
        self.invoice = invoice
    }
    
    fileprivate func getInvoicePagesForCopy(_ copy: CopyTemplate) -> [InvoicePdfPage] {
        return distributeInvoiceOverPageCompositions(copyTemplate: copy)
            .map({pageComposition in InvoicePdfPage(pageComposition: pageComposition)})
    }
    
    fileprivate func minimumPageComposition(_ copyTemplate: CopyTemplate) -> InvoicePageCompositionBuilder {
        return anInvoicePageComposition()
            .withHeader(HeaderLayout(content: invoice.printedHeader))
            .withDates(HeaderInvoiceDatesLayout(content: invoice.printedDates))
            .withCopyLabel(CopyLabelLayout(content: copyTemplate.rawValue))
            .withSeller(SellerLayout(content: invoice.seller.printedSeller))
            .withBuyer(BuyerLayout(content: invoice.buyer.printedBuyer))
    }
    
    fileprivate func distributeInvoiceOverPageCompositions(copyTemplate: CopyTemplate) -> [InvoicePageComposition] {
        let pagesWithTableData: [InvoicePageCompositionBuilder] = getItemTableDataChunksPerPage().map({itemTableDataChunk in
            let invoicePageComposition = self.minimumPageComposition(copyTemplate)
                .withItemTableData(ItemTableLayout(headerData: InvoiceItem.itemColumnNames, tableData: itemTableDataChunk))
            //TODO fix NPE on vat breakdown empty
            return invoicePageComposition
        })
        let lastPage:InvoicePageCompositionBuilder = pagesWithTableData.last!
        let itemsSummaryYPosition = ItemTableLayout.yPosition - lastPage.itemTableData!.height //TODO: clean this 
        lastPage.withItemsSummary(ItemsSummaryLayout(summaryData: ["Razem:"] + invoice.propertiesForDisplay, yPosition: itemsSummaryYPosition))
            .withVatBreakdownTableData(getVatBreakdownTableData())
            .withPaymentSummary(PaymentSummaryLayout(content: invoice.printedPaymentSummary))
            .withNotes(NotesLayout(content: invoice.notes))
        return pagesWithTableData.map({page in page.build()})
    }
    
    func getVatBreakdownTableData() -> VatBreakdownLayout {
        var breakdownTableData: [[String]] = []
        for breakdownIndex in 0 ..< self.invoice.vatBreakdown.entries.count {
            let breakdown = self.invoice.vatBreakdown.entries[breakdownIndex]
            breakdownTableData.append(breakdown.propertiesForDisplay)
        }
        return VatBreakdownLayout(breakdownLabel: "W tym:", breakdownTableData: breakdownTableData)
    }
    
    func getItemTableDataChunksPerPage() -> [[[String]]] {
        var itemTableData: [[String]] = []
        for itemCounter in 0 ..< self.invoice.items.count {
            let properties = [(itemCounter + 1).description] + self.invoice.items[itemCounter].propertiesForDisplay
            itemTableData.append(properties)
        }
        return [itemTableData]
    }
    
    func getInvoicePages(copies: [CopyTemplate]) -> [InvoicePdfPage] {
        return copies.flatMap({copy in getInvoicePagesForCopy(copy)})
    }
}

