//
//  DataManager.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 07.08.23.
//

import CoreData

class DataManager {
    let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func fetchData<T: NSManagedObject>(of type: T.Type) -> [T]? {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }
    
    func saveDataCustomContent(_ data: String, type: RoundType) {
        let newCustomContent = CustomContent(context: managedObjectContext)
        
        newCustomContent.id = UUID()
        newCustomContent.created = Date.now
        newCustomContent.data = data
        newCustomContent.type = type.rawValue
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func updateDataCustomContent(_ data: String) {
        let fetchRequest: NSFetchRequest<CustomContent> = CustomContent.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            
            if let content = results.first {
                content.modified = Date.now
                content.data = data
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("Error updating data: \(error)")
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
