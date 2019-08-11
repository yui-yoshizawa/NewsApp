//
//  NewsViewController.swift
//  NewsApp
//
//  Created by 吉澤優衣 on 2019/08/11.
//  Copyright © 2019 吉澤優衣. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class NewsViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, XMLParserDelegate {    // どのプロトコルが何なのか
    
    var refreshControl: UIRefreshControl!
    
    
    // テーブルビューのインスタンス取得
    var tableView: UITableView = UITableView()
    
    
    // XMLParser のインスタンスを取得
    var parser = XMLParser()    // デリゲート追加 →（だいたい）インスタンス化
    
    
    // 記事情報の入れ物
    // var articles = NSMutableArray
    var articles: [Any] = []
    
    
    // XMLファイルに解析をかけた情報
    var elements = NSMutableDictionary()
    // XMLファイルのタグ情報
    var element: String = ""
    // XMLファイルのタイトル情報
    var titleString: String = ""
    // XMLファイルのリンク情報
    var linkString: String = ""
    
    
    @IBOutlet weak var webview: WKWebView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    // urlを受け取る
    var url: String = ""
    
    // itemInfo を受け取る
    var itemInfo: IndicatorInfo = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refreshControl のインスタンス
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
        // デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // navigationDelegate との接続
        webview.navigationDelegate = self
        
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        // tableViewをviewに追加
        self.view.addSubview(tableView)
        
        // refreshControl をテーブルビューにつける
        tableView.addSubview(refreshControl)
        
        // 最初は隠す(tablrView が表示されるのを邪魔しないように)
        webview.isHidden = true
        toolbar.isHidden = true
        
        parseUrl()
    }
    
    @objc func refresh() {
        // 2秒後にdelayを呼ぶ
        perform(#selector(delay), with: nil, afterDelay: 2.0)
    }
    
    @objc func delay() {
        parseUrl()
        refreshControl.endRefreshing()
    }
    
    
    func parseUrl() {
        // url型に変換
        let urlToSend: URL = URL(string: url)!    // URLをURL型に変更
        
        // parser に解析対象のurlを取得。
        parser = XMLParser(contentsOf: urlToSend)!
        // 記事情報を初期化
        articles = []
        // paraser
        parser.delegate = self
        //解析の実行
        parser.parse()
        // tableViewのリロード
        tableView.reloadData()
    }
    
    // 解析中に要素の開始タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // elementName にタグの名前が入ってくるので element に代入
        element = elementName
        // エレメントにタイトルが入ってきたら
        if element == "item" {
            // タグの名前がitemだったら
            // 初期化
            elements = [:]
            titleString = ""
            linkString = ""
        }
        
    }
    // 終了タグを見つけた時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // アイテムという要素の中にあるなら、
        if elementName == "item" {
            // titleString, linkString 空でなければ
            if titleString != "" {
                // elementsに"title", "link"というキー値を付与しながらtitleString, linkStringをセット
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            
            if linkString != "" {
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            // articlesの中にelementsを入れる
            articles.append(elements)
            
        }
        
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if element == "title" {
            titleString.append(string)
        } else if element == "link" {
            linkString.append(string)
        }
    }
    
    
    
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 記事の数だけセルを返す
        return articles.count
    }
    
    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        // セルの色
        cell.backgroundColor = #colorLiteral(red: 0.9871167156, green: 0.8818572024, blue: 1, alpha: 1)
        
        // 記事テキストサイズとフォントの設定
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.textColor = UIColor.black
        
        // 記事urlのサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.text = (articles[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.textColor = UIColor.gray
        
        
        return cell
    }
    
    
    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {    // didSelectRowAt
        // URLを贈りやすい形にしているっぽい
        let linkUrl = ((articles[indexPath.row] as AnyObject).value(forKey: "link")as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let urlStr = (linkUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        
        guard let url = URL(string: urlStr) else {
            return
        }
        let urlRequest = NSURLRequest(url: url)
        webview.load(urlRequest as URLRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // tableViewを隠す
        tableView.isHidden = true
        // toolbarを表示する
        toolbar.isHidden = false
        // webviewを表示する
        webview.isHidden = false
    }
    
    // キャンセル
    @IBAction func cancel(_ sender: Any) {
        tableView.isHidden = false    // 逆のことをしてあげれば良い！
        toolbar.isHidden = true
        webview.isHidden = true
    }
    
    // 戻る
    @IBAction func backPage(_ sender: Any) {
        webview.goBack()    // .goBack は webview が持ってるメソッド
    }
    
    // 次へ
    @IBAction func nextPage(_ sender: Any) {
        webview.goForward()    // webview が持ってるメソッド
    }
    
    // リロード
    @IBAction func refreshPage(_ sender: Any) {
        webview.reload()    // webview が持ってるメソッド
    }
    //
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
