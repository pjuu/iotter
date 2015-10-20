//
//  ViewController.swift
//  iotter
//
//  Created by Joe on 02/08/2015.
//  Copyright (c) 2015 Pjuu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!

    let hostName = "pjuu.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear the cache so we don't get stuck on the maintenance
        // page or anything else. Only when the view loads though.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        let url = NSURL(string: "https://\(hostName)")
        
        webView.delegate = self
        let request = NSURLRequest(URL: url!)
        
        // Set the User Agent
        let releaseVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as! String
        
        let buildVersion = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
        
        NSUserDefaults.standardUserDefaults().registerDefaults(
            ["UserAgent": "iOtter \(releaseVersion)-\(buildVersion)"])
        
        print("iOtter \(releaseVersion)-\(buildVersion)")
        
        webView.loadRequest(request)
    }

    func webView(WebViewNews: UIWebView, shouldStartLoadWithRequest request: NSURLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        
        let requestURL = request.URL!

        if requestURL.host == hostName {
            return true
        } else {
            UIApplication.sharedApplication().openURL(requestURL)
            return false
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}