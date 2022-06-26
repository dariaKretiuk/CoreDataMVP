import Foundation
import CoreData

protocol ModelInput: class {
    func fetchAllPeople(completion: @escaping ([NSManagedObject]?) -> ())
    func addObject(name: String, birthday: String?, gender: String?)
    func cleanCoreData() -> Bool
    func updateInfoObject(row: Int, name: String, birthday: String, gender: String)
    func deleteObject(row: Int)
}

class Model: ModelInput {
    
    // MARK: - Singleton
    static let instance = Model()

    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "CoreDataMVP")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
    }()
    
    // MARK: - Core Data Saving support
    
    func cleanCoreData() -> Bool {
        let context = persistentContainer.viewContext
        let delete = NSBatchDeleteRequest(fetchRequest: Person.fetchRequest())
        
        do {
            try context.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
          do {
            try context.save()
          } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
        }
    }
    
    func fetchPerson(index: Int) -> NSManagedObject? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            let peoples = try managedContext.fetch(fetchRequest)
            return peoples[index]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

    func fetchAllPeople(completion: @escaping ([NSManagedObject]?) -> ()) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            let peoples = try managedContext.fetch(fetchRequest)
            completion(peoples)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            completion(nil)
        }
    }
    
    func updateInfoObject(row: Int, name: String, birthday: String, gender: String) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            let peoples = try managedContext.fetch(fetchRequest)
            let person = peoples[row]
            person.setValue(name, forKey: "name")
            person.setValue(birthday, forKey: "birthday")
            person.setValue(gender, forKey: "gender")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }

    func addObject(name: String, birthday: String?, gender: String?) {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        person.setValue(birthday ?? "", forKeyPath: "birthday")
        person.setValue(gender ?? "", forKeyPath: "gender")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteObject(row: Int) {
        let managedContext = persistentContainer.viewContext
        guard let person = self.fetchPerson(index: row) else { return }
        managedContext.delete(person)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
