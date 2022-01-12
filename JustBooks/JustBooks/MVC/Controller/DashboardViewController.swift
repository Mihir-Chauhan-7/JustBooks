//
//  ViewController.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 10/01/22.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var topNavigation: TopNavigation!
    @IBOutlet private weak var tblBooks: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties

    private var purchasedBooks: [String] = []
    private var expandedBook: Int = -1 {
        didSet {
            self.tblBooks.reloadData()
        }
    }
    
    private var coreDataBooks = [BookCDM]() {
        didSet {
            self.filteredBooks = self.coreDataBooks
        }
    }
    
    private var filteredBooks: [BookCDM] = [] {
        didSet {
            self.tblBooks.reloadData()
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    private func setupView() {
        self.topNavigation.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.getBooks), name: .added_new_book, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getBooks), name: .deleted_purchased_book, object: nil)
        self.getBooks()
    }
    
    @objc private func getBooks() {
        self.topNavigation.searchBar.text?.removeAll()
        guard let bookData = CoreDataManager.shared.fetchData(type: .Book) as? [BookCDM] else {
            self.presentAlertController(.alert, message: AlertMessages.errorFetchingBook)
            return
        }
        
        if let purchasedBookData = CoreDataManager.shared.fetchData(type: .PurchasedBook) as? [PurchaseCDM] {
            self.purchasedBooks = purchasedBookData.map({ return $0.book?.bId?.uuidString ?? "" })
            self.coreDataBooks = bookData
            return
        }

        self.coreDataBooks = bookData
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
        self.filteredBooks = self.coreDataBooks
    }
}

//-----------------------------------------------------------------------------------------
//MARK:- Extensions

extension DashboardViewController: NavigationSearchDelegate {
 
    func searchTextChange(searchText: String) {
        self.expandedBook = -1
        self.filteredBooks = searchText != "" ? self.coreDataBooks.filter({ ($0.name ?? "").lowercased().contains(searchText) || ($0.synopsis ?? "").lowercased().contains(searchText) || ($0.author ?? "").lowercased().contains(searchText) }) : self.coreDataBooks
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.emptyView.isHidden = self.filteredBooks.count > 0
        return self.filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblBooks.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.indexPath = indexPath
        cell.setDescription(isExpanded: self.expandedBook != indexPath.row)
        cell.book = self.filteredBooks[indexPath.row]        
        cell.setPurchased(self.purchasedBooks.contains(cell.book.bId?.uuidString ?? ""))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

extension DashboardViewController: BookDelegate {
    
    func btnPurchaseClicked(indexPath: IndexPath) {
        
        if let book = self.filteredBooks[indexPath.row] as? BookCDM {
            self.presentAlertController(.alert, title: "Confirm Purchase", message: "Book Details \n Name : \(book.name ?? "") : Price \(book.price ?? 0)", buttons: [AlertActionType("No"), AlertActionType("Yes")]) { btnIndex in
                if btnIndex == 1 {
                    let _ = PurchasedBook(pId: UUID(), book: book, date: Date()).getPurchasedBookCDM()
                    CoreDataManager.shared.saveData { isSuccess in
                        if isSuccess {
                            NotificationCenter.default.post(name: .purchased_book, object: self)
                            self.presentAlertController(.alert, message: AlertMessages.bookPurchased, withCompletion: { _ in
                                self.getBooks()
                            })
                        
                            return
                        }
                        
                        self.presentAlertController(.alert, message: AlertMessages.errorPurchasingBook)
                    }
                }
            }
            return
        }
        
        self.presentAlertController(.alert, message: AlertMessages.errorPurchasingBook)
    }
    
    func btnExpandClicked(indexPath: IndexPath) {
        self.expandedBook = self.expandedBook == indexPath.row ? -1 : indexPath.row
    }
    
}
