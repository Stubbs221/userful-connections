//
//  Person.swift
//  UsefulConnections + MVP + Realm
//
//  Created by Vasily on 12.05.2022.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var email: String = ""
    @objc dynamic var account: String = ""
    @objc dynamic var rating: String = ""
    @objc dynamic var personID: Int = 0
    
    convenience init(email: String, account: String, rating: String, personID: Int) {
        self.init()
        self.email = email
        self.account = account
        self.rating = rating
        self.personID = personID
    }
    
//    override static func primaryKey() -> String? {
//        return "personID"
//    }
}
