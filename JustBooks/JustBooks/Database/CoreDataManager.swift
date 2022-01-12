//
//  CoreDataManager.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 12/01/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    enum Entities : String {
        case Book          = "BookCDM"
        case PurchasedBook = "PurchaseCDM"
    }
    
    static let shared = CoreDataManager()
    var managedContext = AppDelegate.shared.persistentContainer.viewContext
    
    func saveData(completion: (Bool) -> ()) {
        do {
            try managedContext.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
}

extension CoreDataManager {
    
    func fetchData<T>(type: Entities) -> [T] where T: NSManagedObject {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: type.rawValue)
        do {
            let result = try AppDelegate.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return result ?? []
        } catch  {
            print("Error Fetching \(type.rawValue).")
            return []
        }
    }
    
    func deleteData<T>(type: T, completion: ((Bool) -> ())) where T: NSManagedObject {
        do {
            self.managedContext.delete(type)
            try self.managedContext.save()
            completion(true)
        }
        catch {
            completion(false)
        }
    }
}
