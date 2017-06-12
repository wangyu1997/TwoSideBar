//  ViewController.swift
//  Weather
//
//  Created by wangyu on 11/06/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /**
     *将建好的三个viewcontroller贴在一起
     **/
    
    var mainVC:UIViewController?
    var leftVC:UIViewController?
    var rightVC:UIViewController?
    
    var screenWidth:CGFloat?
    var maxWith:CGFloat?
    var spaceWidth:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spaceWidth = 60.0
        screenWidth = UIScreen.main.bounds.size.width
        maxWith = screenWidth!-spaceWidth!
        
        self.leftVC = LeftTableViewController()
        
        let rootVC = MainViewController()
        self.mainVC = UINavigationController(rootViewController: rootVC)
        
        self.rightVC = RightTableViewController()
        
        mainVC?.view.backgroundColor = .orange
        
        self.view.addSubview((leftVC?.view)!)
        self.view.addSubview((rightVC?.view)!)
        self.view.addSubview((mainVC?.view)!)
        
        leftVC?.view.transform = CGAffineTransform(translationX: -maxWith!, y: 0)
        
        rightVC?.view.transform = CGAffineTransform(translationX: maxWith!, y: 0)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        self.mainVC?.view.addGestureRecognizer(pan)
    }
    
    func panAction(_ pan:UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        
        if offsetX>0{
            if pan.state == .changed && offsetX <= maxWith! {
                mainVC?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
                leftVC?.view.transform = CGAffineTransform(translationX: -self.maxWith!+offsetX, y: 0)
            }else if pan.state == .failed || pan.state == .ended || pan.state == .cancelled{
                if offsetX>=maxWith!/3 {
                    openLeftSide()
                }else{
                    closeLeftSide()
                }
            }
        }else{
            if pan.state == .changed && offsetX <= maxWith! {
                mainVC?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
                rightVC?.view.transform = CGAffineTransform(translationX:self.maxWith!+offsetX, y: 0)
            }else if pan.state == .failed || pan.state == .ended || pan.state == .cancelled{
                if -offsetX>=maxWith!/3 {
                    openRightSide()
                }else{
                   closeRightSide()
                }
            }

        }
    }
    
    
    func openLeftSide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.mainVC?.view.transform = CGAffineTransform(translationX: self.maxWith!, y: 0)
            self.leftVC?.view.transform = CGAffineTransform.identity
        }){
            (finish: Bool) in
            self.mainVC?.view.addSubview(self.coverBtn)
        }
    }
    
    func closeLeftSide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.leftVC?.view.transform = CGAffineTransform(translationX: -self.maxWith!, y: 0)
            self.mainVC?.view.transform = CGAffineTransform.identity
        }){
            (finish: Bool) in
            self.coverBtn.removeFromSuperview()
        }
    }
    
    func openRightSide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.mainVC?.view.transform = CGAffineTransform(translationX: -self.maxWith!, y: 0)
            self.rightVC?.view.transform = CGAffineTransform.identity
        }){
            (finish: Bool) in
            self.mainVC?.view.addSubview(self.coverBtn)
        }
    }
    
    func closeRightSide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.rightVC?.view.transform = CGAffineTransform(translationX: self.maxWith!, y: 0)
            self.mainVC?.view.transform = CGAffineTransform.identity
        }){
            (finish: Bool) in
            self.coverBtn.removeFromSuperview()
        }
    }
    
    func showMainView() {
        UIView.animate(withDuration: 0.25){
            self.mainVC?.view.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y:UIScreen.main.bounds.size.height/2 )
        }
    }
    
    func showLeftView(){
        UIView.animate(withDuration: 0.25){
            self.mainVC?.view.center = CGPoint(x: UIScreen.main.bounds.size.width * 1.5-60, y:UIScreen.main.bounds.size.height/2 )
        }
    }
    
    func showRightView(){
        UIView.animate(withDuration: 0.25){
            self.mainVC?.view.center = CGPoint(x:60-UIScreen.main.bounds.size.width/2, y:UIScreen.main.bounds.size.height/2 )
        }
    }
    
    func closeSide() {
        if (mainVC?.view.frame.origin.x)! > CGFloat(0){
            closeLeftSide()
        }else if (mainVC?.view.frame.origin.x)! < CGFloat(0){
            closeRightSide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func panBtnAction(_ pan:UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x

        if (mainVC?.view.frame.origin.x)! > CGFloat(0){
            if offsetX>0 {
                return
            }
            if pan.state == .changed && -offsetX <= maxWith! {
                mainVC?.view.transform = CGAffineTransform(translationX: self.maxWith!+offsetX, y: 0)
                leftVC?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
            }else if pan.state == .failed || pan.state == .ended || pan.state == .cancelled{
                if -offsetX>=maxWith!/3 {
                    closeLeftSide()
                }else{
                    openLeftSide()
                }
            }
        }else if (mainVC?.view.frame.origin.x)! < CGFloat(0){
            if offsetX<0 {
                return
            }
            if pan.state == .changed && offsetX <= maxWith! {
                mainVC?.view.transform = CGAffineTransform(translationX: -self.maxWith!+offsetX, y: 0)
                rightVC?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
            }else if pan.state == .failed || pan.state == .ended || pan.state == .cancelled{
                if offsetX>=maxWith!/3 {
                    closeRightSide()
                }else{
                    openRightSide()
                }
            }
        }
    }
    

    
    private lazy var coverBtn: UIButton = {
        let button = UIButton(frame: CGRect(origin: CGPoint(x:0,y:0), size: UIScreen.main.bounds.size))
        button.backgroundColor = .black
        button.alpha = 0.2
        button.addTarget(self, action: #selector(closeSide), for: .touchUpInside)
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panBtnAction(_:))))
        return button
    }()

}

