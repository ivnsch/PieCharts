//
//  MasterViewController.swift
//  PieCharts
//
//  Created by Ivan Schuetz on 30/12/2016.
//  Copyright © 2016 Ivan Schuetz. All rights reserved.
//

import UIKit

enum Demo {
    case doughnut, customViews, programmatical, doughnutEdgeCase, customViewsEdgeCase
}


class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    var demos: [(Demo, String)] = [
        (.doughnut, "Doughnut"),
        (.customViews, "Custom views"),
        (.programmatical, "Programmatical"),
        (.doughnutEdgeCase, "Doughnut edge case"),
        (.customViewsEdgeCase, "Custom views edge case"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        func startDemo(index: Int) {
            let demo = demos[index]
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = demo.0
            controller.title = demo.1
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                startDemo(index: indexPath.row)
            } else {
                startDemo(index: 0)
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let demo = demos[indexPath.row]
        cell.textLabel!.text = demo.1
        return cell
    }
}
