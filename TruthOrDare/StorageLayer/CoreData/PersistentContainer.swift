//
//  PersistentContainer.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 09.08.23.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func fetch<T: NSManagedObject>(of entityType: T.Type, with predicate: NSPredicate? = nil) -> [T] {
        let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        fetchRequest.predicate = predicate
        
        do {
            let fetchedResults = try self.viewContext.fetch(fetchRequest)
            return fetchedResults
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
    }
}
