//
//  ViewController.swift
//  RealnBugTests
//
//  Created by Krasa on 23/11/2018.
//  Copyright © 2018 Ronte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let realmWrapper = RealmWrapper()
    private var timerThread: TimerThread!
    private var tickCounter = 0
    private var timer: Timer!
    private let queue = DispatchQueue(label: "com.ronte.platoon2.messageDatabaseInteractor", qos: .userInitiated)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        timer = Timer(timeInterval: 1,
                      target: self,
                      selector: #selector(tick),
                      userInfo: nil,
                      repeats: true)
        realmWrapper.addObserver()
        timerThread = TimerThread(timer: timer)
        timerThread.start()
    }
    
    @objc func tick() {
        tickCounter += 1
        print("tick no \(tickCounter)")
        let dbMessage = DBMessage()
        dbMessage.id = tickCounter
        dbMessage.snippet = "snippet no \(tickCounter)"

        queue.async {
            self.realmWrapper.write(message: dbMessage)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        (cell.viewWithTag(1488) as! UILabel).text = "cell number \(indexPath.row)"
        return cell
    }
}

