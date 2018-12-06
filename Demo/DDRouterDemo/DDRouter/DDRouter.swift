
//
//  DDRouter.swift
//  DDRouterDemo
//
//  Created by USER on 2018/12/4.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit

public typealias  DDRouterParameter = [String: Any]

// MARK: -  DDRouter
public class DDRouter: NSObject {
    //单列
    public static let share = DDRouter()
 
    /// 路由入口 push
    ///
    /// - Parameters:
    ///   - key: 定义的key
    ///   - params: 需要传递的参数
    ///   - parent: 是否是present显示
    ///   - animated: 是否需要动画
    ///   - complete: 上级控制器回调传值，只能层级传递
    open func pushViewController(_ key: String, isXib: Bool = false, params: DDRouterParameter? = nil, animated: Bool = true, complete:((Any?)->())? = nil) {
        let cls = classFromeString(key: key)
        let vc = cls.init()
        vc.params = params
        vc.complete = complete
        vc.hidesBottomBarWhenPushed = true
        
        let topViewController = DDRouterUtils.currentTopViewController()
        if topViewController?.navigationController != nil {
            topViewController?.navigationController?.pushViewController(vc, animated: animated)
        } else {
            topViewController?.present(vc, animated: animated, completion: nil)
        }
    }
    
    /// 路由入口 present
    ///
    /// - Parameters:
    ///   - key: 路由key
    ///   - params: 参数
    ///   - animated: 是否需要动画
    ///   - complete:  上级控制器回调传值，只能层级传递
    open func presentViewController(_ key: String, params: DDRouterParameter? = nil, animated: Bool = true, complete:((Any?)->())? = nil) {
        //创建path对应的控制器
        let cls = classFromeString(key: key)
        let vc = cls.init()
        vc.params = params
        vc.complete = complete
        let topViewController = DDRouterUtils.currentTopViewController()
        topViewController?.present(vc, animated: animated, completion: nil)
    }
    
    /// 正常的pop操作
    ///
    /// - Parameters:
    ///   - vc: 当前控制器
    ///   - dismiss: true: dismiss退出，false: pop退出
    ///   - animated: 是否需要动画
    open func pop(_ vc: UIViewController, animated: Bool = true) {
        if vc.navigationController == nil {
            vc.dismiss(animated: animated, completion: nil)
            return
        }
        vc.navigationController?.popViewController(animated: animated)
    }
    
    /// pop到指定的控制器
    ///
    /// - Parameters:
    ///   - currentVC: 当前控制器
    ///   - toVC: 目标控制器对应的key
    ///   - animated: 是否需要动画
    open func pop(ToViewController currentVC: UIViewController, toVC: String, animated: Bool = true) {
        if currentVC.navigationController == nil {
            currentVC.dismiss(animated: animated, completion: nil)
            return
        }
        //创建path对应的控制器
        let cls = classFromeString(key: toVC)
        guard let viewControllers = currentVC.navigationController?.viewControllers else {
            return
        }
        
        for subVC in viewControllers {
            if subVC.isKind(of: cls) == true {
                currentVC.navigationController?.popToViewController(subVC, animated: animated)
            }
        }
    }
    
    /// pop到根目录
    ///
    /// - Parameters:
    ///   - currentVC: 当前控制器
    ///   - animated: 是否需要动画
    open func pop(ToRootViewController currentVC: UIViewController, animated: Bool = true) {
        if currentVC.navigationController == nil {
            currentVC.dismiss(animated: animated, completion: nil)
            return
        }
        currentVC.navigationController?.popToRootViewController(animated: animated)
    }
    
    /// dismiss操作
    ///
    /// - Parameters:
    ///   - vc: 当前控制器
    ///   - animated: 是否需要动画
    open func dismiss(_ vc: UIViewController, animated: Bool = true) {
        if vc.navigationController == nil {
            vc.dismiss(animated: animated, completion: nil)
            return
        }
        vc.dismiss(animated: animated, completion: nil)
    }
    
    /// 通过key获取对象class
    ///
    /// - Parameter key: key
    /// - Returns: class
    open func classFromeString(key: String) -> UIViewController.Type {
        if key.contains(".") == true {
            let clsName = key
            let cls = NSClassFromString(clsName) as! UIViewController.Type
            return cls
        }
        
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let clsName = namespace + "." + key
        let cls = NSClassFromString(clsName) as! UIViewController.Type
        return cls
    }
}

// MARK: -  DDRouterUtils --- 获取最上层的viewController
public class DDRouterUtils {
    //获取当前页面
    public class func currentTopViewController() -> UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController{
            return currentTopViewController(rootViewController: rootViewController)
        }else{
            return nil
        }
    }
    
    public class func currentTopViewController(rootViewController: UIViewController) -> UIViewController {
        if (rootViewController.isKind(of: UITabBarController.self)) {
            let tabBarController = rootViewController as! UITabBarController
            return currentTopViewController(rootViewController: tabBarController.selectedViewController!)
        }
        if (rootViewController.isKind(of: UINavigationController.self)) {
            let navigationController = rootViewController as! UINavigationController
            return currentTopViewController(rootViewController: navigationController.visibleViewController!)
        }
        if ((rootViewController.presentedViewController) != nil) {
            return currentTopViewController(rootViewController: rootViewController.presentedViewController!)
        }
        return rootViewController
    }
}
