//
//  TopStoriesWebViewController.swift
//  BreakingSnooze
//
//  Created by Kadell on 1/11/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import WebKit

class TopStoriesWebViewController: UIViewController, WKUIDelegate {

    var article: NewsArticles!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = article.source
        
        setupWebView()
        let myURL = URL(string: article.url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }

    private func setupWebView() {
        self.edgesForExtendedLayout = []
        let webConfiguration = WKWebViewConfiguration()

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        if let containerView = view.viewWithTag(1) {
            containerView.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        }

    }
}
