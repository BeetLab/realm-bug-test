//
//  RealmNotificationsWorker.swift
//  RealnBugTests
//
//  Created by Krasa on 27/11/2018.
//  Copyright © 2018 Ronte. All rights reserved.
//

import Foundation
import RealmSwift

class RealmNotificationsWorker: BackgroundWorker {
    private var observationToken: NotificationToken?
    
    override init() {
        super.init()
        start { [weak self] in
            let realm = try! Realm()
            self?.observationToken = realm.objects(DBMessage.self).observe { (changes) in
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
    }
    
    deinit {
        observationToken?.invalidate()
    }
}
