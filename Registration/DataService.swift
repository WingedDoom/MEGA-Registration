//
// Created by Bulat Khabirov on 10.04.17.
// Copyright (c) 2017 Bulat Khabirov. All rights reserved.
//

import Foundation
import RealmSwift

class DataService {
    static let shared = DataService()
    let realm = try! Realm()

    /// Adds preset time periods to realm database
    func setInitialPeriodsToRealm() {
        guard realm.objects(TimePeriod.self).count == 0 else {
            return
        }

        // God please forgive me
        try! realm.write {
            realm.add(TimePeriod(stringValue: "21:00-21:15")!)
            realm.add(TimePeriod(stringValue: "21:15-21:30")!)
            realm.add(TimePeriod(stringValue: "21:30-21:45")!)
            realm.add(TimePeriod(stringValue: "21:45-22:00")!)
            realm.add(TimePeriod(stringValue: "22:00-22:15")!)
            realm.add(TimePeriod(stringValue: "22:15-22:30")!)
            realm.add(TimePeriod(stringValue: "22:30-22:45")!)
            realm.add(TimePeriod(stringValue: "22:45-23:00")!)
            realm.add(TimePeriod(stringValue: "23:00-23:15")!)
            realm.add(TimePeriod(stringValue: "23:15-23:30")!)
            realm.add(TimePeriod(stringValue: "23:30-23:45")!)
            realm.add(TimePeriod(stringValue: "23:45-00:00")!)
            realm.add(TimePeriod(stringValue: "00:00-00:15")!)
            realm.add(TimePeriod(stringValue: "00:15-00:30")!)
        }
    }

    func getSortedTimePeriods() -> [TimePeriod] {
        let periods = realm.objects(TimePeriod.self)
        return periods.sorted { $0 < $1 }
    }
    
    func getNumberOfRegistries(for period: TimePeriod) -> Int {
        let registries = realm.objects(RegistryModel.self)
        return (registries.filter { $0.timePeriod == period }).count
    }
}
