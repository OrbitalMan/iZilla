//
//  WebViewController.swift
//  iZilla
//
//  Created by Stanislav on 05.05.2020.
//  Copyright © 2020 OrbitalMan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!
    var webView = WKWebView()
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.delegate = self
        reset()
        loadCurrentTab()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        urlField.frame = CGRect(x: 0, y: 0, width: 9000, height: 34)
    }
    
    func reset() {
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = false
        webView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = false
        webView.removeFromSuperview()
        
        webView = WKWebView()
        view.insertSubview(webView, at: 0)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.keyboardDismissMode = .interactive
        
        urlField.text = ""
    }
    
    @IBAction func back() {
        webView.goBack()
    }
    
    @IBAction func forward() {
        webView.goForward()
    }
    
    @IBAction func refresh() {
        webView.reload()
    }
    
    @IBAction func openTabs() {
        let tabsViewController = TabsViewController()
        tabsViewController.webViewController = self
        navigationController?.pushViewController(tabsViewController, animated: true)
    }
    
    func loadCurrentTab() {
        let currentTabIndex = Storage.currentTabIndex
        let tabs = Storage.webTabs
        if tabs.isEmpty {
            let url = URL(string: "https://www.google.com")!
            webView.load(URLRequest(url: url))
        } else {
            let tab: WebTab
            if tabs.indices.contains(currentTabIndex) {
                tab = tabs[currentTabIndex]
            } else {
                let lastIndex = tabs.count-1
                tab = tabs[lastIndex]
                Storage.currentTabIndex = lastIndex
            }
            if let url = tab.urlStack.last {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    func updateCurrentTab() {
        var title = webView.title ?? ""
        if title.isEmpty {
            title = webView.url?.host ?? "Empty"
        }
        var urlStack: [URL] = []
        if let url = webView.url {
            urlStack.append(url)
        }
        let newCurrentTab = WebTab(title: title, urlStack: urlStack)
        var tabs = Storage.webTabs
        if tabs.isEmpty {
            tabs.append(newCurrentTab)
            Storage.webTabs = tabs
        } else {
            let index = Storage.currentTabIndex
            tabs.remove(at: index)
            tabs.insert(newCurrentTab, at: index)
            Storage.webTabs = tabs
        }
        
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        urlField.text = webView.url?.absoluteString ?? ""
        updateCurrentTab()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateCurrentTab()
    }
    
}

extension WebViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var link = urlField.text ?? ""
        if !link.starts(with: "http") {
            link = "http://" + link
        }
        guard let url = URL(string: link) else { return false }
        webView.load(URLRequest(url: url))
        textField.endEditing(true)
        return true
    }
    
}
