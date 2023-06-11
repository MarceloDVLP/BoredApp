import CoreData

class CoreDataManager {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func save(_ activity: ActivityCodable, state: ActivityState) -> ActivityEntity {
        let activityEntity = ActivityEntity(context: managedContext)
        activityEntity.accessibility = activity.accessibility
        activityEntity.activity = activity.activity
        activityEntity.key = activity.key
        activityEntity.participants = Int32(activity.participants)
        activityEntity.type = activity.type
        activityEntity.price = activity.price
        activityEntity.dateStart = Date.now
        activityEntity.state = state.rawValue
        saveContext()
        return activityEntity
    }
    
    func getUserActivities() -> [ActivityCodable] {
        let itemsFetch: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(ActivityEntity.dateStart), ascending: false)
        itemsFetch.sortDescriptors = [sortByDate]
        do {
            let results = try managedContext.fetch(itemsFetch)
            return results.map({ result in
                ActivityCodable(
                    activity: result.activity,
                    accessibility: result.accessibility,
                    type: result.type,
                    participants: Int(result.participants),
                    price: result.price,
                    key: result.key,
                    link: nil)
            })
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return []
        }
    }
    
    func get(key: String) -> ActivityEntity? {
        let itemsFetch: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
        itemsFetch.predicate = NSPredicate(format: "key ==%@", key)
        do {
            return try managedContext.fetch(itemsFetch).first
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return nil
        }
    }
}
