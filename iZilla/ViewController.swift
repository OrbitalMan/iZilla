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
    
    let webView = WKWebView()
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        webView.allowsBackForwardNavigationGestures = true
        let url = URL(string: "https://www.google.com")!
        webView.load(URLRequest(url: url))
    }
    
}

extension ViewController: WKNavigationDelegate {
    
}
