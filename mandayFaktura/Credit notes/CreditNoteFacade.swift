//
//  CreditNoteFacade.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 17.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

class CreditNoteFacade {
    let creditNoteRepository: CreditNoteRepository = CreditNoteRepositoryFactory.instance
    let invoiceNumbering: InvoiceNumbering = InvoiceNumbering()
    let creditNoteNumbering: CreditNoteNumbering = CreditNoteNumbering()
    
    func saveCreditNote(_ creditNote: CreditNote) throws {
        try creditNoteNumbering.verifyCreditNoteWithNumberDoesNotExist(creditNoteNumber: creditNote.number)
        try invoiceNumbering.verifyInvoiceWithNumberDoesNotExist(invoiceNumber: creditNote.number)
        creditNoteRepository.addCreditNote(creditNote)
    }
    
    func getCreditNotes() -> [CreditNote] {
        return creditNoteRepository.getCreditNotes()
    }
    
    func delete(_ creditNote: CreditNote) {
        creditNoteRepository.deleteCreditNote(creditNote)
    }
    
    func creditNoteForInvoice(invoiceNumber: String) -> CreditNote? {
        return creditNoteRepository.findBy(invoiceNumber: invoiceNumber)
    }
}
