//
//  ViewController.swift
//  iZilla
//
//  Created by Stanislav on 05.05.2020.
//  Copyright © 2020 OrbitalMan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        let url = URL(string: "https://www.google.com")!
        webView.load(URLRequest(url: url))
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
        let tabsViewController = UITableViewController()
        navigationController?.pushViewController(tabsViewController, animated: true)
    }
    
}

extension ViewController: WKNavigationDelegate {
    
}
