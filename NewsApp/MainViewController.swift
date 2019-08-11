//
//  MainViewController.swift
//  NewsApp
//
//  Created by 吉澤優衣 on 2019/08/11.
//  Copyright © 2019 吉澤優衣. All rights reserved.
//

import UIKit
import XLPagerTabStrip    // import 使えば、このファイル内では使えるようになる

class MainViewController: ButtonBarPagerTabStripViewController{
    
    // URLの文字列（yahoo,NHK, 週刊文春）
    let urlList: [String] = ["https://news.yahoo.co.jp/pickup/domestic/rss.xml",
                             "https://www.nhk.or.jp/rss/news/cat0.xml",
                             "http://shukan.bunshun.jp/list/feed/rss"]
    
    // タブの名前表示
    var iteminfo: [IndicatorInfo] = ["Yahoo!", "NHK", "週間文春"]
    
    // 各VCを返す処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // 各VCを返す処理
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        // 返すViewControllerの配列
        var childViewControllers: [UIViewController] = []
        
        // 各ViewControllerにurlとiteminfoの情報を受け渡し
        for i in 0 ..< urlList.count {
            
            // viewControllerのインスタンス化
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "News") as! NewsViewController
            
            // 値の受け渡し
            VC.url = urlList[i]
            VC.itemInfo = iteminfo[i]
            // 配列にappend
            childViewControllers.append(VC)
            
        }
        // VCを返す
        return childViewControllers
        
        
    }
    
    
}
