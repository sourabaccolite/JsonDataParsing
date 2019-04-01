//
//  DataModel.swift
//  JSONParsing
//
//  Created by Sourab on 01/04/19.
//  Copyright © 2019 Sourab. All rights reserved.
//

import UIKit
import CoreData

class DataModel: NSObject {

    func saveProductDetails(withJsonData data: [String: Any]) {
        //URL
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        //End
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let productsEntity = NSEntityDescription.entity(forEntityName: "Products", in: managedContext)!
        
        let allArrObj: [String: Any] = data["products"] as! [String : Any]
        
        for (eachKeys, eachValues) in allArrObj {
            guard let productId: Int32 = Int32(eachKeys) else {
                continue
            }
            let objEachValues : [String : Any] = eachValues as! [String : Any]
            var objProducts: Products? = nil
            let fetchedObj: Array = fetchDataById(withId: productId)
            if fetchedObj.count > 0 {
                objProducts = fetchedObj[0] as? Products
            } else {
                objProducts = NSManagedObject(entity: productsEntity, insertInto: managedContext) as? Products
            }
            
            for (keys, values) in objEachValues {
                objProducts?.productId = productId
                
                switch (keys) {
                case "title":
                    if let strTitle: String = values as? String {
                        objProducts?.title = strTitle
                    }
                    break;
                case "popularity":
                    if let str = values as? String, let intPopularity = Int32(str) {
                        objProducts?.popularity = intPopularity
                    }
                    break;
                case "price":
                    if let str = values as? String, let intPrice = Int32(str) {
                        objProducts?.price = intPrice
                    }
                    break;
                case "subcategory":
                    if let intSubCat: String = values as? String {
                        objProducts?.subcategory = intSubCat
                    }
                    break;
                default:
                    break;
                }
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func fetchDataById(withId productId: Int32) -> Array<Any> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let productRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        productRequest.returnsObjectsAsFaults = false
        productRequest.predicate = NSCompoundPredicate.init(type: .and, subpredicates: [
            NSPredicate.init(format: "productId == \(productId)")
            ])
        do {
            let result = try managedContext.fetch(productRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    func fetchAllData() -> [Products] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let productsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        productsRequest.returnsObjectsAsFaults = false
        //SortDescriptor
        let sectionSortDescriptor = NSSortDescriptor(key: "popularity", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        productsRequest.sortDescriptors = sortDescriptors
        //End
        do {
            let result = try managedContext.fetch(productsRequest)
            return result as! [Products]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
