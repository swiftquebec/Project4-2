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
    var progressView: UIProgressView!
    // List of safe websites
    var websites = ["apple.com", "hackingwithswift.com"]
    
    
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
        
        // Create toolbar with flexible space and refresh button
        // And progress bar (with KVO)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "Forward", style: .plain, target: nil, action: #selector(webView.goForward))
        // Assign the above to the array toolbarItems (property of UIViewController)
        // Progress bar
        // We wrap the progress bar in UIBarButtonItem so we can include it
        // in our toolbar
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        // Toolbar
        toolbarItems = [progressButton, spacer, goBack, spacer, goForward, spacer, refresh]
        navigationController?.isToolbarHidden = false

        // Add KVO observer:
        // Parameters: Who is observer; ourselves thus self
        // Once you are registered as an observer, you must implement
        // a method called observeValue() (See below)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Load first site
        // In this project must use https
        let url = URL(string: "https://" + websites[0])!
        // String converted to URL and then a URLRequest
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
    }

    @objc func openTapped() {
        //Create pop-screen
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        // Add one action for every "safe" site
        for website in websites {
                    ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // Delegate method that allows us to control navigation
    // I.e., should we allow the page to load or not (e.g., if
    // the page leads to a site not on our safe site list.)
    // DecisionHandler is an escapint closure -- has the potential
    // to escape the method and be used at a later date
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // code to evaluate if URL is on safelist and then call
        // decisionhandler with a positive or negative answer.
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        // Add alert to indicate site was bloacked
        let ac = UIAlertController(title: "Access Denied!", message: "This site is not on your safe list", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
        
        // If the above test fails:
        decisionHandler(.cancel)
        
        
    }
}

