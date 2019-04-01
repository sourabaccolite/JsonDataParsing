//
//  ViewController.swift
//  JSONParsing
//
//  Created by Sourab on 01/04/19.
//  Copyright © 2019 Sourab. All rights reserved.
//

import UIKit

enum SortingType {
    case sortingTypePopularityDsc
}

class ViewController: BaseViewController {
    
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var activityIndicatorLoader: UIActivityIndicatorView!
    @IBOutlet weak var tableViewProducts: UITableView!
    
    var arrAllData = [Products]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewProducts.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductsTableViewCell")
        
        fetchProductDetails()
    }
    
    func fetchProductDetails() {
        activityIndicatorLoader.startAnimating()

        arrAllData = DataModel().fetchAllData()
        if arrAllData.count > 0 {
            tableViewProducts.reloadData()
            activityIndicatorLoader.stopAnimating()
        } else {
            fetchDataFromApi()
        }
    }
    
    func fetchDataFromApi() {
        if Reachablity.isConnectedToNetwork() {
            WebService().getDetailsWithEndPointUrl(endPointUrl: AppManager.sharedInstance.getBaseURL()!, SuccessBlock: { data in
                self.fetchAllProducts()
            }) { err in
                self.activityIndicatorLoader.stopAnimating()
                print(err)
            }
        } else {
            activityIndicatorLoader.stopAnimating()
            showAlert(withTitle: "Oops!", alertMessage: "Please check your internet connection!!", actionTitle: "Ok")
        }
    }
    
    func fetchAllProducts() {
        arrAllData = DataModel().fetchAllData()
        tableViewProducts.reloadData()
        activityIndicatorLoader.stopAnimating()
    }
    
    @IBAction func refreshBtnAction(_ sender: Any) {
        activityIndicatorLoader.startAnimating()
        arrAllData = [Products]()
        tableViewProducts.reloadData()
        fetchDataFromApi()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellProductsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath) as! ProductsTableViewCell
        
        let dataProducts: Products = arrAllData[indexPath.row]
        if let price = dataProducts.title {
            cellProductsTableViewCell.labelTitle.text = price + "  (#\(dataProducts.popularity))"
        }
        cellProductsTableViewCell.labelPrice.text = "₹" + String(dataProducts.price)
        
        if indexPath.row%2 == 0 {
            cellProductsTableViewCell.backgroundColor = UIColor(red: 240.0/255.0, green: 249.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        } else {
            cellProductsTableViewCell.backgroundColor = UIColor.white
        }
        cellProductsTableViewCell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cellProductsTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
