//
//  ViewController.swift
//  Project4
//
//  Created by Gregory Leck on 2019-04-19.
//  Copyright © 2019 Gregory Leck. All rights reserved.
//

import UIKit
import WebKit

// ViewController extends from UIViewController but
// conforms to the WKNavigationDelegate protocol
class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    // loadView() gets called before viewDidLoad()
    override func loadView() {
        webView = WKWebView()
        // Set to "self"... When any webpage navigation happens please
        // tell *me*, i.e., the current ViewController.
        // When using a delegate (which contains certain methods),
        // you must conform to the delegate's protocol.
        // (In this case, WKNavigationDelegate.)
        webView.navigationDelegate = self
        // Make it the view for out ViewController
        // (Since it uses the entire screen, no custom edits
        // were made to storyboard.)
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup rightBarButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // In this project must use https
        let url = URL(string: "https://www.hackingwithswift.com")!
        // String converted to URL and then a URLRequest
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        //Create pop-screen
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // for ipads...
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        // Without "guard let" would be simply:
        // let url = URL(string: "https://" + action.title!)!
        // webView.load(URLRequest(url: url))
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    // Built-in methods provided by protocols
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // set title of page
        title = webView.title
    }
}

