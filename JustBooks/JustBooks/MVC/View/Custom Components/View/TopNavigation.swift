//
//  TopNavigation.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 12/01/22.
//

import Foundation
import UIKit

protocol NavigationSearchDelegate {
    func searchTextChange(searchText: String)
}

@IBDesignable
class TopNavigation: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let nibName = "TopNavigation"
    var delegate: NavigationSearchDelegate?
    var contentView: UIView?
    
    @IBInspectable var titleText: String? {
        didSet {
            self.lblTitle.text = titleText
        }
    }
    
    @IBInspectable var searchPlaceholder: String? {
        didSet {
            self.searchBar.placeholder = searchPlaceholder
        }
    }
    
    @IBInspectable var isSearchBarHidden: Bool = true {
        didSet {
            self.searchBar.isHidden = !isSearchBarHidden
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.contentView?.prepareForInterfaceBuilder()
    }
    
}

extension TopNavigation: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate?.searchTextChange(searchText: searchText.lowercased())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}
