//
//  ViewController.swift
//  chat_app
//
//  Created by KhoaLA8 on 16/4/24.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var reSendEmailButton: UIButton!
    
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    var isLogin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI(login: true)
        setupTextField()
        setupBackgroundTap()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputed(type: isLogin ? "login" : "register"){
            isLogin ? loginUser() : registerUser()
        }else{
            ProgressHUD.failed("All Fields are required")
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        if isDataInputed(type: "password"){
            resetPassword()
        }else{
            ProgressHUD.failed("Email is required")
        }
    }
    
    @IBAction func reSendEmailButtonPressed(_ sender: Any) {
        if isDataInputed(type: "password"){
            resendVerificationEmail()
        }else{
            ProgressHUD.failed("Email is required")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUI(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    func loginUser(){
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) {error,isEmailVerified in
            if error == nil {
                if isEmailVerified {
                    self.gotoAapp()
                    print("login success",User.currentUser?.email)
                }else{
                    ProgressHUD.failed("Please verify email.")
                    self.reSendEmailButton.isHidden = false
                }
            }else{
                ProgressHUD.failed(error?.localizedDescription)
            }
        }
    }
    
    private func gotoAapp(){
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true,completion: nil)
    }
    
    func registerUser(){
        if passwordTextField.text! == repeatPasswordTextField.text! {
            
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                
                if error == nil {
                    ProgressHUD.succeed("Verification email sent.")
                    self.reSendEmailButton.isHidden = false
                } else {
                    ProgressHUD.failed(error!.localizedDescription)
                }
            }
            
        } else {
            ProgressHUD.failed("The Passwords don't match")
        }
    }
    
    private func resetPassword(){
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) {
            (error) in
            if error == nil {
                ProgressHUD.success("Reset link sent to email.")
            }else{
                ProgressHUD.error(error?.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail(){
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) {
            (error) in
            if error == nil {
                ProgressHUD.success("New verification email sent.")
            }else{
                ProgressHUD.error(error?.localizedDescription)
            }
        }
    }
    
    private func setupTextField(){
        emailTextField.addTarget(self, action: #selector(textFielDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFielDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFielDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFielDidChange(_ textField: UITextField){
        updatePlaceholderTextField(textField : textField)
    }
    
    private func updatePlaceholderTextField(textField : UITextField){
        switch textField{
        case emailTextField :
            emailLabel.text = textField.hasText ? "Email" : ""
        case passwordTextField :
            passwordLabel.text = textField.hasText ? "Password" : ""
        default:
            repeatPasswordLabel.text = textField.hasText ? "Repeat Password" : ""
        }
    }
    
    private func updateUI(login: Bool){
        loginButton.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        signUpButton.setTitle(login ? "SignUp" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an account?" : "Have an account?"
        
        UIView.animate(withDuration: 0.5, animations: {
            self.repeatPasswordLabel.isHidden = login
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        })
    }
    
    private func setupBackgroundTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroudTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroudTap(){
        view.endEditing(false)
    }
    
    
    private func isDataInputed(type: String)-> Bool{
        switch type{
        case"login" :
            return emailTextField.text != "" && passwordTextField.text != ""
        case"registration" :
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
        
    }
}

