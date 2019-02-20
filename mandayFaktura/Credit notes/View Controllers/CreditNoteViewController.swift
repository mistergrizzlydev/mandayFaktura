//
//  CorrectInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 14.02.2019.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation
import Cocoa

struct CreditNoteViewControllerConstants {
    static let CREDIT_NOTE_NOTIFICATION = Notification.Name(rawValue: "CreditNoteCreated")
}

class CreditNoteViewController: AbstractInvoiceViewController {
    var invoice: Invoice?
    let creditNoteFacade = CreditNoteFacade()
    @IBOutlet weak var invoiceIssueDate: NSDatePicker!
    @IBOutlet weak var creditNoteNumber: NSTextField!
    @IBOutlet weak var creditNoteIssueDate: NSDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creditNoteNumber.stringValue = invoice!.number + "/K"
        self.dueDatePicker.dateValue = invoice!.paymentDueDate
        self.notesTextField.stringValue = invoice!.notes
        
        let tag = getPaymentFormTag(from: invoice!.paymentForm)
        self.paymentFormPopUp.selectItem(withTag: tag)
        
        self.previewButton.isEnabled = true
    }
    
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        do {
            try addBuyerToHistory(buyer: creditNote.buyer)
            creditNoteFacade.saveCreditNote(creditNote)
            NotificationCenter.default.post(name: CreditNoteViewControllerConstants.CREDIT_NOTE_NOTIFICATION, object: invoice)
            view.window?.close()
        } catch is UserAbortError {
            //
        } catch InvoiceExistsError.invoiceNumber(let number)  {
            WarningAlert(warning: "\(number) - faktura o tym numerze juź istnieje", text: "Zmień numer nowej faktury lub edytuj fakturę o numerze \(number)").runModal()
        } catch {
            //
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
     print(segue.destinationController)
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as? PdfViewController
            //vc?.invoice = newInvoice TODO:
        } else if segue.destinationController is DatePickerViewController {
            let vc = segue.destinationController as! DatePickerViewController
            if segue.identifier == NSStoryboardSegue.Identifier("dueDatePickerSegue") {
                vc.relatedDatePicker = self.dueDatePicker
            }
        } else if segue.destinationController is BuyerViewController {
            self.buyerViewController = segue.destinationController as? BuyerViewController
            self.buyerViewController!.buyer = invoice!.buyer
        } else if segue.destinationController is ItemsTableViewController {
            self.itemsTableViewController = segue.destinationController as? ItemsTableViewController
            self.itemsTableViewController!.items = invoice!.items
        } else if segue.destinationController is InvoiceDatesViewController {
            self.invoiceDatesViewController = segue.destinationController as? InvoiceDatesViewController
            self.invoiceDatesViewController!.issueDate = invoice!.issueDate
            self.invoiceDatesViewController!.sellingDate = invoice!.sellingDate
        }
    }
    
    var creditNote: CreditNote {
        get {
            let seller = self.counterpartyFacade.getSeller() ?? invoice!.seller
            let buyer = self.buyerViewController!.getBuyer()
            return aCreditNote()
                .withNumber(creditNoteNumber.stringValue)
                .withInvoiceNumber(invoice!.number)
                .withInvoiceIssueDate(self.invoiceDatesViewController!.issueDate)
                .withCreditNoteIssueDate(self.invoiceDatesViewController!.sellingDate)
                .withSeller(seller)
                .withBuyer(buyer)
                .withItems(self.itemsTableViewController!.items)
                .withPaymentForm(selectedPaymentForm!)
                .withNotes(self.notesTextField.stringValue)
                .build()
        }
    }

}
