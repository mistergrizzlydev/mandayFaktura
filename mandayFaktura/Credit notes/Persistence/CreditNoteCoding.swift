//
//  CreditNoteCoding.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 23.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

@objc(creditNoteCoding) class CreditNoteCoding: NSObject, NSCoding {
    let creditNote: CreditNote
    
    func encode(with coder: NSCoder) {
        coder.encode(self.creditNote.issueDate, forKey: "issueDate")
        coder.encode(self.creditNote.number, forKey: "number")
        coder.encode(self.creditNote.sellingDate, forKey: "sellingDate")
        coder.encode(CounterpartyCoding(self.creditNote.seller), forKey: "seller")
        coder.encode(CounterpartyCoding(self.creditNote.buyer), forKey: "buyer")
        coder.encode(self.creditNote.items.map{i in InvoiceItemCoding(i)}, forKey: "items")
        coder.encode(self.creditNote.paymentForm.rawValue, forKey: "paymentForm")
        coder.encode(self.creditNote.paymentDueDate, forKey: "paymentDueDate")
        coder.encode(self.creditNote.reason, forKey: "reason")
        coder.encode(self.creditNote.invoiceNumber, forKey: "invoiceNumber")
        coder.encode(self.creditNote.reverseCharge, forKey: "reverseCharge")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let number = decoder.decodeObject(forKey: "number") as? String,
            let issueDate = decoder.decodeObject(forKey: "issueDate") as? Date,
            let sellingDate = decoder.decodeObject(forKey: "sellingDate") as? Date,
            let seller = (decoder.decodeObject(forKey: "seller") as? CounterpartyCoding)?.counterparty,
            let buyer = (decoder.decodeObject(forKey: "buyer") as? CounterpartyCoding)?.counterparty,
            let itemsCoding = decoder.decodeObject(forKey: "items") as? [InvoiceItemCoding],
            let paymentDueDate = decoder.decodeObject(forKey: "paymentDueDate") as? Date,
            let invoiceNumber = decoder.decodeObject(forKey: "invoiceNumber") as? String

            else { return nil }
        let reason = decoder.decodeObject(forKey: "reason") as? String
        let items = itemsCoding.map({c in c.invoiceItem})
        let paymentForm = PaymentForm(rawValue: decoder.decodeInteger(forKey: "paymentForm"))!
        let reverseCharge = decoder.decodeBool(forKey: "reverseCharge")
        
        self.init(aCreditNote()
            .withIssueDate(issueDate)
            .withNumber(number)
            .withSellingDate(sellingDate)
            .withSeller(seller)
            .withBuyer(buyer)
            .withItems(items)
            .withPaymentForm(paymentForm)
            .withPaymentDueDate(paymentDueDate)
            .withReason(reason ?? "")
            .withInvoiceNumber(invoiceNumber)
            .withReverseCharge(reverseCharge)
            .build())
    }
    
    init(_ creditNote: CreditNote) {
        self.creditNote = creditNote
    }
}
