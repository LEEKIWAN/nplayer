//
//  WebViewController.swift
//  VideoPlayer
//
//  Created by kiwan on 2019/11/19.
//  Copyright © 2019 kiwan. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var url: URL?
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.layer.cornerRadius = topView.frame.size.height / 2
        
        guard let url = url else {
            return
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //
        
        webView.load(URLRequest(url: url))
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let title = webView.title else { return }
        self.title = title
        
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "title")
    }
    
    
    //MARK: - Webview
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.stopAnimating()
    }
}

