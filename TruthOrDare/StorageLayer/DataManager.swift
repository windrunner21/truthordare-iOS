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
    
    func saveDataCustomContent() {
        let newCustomContent = CustomContent(context: managedObjectContext)
        
        newCustomContent.created = Date.now
        newCustomContent.data = ""
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
}
