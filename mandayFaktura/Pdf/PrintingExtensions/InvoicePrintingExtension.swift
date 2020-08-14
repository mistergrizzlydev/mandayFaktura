//
//  InvoicePrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

internal extension Invoice {    
    var propertiesForDisplay: [String] {
        get {
            return [self.totalNetValue.formatAmount(), "*", self.totalVatValue.formatAmount(), self.totalGrossValue.formatAmount()]
        }
    }
    
    var paymentFormLabel: String {
        switch self.paymentForm {
        case .cash:
            return self.appendI10n("gotówka", "cash")
        case .transfer:
            return self.appendI10n("przelew", "transfer")
        }
    }
    
    var printedHeader: String {
        let header =
        """
        \(appendI10n("Faktura VAT nr " + number, "Invoice no. " + number))
        """
        return header
    }
    
    var creditedNoteHeader: String {
        let header =
        """
        do faktury \(number) z dnia \(DateFormatting.getDateString(issueDate))
        """
        return header
    }
    
    var printedDates: String {
        let header =
        """
        \(appendI10n("Data wystawienia", "Date of issue")):  \(DateFormatting.getDateString(issueDate))
        \(appendI10n("Data sprzedaży", "Date of sale")): \(DateFormatting.getDateString(sellingDate))
        """
        return header
    }
    
    var printedPaymentSummary: String {
        var summary =
        """
        \(appendI10n("Do zapłaty", "Total due")): \(totalGrossValue.formatAmount()) PLN
        słownie: \(totalGrossValue.spelledOut) PLN
        \(forI10nOnly("in words: " + totalGrossValue.spelledOutEn + " PLN"))
        \(appendI10n("forma płatności", "payment form")): \(paymentFormLabel)
        \(appendI10n("termin płatności", "due date")): \(DateFormatting.getDateString(paymentDueDate))
        """
        if (self.reverseCharge) {
            summary += appendI10n("\nRozliczenie podatku: odwrotne obciążenie", "Tax to be accounted: reverse charge")
        }
        return summary
    }
    
    var printedSeller: String {
        self.seller.printedSeller(self.isInternational())
    }
    
    var printedBuyer: String {
        self.seller.printedBuyer(self.isInternational())
    }
    
    func appendI10n(_ pl: String, _ en: String) -> String {
        return pl.appendI10n(en, self.isInternational())
    }
       
    func forI10nOnly(_ en: String) -> String {
        return self.isInternational() ? en : ""
    }
    
    var itemColumnNames: [String] {
        return InvoiceItem.itemColumnNames(isI10n: self.isInternational())
    }
}
