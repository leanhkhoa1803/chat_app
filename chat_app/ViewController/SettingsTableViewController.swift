//
//  SettingsTableViewController.swift
//  chat_app
//
//  Created by KhoaLA8 on 13/5/24.
//

import UIKit
import ProgressHUD

class SettingsTableViewController: UITableViewController {

    //MARK: IBoutlet
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showUserInfo()
    }
    
    //MARK: TableView Delegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return section == 0 ? 0.0 : 10.0
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
        }
    }
    
    //MARK: IBActions
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        ProgressHUD.success("Tell a friends")
    }
    
    @IBAction func termsAndConditonsButtonPressed(_ sender: Any) {
        ProgressHUD.success("Terms and Conditions")
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        FirebaseUserListener.shared.logOutCurrentUser{ (error) in
            if error == nil{
                let loginView = UIStoryboard.init(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "loginView")
                DispatchQueue.main.async{
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true,completion: nil)
                }
            }
        }
    }
    
    //MARK: UpdateUI
    
    private func showUserInfo(){
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appVersionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")"
            if user.avatarLink != ""{
                FileStorage.downloadImage(imageUrl: user.avatarLink) {(avatarImage) in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
}
