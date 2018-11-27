//
//  RealmWrapper.swift
//  RealnBugTests
//
//  Created by Krasa on 23/11/2018.
//  Copyright © 2018 Ronte. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWrapper {
    private var observationToken: NotificationToken?
    private var realm : Realm? {
        do {
            return try Realm()
        } catch {
            print("realm init error - \(error.localizedDescription)")
            return nil
        }
    }
    
    func write(message: DBMessage) {
        guard let realm = realm else {
            return
        }
        
        do {
            try realm.write {
                realm.add(message)
            }
        } catch {
            print("realm write error - \(error.localizedDescription)")
        }
    }
    
    func addObserver() {
        guard let realm = realm else {
            return
        }
        observationToken = realm.objects(DBMessage.self).observe { (changes) in
            switch changes {
            case .initial(let messages):
                print("fetched - \(Array(messages))")
            case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                let updates = Array(results)
                print("updates started - \(Thread.isMainThread)")
                insertions.forEach({
                    print("updates - \(updates[$0])")
                })
                print("updates finished")
            case .error(let error):
                print("observation error - \(error.localizedDescription)")
            }
        }
    }
    
    func messages() -> [DBMessage] {
        guard let realm = realm else {
            return [DBMessage]()
        }
        
        return Array(realm.objects(DBMessage.self))
    }
}
