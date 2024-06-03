//
//  RealmManager.swift
//  chat_app
//
//  Created by KhoaLA8 on 17/5/24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init() {}
    
    func saveToRealm<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        }catch{
            print("error saving Realm",error)
        }
    }
}
