import CoreData

protocol CoreDataWorkerProtocol {
    func save(_ activity: ActivityModel, state: ActivityState, date: Date)
    func update(_ activity: ActivityModel, state: ActivityState, date: Date)
    func getUserActivities(_ completion: (([ActivityModel]) -> ())?)
}

final class CoreDataWorker: CoreDataWorkerProtocol {
    
    private let modelName: String = "BoredAppDataModel"

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

    private func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func save(_ activity: ActivityModel, state: ActivityState, date: Date) {        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            let activityEntity = ActivityEntity(context: self.managedContext)
            activityEntity.accessibility = activity.accessibility
            activityEntity.activity = activity.activity
            activityEntity.key = activity.key
            activityEntity.participants = Int32(activity.participants)
            activityEntity.type = activity.type
            activityEntity.price = activity.price
            activityEntity.dateStart = date
            activityEntity.state = state.rawValue

            self.saveContext()
        }
    }
    
    func update(_ activity: ActivityModel, state: ActivityState, date: Date) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            guard let entity = self.get(key: activity.key) else { return }
            entity.state = state.rawValue
            entity.dateEnd = date
            self.saveContext()
        }
    }
    
    func getUserActivities(_ completion: (([ActivityModel]) -> ())?) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            let itemsFetch: NSFetchRequest<ActivityEntity> = ActivityEntity.fetchRequest()
            let sortByDate = NSSortDescriptor(key: #keyPath(ActivityEntity.dateStart), ascending: false)
            itemsFetch.sortDescriptors = [sortByDate]
            do {
                let results = try self.managedContext.fetch(itemsFetch)
                let activities = results.map({ result in
                    ActivityModel(
                        activity: result.activity,
                        accessibility: result.accessibility,
                        type: result.type,
                        participants: Int(result.participants),
                        price: result.price,
                        key: result.key,
                        state: ActivityState(rawValue: result.state),
                        dateStart: result.dateStart,
                        dateEnd: result.dateEnd
                    )
                })
                completion?(activities)
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
                completion?([])
            }
        }
    }
    
    private func get(key: String) -> ActivityEntity? {
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
