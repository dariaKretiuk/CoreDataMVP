import Foundation
import CoreData

protocol PresenterInput {
    var numberOfProducts: Int { get }
    func loadPeoples()
    func person(forRow row: Int) -> NSManagedObject?
    func addObject(name: String, birthday: String?, gender: String?)
    func updateInfoObject(row: Int, name: String, birthday: String?, gender: String?)
    func deleteObject(row: Int)
}

protocol PresenterOutput: AnyObject {
    func updatePeoples()
}

class Presenter: PresenterInput {
    
    weak var view: PresenterOutput?
    private var peoples: [NSManagedObject] = []
    private var model: ModelInput
    
    init(view: PresenterOutput) {
        self.view = view
        self.model = Model()
    }
    
    var numberOfProducts: Int {
        peoples.count
    }
    
    func loadPeoples() {
//        if model.cleanCoreData() {
//            print("Clean!!")
//        }
        model.fetchAllPeople { [weak self] peoples in
            self?.peoples = peoples ?? []
            self?.view?.updatePeoples()
        }
    }
    
    func person(forRow row: Int) -> NSManagedObject? {
        guard row < peoples.count else { return nil }
        return peoples[row]
    }
    
    func addObject(name: String, birthday: String?, gender: String?) {
        model.addObject(name: name,
                        birthday: birthday ?? "",
                        gender: gender ?? ""
        )
        loadPeoples()
    }
    
    func updateInfoObject(row: Int, name: String, birthday: String?, gender: String?) {
        model.updateInfoObject(row: row,
                               name: name,
                               birthday: birthday ?? "",
                               gender: gender ?? ""
        )
        loadPeoples()
    }
    
    func deleteObject(row: Int) {
        model.deleteObject(row: row)
        loadPeoples()
    }
}
