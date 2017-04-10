//
// Created by Bulat Khabirov on 10.04.17.
// Copyright (c) 2017 Bulat Khabirov. All rights reserved.
//

import Foundation
import RealmSwift
import XlsxReaderWriter


class DataService {
    static let shared = DataService()
    let realm = try! Realm()
    
    var xlsPath = Bundle.main.path(forResource: "queue", ofType: "xlsx")!
    let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/queue.xlsx"

    /// Adds preset time periods to realm database
    func setInitialPeriodsToRealm() {
        guard realm.objects(TimePeriod.self).count < 19 else {
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
            realm.add(TimePeriod(stringValue: "00:30-00:45")!)
            realm.add(TimePeriod(stringValue: "00:45-01:00")!)
            realm.add(TimePeriod(stringValue: "01:00-01:15")!)
            realm.add(TimePeriod(stringValue: "01:15-01:30")!)
            realm.add(TimePeriod(stringValue: "01:30-01:45")!)
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
    
    func exportCacheInXLS() -> Data {
        let spreadsheet = BRAOfficeDocumentPackage.open(xlsPath)!
        let first: BRAWorksheet = spreadsheet.workbook.worksheets.first as! BRAWorksheet
        let entries = realm.objects(RegistryModel.self)
        
        print(first.cell(forCellReference: "A1", shouldCreate: true).stringValue())
        
        for (index, entry) in entries.enumerated() {
            first.cell(forCellReference: "A\(index+1)", shouldCreate: true).setStringValue(entry.name)
            first.cell(forCellReference: "B\(index+1)", shouldCreate: true).setStringValue(entry.lastName)
            first.cell(forCellReference: "C\(index+1)", shouldCreate: true).setStringValue(entry.phoneNumber)
            first.cell(forCellReference: "D\(index+1)", shouldCreate: true).setStringValue(entry.company)
            first.cell(forCellReference: "E\(index+1)", shouldCreate: true).setStringValue(entry.timePeriod.value)
        }
        print(first.cell(forCellReference: "A1", shouldCreate: true).stringValue())
        print(documentPath)
        print(spreadsheet.cacheDirectory)
        spreadsheet.save(as: documentPath)
        return try! Data(contentsOf: URL(string: "file://" + documentPath)!)
    }
}
