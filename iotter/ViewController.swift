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

    // Close button to display when viewing image
    let button = UIButton(type: UIButtonType.System) as UIButton
    let image = UIImage(named: "close") as UIImage?

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        // Reload the web view so the page is the correct way round
        webView.reload()
        button.frame = CGRectMake(size.width - 32, size.height - 32, 52, 52)
    }
    
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
        
        webView.scalesPageToFit = true
        
        // Set button options.
        // These woud be better somewhere else but I don't know where
        button.setTitle("Back", forState: UIControlState.Normal)
        button.frame = CGRectMake(self.view.frame.width - 52, self.view.frame.height - 52, 44, 44)
        button.setImage(self.image, forState: .Normal)
        button.addTarget(self, action: #selector(ViewController.btnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        button.hidden = true
        button.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        button.titleLabel?.layer.opacity = 0

        self.view.addSubview(button)
        
        if requestURL.host == hostName {
            if requestURL.path!.rangeOfString(".png") != nil {
                button.hidden = false
            }
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

    func btnPressed(sender: UIButton!) {
        if(webView.canGoBack) {
            // Go back in webview history
            webView.goBack()
        } else {
            // Pop view controller to preview view controller
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}