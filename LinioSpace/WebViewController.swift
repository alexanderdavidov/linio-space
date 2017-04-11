//
//  WebViewController.swift
//  LinioSpace
//
//  Created by Александр Утробин on 10.04.17.
//  Copyright © 2017 Aleksandr Utrobin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: properies
    var url: URL!
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    // deinit для возвращения
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView() // устанавливаем webView
        webView.navigationDelegate = self // делегируем
        view = webView // устанивливаем webView на view
        let request = URLRequest(url: url) // делаем запрос
        webView.load(request) // загружаем запрос
        webView.allowsBackForwardNavigationGestures = true // применяем allowsBackForwardNavigationGestures
        progressView = UIProgressView(progressViewStyle: .default) // отображаем прогресс загрузки контента
        progressView.sizeToFit() // устанавливаем размер прогресса загрузки контента
        let progressButton = UIBarButtonItem(customView: progressView) // рисуем кнопку прогресса
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace , target: nil, action: nil) // рисуем кнопку прогресса
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)) // рефреш
        toolbarItems = [progressButton, spacer, refreshButton] // заполняем массив
        navigationController?.isToolbarHidden = false // isToolbarHidden на false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) // устанавливаем observer
    }
    
    // MARK: observeValue
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // MARK: webView
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
