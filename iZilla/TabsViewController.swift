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
        tabs = Storage.webTabs
        
        if let webViewController = webViewController {
            let title = webViewController.webView.title ?? webViewController.webView.url?.host ?? "Empty"
            var urlStack: [URL] = []
            if let url = webViewController.webView.url {
                urlStack.append(url)
            }
            let newTab = WebTab(title: title,
                                urlStack: urlStack)
            if tabs.isEmpty {
                tabs.append(newTab)
                Storage.webTabs = tabs
            } else {
                let currentTabIndex = Storage.currentTabIndex
                let currentTab = tabs[currentTabIndex]
                let webView = webViewController.webView
                if  let url = webView.url,
                    url != currentTab.urlStack.last,
                    webView.title != currentTab.title
                {
                    tabs.remove(at: currentTabIndex)
                    tabs.insert(newTab, at: currentTabIndex)
                    Storage.webTabs = tabs
                }
            }
        }
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
        return tabs.count > 1
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard
                tabs.indices.contains(indexPath.row),
                tabs.count > 1 else { return }
            tabs.remove(at: indexPath.row)
            let previousTabIndex = Storage.currentTabIndex
            var newCurrentIndex = previousTabIndex
            if previousTabIndex > indexPath.row {
                newCurrentIndex = previousTabIndex-1
            }
            newCurrentIndex = min(max(0, newCurrentIndex), tabs.count-1)
            if newCurrentIndex != previousTabIndex {
                Storage.currentTabIndex = newCurrentIndex
                let newCurrentTab = tabs[newCurrentIndex]
                let newURL = newCurrentTab.urlStack.last
                if newURL != webViewController?.webView.url {
                    webViewController?.reset()
                    if let url = newURL {
                        webViewController?.webView.load(URLRequest(url: url))
                    }
                }
            }
            Storage.webTabs = tabs
            tableView.reloadData()
        }
    }
    
}
