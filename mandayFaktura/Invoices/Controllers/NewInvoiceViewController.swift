//
//  NewInvoiceViewController.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 28.01.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Cocoa

struct NewInvoiceViewControllerConstants {
    static let INVOICE_ADDED_NOTIFICATION = Notification.Name(rawValue: "InvoiceAdded")
}

class NewInvoiceViewController: NSViewController {
    let invoiceRepository = InvoiceRepositoryFactory.instance
    let counterpartyRepository:CounterpartyRepository = CounterpartyRepositoryFactory.instance
    var itemsTableViewDelegate: ItemsTableViewDelegate?
    var selectedPaymentForm: PaymentForm? = PaymentForm.transfer
    let buyerAutoSavingController =  BuyerAutoSavingController()

    @IBOutlet weak var numberTextField: NSTextField!
    @IBOutlet weak var issueDatePicker: NSDatePicker!
    @IBOutlet weak var sellingDatePicker: NSDatePicker!
    @IBOutlet weak var buyerNameTextField: NSTextField!
    @IBOutlet weak var streetAndNumberTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var taxCodeTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var paymentFormPopUp: NSPopUpButtonCell!
    @IBOutlet weak var dueDatePicker: NSDatePicker!
    @IBOutlet weak var itemsTableView: NSTableView!
    @IBOutlet weak var removeItemButton: NSButton!
    @IBOutlet weak var previewButton: NSButton!
    @IBOutlet weak var viewSellersPopUpButton: NSPopUpButton!
    @IBOutlet weak var saveItemButton: NSButton!
    @IBOutlet weak var itemsCataloguqButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        issueDatePicker.dateValue = Date()
        sellingDatePicker.dateValue = Date()
        dueDatePicker.dateValue = Date()
        itemsTableViewDelegate = ItemsTableViewDelegate(itemsTableView: itemsTableView)
        itemsTableView.delegate = itemsTableViewDelegate
        itemsTableView.dataSource = itemsTableViewDelegate
        self.removeItemButton.isEnabled = false
        checkPreviewButtonEnabled()
        self.counterpartyRepository.getBuyers().forEach{buyer in viewSellersPopUpButton.addItem(withTitle: buyer.name)}
        self.saveItemButton.isEnabled = false

    }
    
    private func addBuyerToHistory(invoice: Invoice) throws {
        try BuyerAutoSavingController().saveIfNewBuyer(buyer: invoice.buyer)
    }
    
    @IBAction func onSaveButtonClicked(_ sender: NSButton) {
        do {
            try addBuyerToHistory(invoice: invoice)
            invoiceRepository.addInvoice(invoice)
            NotificationCenter.default.post(name: NewInvoiceViewControllerConstants.INVOICE_ADDED_NOTIFICATION, object: invoice)
            view.window?.close()
        } catch is UserAbortError {
            //
        } catch {
            //
        }
    }
    
    @IBAction func paymentFormPopUpValueChanged(_ sender: NSPopUpButton) {
        selectedPaymentForm = getPaymentFormByTag(sender.selectedTag())
    }
    
    func getPaymentFormByTag(_ tag: Int)-> PaymentForm? {
        switch tag {
        case 0:
            return PaymentForm.transfer
        case 1:
            return PaymentForm.cash
        default:
            return Optional.none
        }
    }
    
    var invoice: Invoice {
        get {
            let seller = self.counterpartyRepository.getSeller() ?? Counterparty(name: "Firma XYZ", streetAndNumber: "Ulica 1/2", city: "Gdańsk", postalCode: "00-000", taxCode: "123456789", accountNumber: "00 1234 0000 5555 7777")
            let buyer = Counterparty(name: buyerNameTextField.stringValue, streetAndNumber: streetAndNumberTextField.stringValue, city: cityTextField.stringValue, postalCode: postalCodeTextField.stringValue, taxCode: taxCodeTextField.stringValue, accountNumber:"")
            return Invoice(issueDate: issueDatePicker.dateValue, number: numberTextField.stringValue, sellingDate: sellingDatePicker.dateValue, seller: seller, buyer: buyer, items:  self.itemsTableViewDelegate!.items, paymentForm: selectedPaymentForm!, paymentDueDate: self.dueDatePicker.dateValue)
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.destinationController is PdfViewController {
            let vc = segue.destinationController as? PdfViewController
            vc?.invoice = invoice
        }
    }
    
    @IBAction func onItemsTableViewClicked(_ sender: Any) {
       self.removeItemButton.isEnabled =  self.itemsTableView.selectedRow != -1
        self.saveItemButton.isEnabled = self.itemsTableView.selectedRow != -1
    }
    
    @IBAction func onAddItemClicked(_ sender: NSButton) {
        self.itemsTableViewDelegate!.addItem()
        self.itemsTableView.reloadData()
        checkPreviewButtonEnabled()
    }
    
    @IBAction func onMinusButtonClicked(_ sender: Any) {
        self.removeItemButton.isEnabled = false
        self.itemsTableViewDelegate!.removeSelectedItem()
        self.itemsTableView.reloadData()
        checkPreviewButtonEnabled()
    }
    
    func dialogWarning(warning: String, text: String){
        let alert = NSAlert()
        alert.messageText = warning
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    private func tryWithWarning(_ fun: (NSTextField) throws -> Void, on: NSTextField) {
        do {
            try fun(on)
        } catch InputValidationError.invalidNumber(let fieldName) {
            dialogWarning(warning: "\(fieldName) - błędny format liczby", text: "Zawartość pola musi być liczbą dziesiętną np. 1,23")
        } catch {
            //
        }
    }
    
    private func checkPreviewButtonEnabled() {
        self.previewButton.isEnabled = self.itemsTableView.numberOfRows > 0
    }
   
    
    @IBAction func changeAmount(_ sender: NSTextField) {
        tryWithWarning(self.itemsTableViewDelegate!.changeAmount, on: sender)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func changeItemNetValue(_ sender: NSTextField) {
        tryWithWarning(self.itemsTableViewDelegate!.changeItemNetValue, on: sender)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func changeItemName(_ sender: NSTextField) {
        self.itemsTableViewDelegate!.changeItemName(sender)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func onVatRateSelect(_ sender: NSPopUpButton) {
        let vatRate = Decimal(sender.selectedItem!.tag)
        self.itemsTableViewDelegate!.changeVatRate(row: sender.tag, vatRate: vatRate)
        self.itemsTableView.reloadData()
    }
    
    @IBAction func onSelectBuyerButtonClicked(_ sender: NSPopUpButton) {
        let buyerName = sender.selectedItem?.title
        let buyer = self.counterpartyRepository.getBuyer(name: buyerName!)
        setBuyer(buyer: buyer ?? aCounterparty().build())
    }
    
    private func setBuyer(buyer: Counterparty) {
        self.buyerNameTextField.stringValue = buyer.name
        self.streetAndNumberTextField.stringValue = buyer.streetAndNumber
        self.cityTextField.stringValue = buyer.city
        self.postalCodeTextField.stringValue = buyer.postalCode
        self.taxCodeTextField.stringValue = buyer.taxCode
    }
    @IBAction func onUnitOfMeasureSelect(_ sender: NSPopUpButton) {
        self.itemsTableViewDelegate!.changeUnitOfMeasure(row: sender.tag, index: (sender.selectedItem?.tag)!)    }
}
