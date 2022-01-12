//
//  AddBookViewController.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 11/01/22.
//

import UIKit
import CoreData


class AddBookViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var txtName: UITextField!
    @IBOutlet private weak var txtPrice: UITextField!
    @IBOutlet private weak var txtAuthor: UITextField!
    @IBOutlet private weak var txtSynopsis: UITextField!
    @IBOutlet private weak var txtQuantity: UITextField!
    @IBOutlet private weak var txtDescription: UITextView!
    @IBOutlet private weak var lblDescriptionPlaceholder: UILabel!
    @IBOutlet private weak var lblCharCount: UILabel!
    @IBOutlet private weak var btnSave: UIButton!
    @IBOutlet private weak var scvAddBookForm: UIScrollView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupView() {
        DispatchQueue.main.async {
            self.txtDescription.layer.borderWidth = 1
            self.txtDescription.layer.borderColor = UIColor.systemGray5.cgColor
            self.btnSave.layer.cornerRadius = self.btnSave.bounds.height / 2
        }
    }
    
    func clearForm() {
        self.txtName.text?.removeAll()
        self.txtAuthor.text?.removeAll()
        self.txtPrice.text?.removeAll()
        self.txtQuantity.text?.removeAll()
        self.txtSynopsis.text?.removeAll()
        self.txtDescription.text?.removeAll()
        self.scvAddBookForm.endEditing(true)
    }
   
    func isValidInput() -> Bool {
        
        guard !self.txtName.text!.isEmpty else {
            self.presentAlertController(.alert, message: AlertMessages.bookNameEmpty)
            return false
        }
        
        guard !self.txtAuthor.text!.isEmpty else {
            self.presentAlertController(.alert, message: AlertMessages.bookAuthorNameEmpty)
            return false
        }
        
        guard !self.txtPrice.text!.isEmpty else {
            self.presentAlertController(.alert, message: AlertMessages.bookPriceEmpty)
            return false
        }
        
        guard !self.txtSynopsis.text!.isEmpty else {
            self.presentAlertController(.alert, message: AlertMessages.bookSynopsisEmpty)
            return false
        }
        
        guard self.txtSynopsis.text!.components(separatedBy: .whitespacesAndNewlines).count <= 10 else {
            self.presentAlertController(.alert, message: AlertMessages.bookSynopsisLimit)
            return false
        }
        
        guard !self.txtDescription.text!.isEmpty else {
            self.presentAlertController(.alert, message: AlertMessages.bookDescriptionEmpty)
            return false
        }
        
        guard self.txtDescription.text!.components(separatedBy: .whitespacesAndNewlines).count <= 300 else {
            self.presentAlertController(.alert, message: AlertMessages.bookDescriptionLimit)
            return false
        }
        
        return true
    }
    
    func saveBook() {
        if self.isValidInput() {
            let _ = Book(bId: UUID(), name: self.txtName.text ?? "", author: self.txtAuthor.text ?? "", price: Int32(self.txtPrice.text ?? "") ?? 0, quantity: Int32(self.txtQuantity.text ?? "") ?? 0, synopsis: self.txtSynopsis.text ?? "", bDescription: self.txtDescription.text ?? "").getBookCDM()
    
            CoreDataManager.shared.saveData { isSuccess in
                if isSuccess {
                    NotificationCenter.default.post(name: .added_new_book, object: self)
                    self.clearForm()
                    self.presentAlertController(.alert, message: AlertMessages.bookAdded) { _ in
                        self.tabBarController?.selectedIndex = 0
                    }
                    
                    return
                }
                
                self.presentAlertController(.alert, message: AlertMessages.errorSavingBook)
            }
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        self.saveBook()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearForm()
    }
    
}

//-----------------------------------------------------------------------------------------
//MARK:- Extensions

extension AddBookViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case txtName:
                self.txtName.resignFirstResponder()
                self.txtAuthor.becomeFirstResponder()
            case txtAuthor:
                self.txtAuthor.resignFirstResponder()
                self.txtPrice.becomeFirstResponder()
            case txtPrice:
                self.txtPrice.resignFirstResponder()
                self.txtSynopsis.becomeFirstResponder()
            case txtSynopsis:
                self.txtSynopsis.resignFirstResponder()
                self.txtQuantity.becomeFirstResponder()
            case txtQuantity:
                self.txtQuantity.resignFirstResponder()
                self.txtDescription.becomeFirstResponder()
            default: textField.resignFirstResponder()
        }
            
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scvAddBookForm.setContentOffset(CGPoint(x: 0, y: (textField.superview?.frame.origin.y)!), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scvAddBookForm.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.saveBook()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scvAddBookForm.setContentOffset(CGPoint(x: 0, y: (textView.superview?.frame.origin.y)!), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.scvAddBookForm.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblDescriptionPlaceholder.isHidden = self.txtDescription.text.count > 0
        self.lblCharCount.isHidden = !(self.txtDescription.text.count > 0)
        self.lblCharCount.text = "\(self.txtDescription.text.components(separatedBy: .whitespacesAndNewlines).count) \\ 300 Words"
    }
    
}
