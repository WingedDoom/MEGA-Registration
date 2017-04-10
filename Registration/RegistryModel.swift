//
//  RegistryModel.swift
//  Registration
//
//  Created by Bulat Khabirov on 09.04.17.
//  Copyright © 2017 Bulat Khabirov. All rights reserved.
//

import UIKit
import RealmSwift

class RegistryModel: Object {
    dynamic var name = ""
    dynamic var phoneNumber = ""
    dynamic var lastName = ""
    
    dynamic var company = ""
    
    dynamic var timePeriod: TimePeriod! = TimePeriod()
}
