//
//  ViewController.swift
//  DDRouterDemo
//
//  Created by USER on 2018/12/4.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import DDKit
import TestSDK
struct Model {
    var name: String = "liming"
    var old: Int = 18
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

    }

    @IBAction func pushBAction(_ sender: Any) {
        let model = Model()
        pushViewController(kRouterControllerB, params: ["model": model,"title": "hello"], animated: true) { (res) in
            //上级界面回调
            print(res)
        }
    }
    
    @IBAction func presentBAction(_ sender: Any) {
        presentViewController(kRouterControllerB, params: nil, animated: true) { (res) in
            print(res)
        }
    }
    
    // MARK: ---  模块之间通信，后续会出方法
    //本路由只适合用项目间控制器中的跳转和传值
    @IBAction func pushTestSDKAction(_ sender: Any) {
//        let bundle1 = Bundle.init(for: TestViewController.self)
       pushViewController(kRouterTestViewController, params: nil, animated: true, complete: nil)
    }

    @IBAction func pushPosAction(_ sender: Any) {
        pushViewController(kRouterDDScanViewController, params: nil, animated: true, complete: nil)

    }
}

