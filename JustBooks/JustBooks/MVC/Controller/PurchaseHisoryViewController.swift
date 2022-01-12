//
//  PurchaseHisoryViewController.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 10/01/22.
//

import UIKit
import CoreData

class PurchaseHisoryViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var topNavigation: TopNavigation!
    @IBOutlet private weak var tblPurchased: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    var coreDataPurchased = [PurchaseCDM]() {
        didSet {
            self.filteredItems = self.coreDataPurchased
        }
    }
    
    var filteredItems: [PurchaseCDM] = [] {
        didSet {
            self.tblPurchased.reloadData()
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupView() {
        self.topNavigation.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPurchaseHistory), name: .purchased_book, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPurchaseHistory), name: .deleted_purchased_book, object: nil)
        self.getPurchaseHistory()
    }
    
    @objc func getPurchaseHistory() {
        guard let purchasedBookData = CoreDataManager.shared.fetchData(type: .PurchasedBook) as? [PurchaseCDM] else {
            self.presentAlertController(.alert, message: AlertMessages.errorFetchingPurchasedBook)
            return
        }
        
        self.coreDataPurchased = purchasedBookData.sorted(by: { ($0.date ?? Date()).compare(($1.date ?? Date())) == .orderedDescending })
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    
    
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
        self.topNavigation.searchBar.resignFirstResponder()
        self.topNavigation.searchBar.text?.removeAll()
        self.filteredItems = self.coreDataPurchased
    }
    
}

//-----------------------------------------------------------------------------------------
//MARK:- Extensions

extension PurchaseHisoryViewController: NavigationSearchDelegate {
   
    func searchTextChange(searchText: String) {
        self.filteredItems = searchText != "" ? self.coreDataPurchased.filter({ ($0.book?.name ?? "").lowercased().contains(searchText) || ($0.book?.author ?? "").lowercased().contains(searchText) }) : self.coreDataPurchased
    }
   
}

extension PurchaseHisoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.emptyView.isHidden = self.filteredItems.count > 0
        return self.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblPurchased.dequeueReusableCell(withIdentifier: "PurchasedCell", for: indexPath) as! PurchasedCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.itemData = self.filteredItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension PurchaseHisoryViewController: PurchaseDelegate {
    
    func deletePurchase(indexPath: IndexPath) {
        CoreDataManager.shared.deleteData(type: self.filteredItems[indexPath.row]) { isSuccess in
            if isSuccess {
                NotificationCenter.default.post(name: .deleted_purchased_book, object: self)
                self.presentAlertController(.alert, message: AlertMessages.bookDeleted)
                return
            }
            self.presentAlertController(.alert, message: AlertMessages.errorDeletingBook)
        }
    }
}
