//
//  SplashViewController.swift
//  JustBooks
//
//  Created by Mihir Chauhan on 12/01/22.
//

import UIKit

class SplashViewController: UIViewController{
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var imgAppLogo: UIStackView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupView() {
        self.splashIconAnimation()
    }
    
    // App icon animation
    func splashIconAnimation(){
        UIView.animate(withDuration: 0.2, animations: {
            self.imgAppLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: { (finish: Bool) in
            UIView.animate(withDuration: 0.2, animations: {
                self.imgAppLogo.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                
            }, completion:{(finish: Bool) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.imgAppLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
                }, completion: { (finish: Bool) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.imgAppLogo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        
                    }, completion:{(finish: Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.imgAppLogo.transform = CGAffineTransform.identity
                        })
                    })
                })
            })
        })
        
        //After 2 second screen will move on Dashboard screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            AppDelegate.shared.window?.rootViewController = tabController
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
}
