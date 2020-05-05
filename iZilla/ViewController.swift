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
    @IBOutlet weak var urlField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.keyboardDismissMode = .interactive
        let url = URL(string: "https://www.google.com")!
        webView.load(URLRequest(url: url))
        urlField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        urlField.frame = CGRect(x: 0, y: 0, width: 9000, height: 34)
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
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        urlField.text = webView.url?.absoluteString ?? ""
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let text = urlField.text,
            let url = URL(string: text) else { return false }
        webView.load(URLRequest(url: url))
        textField.endEditing(true)
        return true
    }
    
}
