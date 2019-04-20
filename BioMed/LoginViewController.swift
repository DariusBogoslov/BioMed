//
//  ViewController.swift
//  BioMed
//
//  Created by Darius Bogoslov on 20/04/2019.
//  Copyright © 2019 Darius Bogoslov. All rights reserved.
//

import UIKit
import FirebaseUI
import LocalAuthentication


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                
                let context:LAContext = LAContext()
                
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
                {
                    
                       context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentification is needed to proceed", reply: { (wasCorrect, error) in
                        if wasCorrect
                        {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goHome", sender: nil)
                            }
                        }
                        else
                        {
                            self.present(FUIAuth.defaultAuthUI()!.authViewController(), animated: true, completion: nil)
                        }
                    })
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.black.cgColor]
        gradientLayer.frame = view.frame
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }

    @IBAction func loginButton(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        
        authUI?.delegate = self
        
        let authViewController = authUI!.authViewController()
        
        present(authViewController, animated: true, completion: nil)
    }
    
}


extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if error != nil {
            return
        }
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
}
