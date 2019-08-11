//
//  NewsViewController.swift
//  NewsApp
//
//  Created by 吉澤優衣 on 2019/08/11.
//  Copyright © 2019 吉澤優衣. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewsViewController: UIViewController, IndicatorInfoProvider {

    
    // urlを受け取る
    var url: String = ""
    
    // itemInfo を受け取る
    var itemInfo: IndicatorInfo = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
