//
//  TabsViewController.swift
//  iZilla
//
//  Created by Stanislav on 05.05.2020.
//  Copyright © 2020 OrbitalMan. All rights reserved.
//

import UIKit
import WebKit

class TabsViewController: UITableViewController {
    
    let cellId = "cellId"
    var tabs: [WebTab] = []
    weak var webViewController: WebViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTab))
        webViewController?.updateCurrentTab()
        tabs = Storage.webTabs
    }
    
    @objc func addTab() {
        webViewController?.reset()
        navigationController?.popViewController(animated: true)
        tabs.append(WebTab(title: "Empty", urlStack: []))
        Storage.webTabs = tabs
        Storage.currentTabIndex = tabs.count - 1
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = tabs[indexPath.row].title
        if Storage.currentTabIndex == indexPath.row {
            cell.textLabel?.textColor = UIColor.label
        } else {
            cell.textLabel?.textColor = UIColor.secondaryLabel
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            tabs.indices.contains(indexPath.row),
            let webViewController = webViewController else { return }
        if Storage.currentTabIndex != indexPath.row {
            webViewController.reset()
            if let url = tabs[indexPath.row].urlStack.last {
                webViewController.webView.load(URLRequest(url: url))
            }
            Storage.currentTabIndex = indexPath.row
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        if tabs.count < 2, tabs.last?.urlStack.isEmpty ?? true {
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard tabs.count > 1 else
            {
                tabs = [WebTab(title: "Empty", urlStack: [])]
                Storage.webTabs = tabs
                Storage.currentTabIndex = 0
                tableView.reloadData()
                webViewController?.reset()
                return
            }
            tabs.remove(at: indexPath.row)
            let previousTabIndex = Storage.currentTabIndex
            var newCurrentIndex = previousTabIndex
            if previousTabIndex > indexPath.row {
                newCurrentIndex = previousTabIndex-1
            }
            newCurrentIndex = min(max(0, newCurrentIndex), tabs.count-1)
            if newCurrentIndex != previousTabIndex {
                Storage.currentTabIndex = newCurrentIndex
            }
            let newCurrentTab = tabs[newCurrentIndex]
            let newURL = newCurrentTab.urlStack.last
            if newURL != webViewController?.webView.url {
                webViewController?.reset()
                if let url = newURL {
                    webViewController?.webView.load(URLRequest(url: url))
                }
            }
            Storage.webTabs = tabs
            tableView.reloadData()
        }
    }
    
}
