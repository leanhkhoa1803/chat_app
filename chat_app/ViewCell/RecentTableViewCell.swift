//
//  RecentChatTableViewCell.swift
//  chat_app
//
//  Created by KhoaLA8 on 16/5/24.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastmesageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadCounterView: UIView!
    @IBOutlet weak var unreadCounterLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unreadCounterView.layer.cornerRadius = unreadCounterView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(recentChat : RecentChat){
        usernameLabel.text = recentChat.receiverName
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.9
        
        lastmesageLabel.text = recentChat.lastMessage
        lastmesageLabel.adjustsFontSizeToFitWidth = true
        lastmesageLabel.minimumScaleFactor = 0.9
        lastmesageLabel.numberOfLines = 2
        
        if recentChat.unreadCounter != 0 {
            self.unreadCounterLabel.text = "\(recentChat.unreadCounter)"
            self.unreadCounterView.isHidden = false
        }else{
            self.unreadCounterView.isHidden = true
        }
        
        setAvatar(avatarLink: recentChat.avatarLink)
        dateLabel.text = timeElapsed(recentChat.date ?? Date())
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setAvatar(avatarLink: String){
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) {(avatarImage) in
                self.avatarImageView.image = avatarImage?.circleMasked
            }
        }else{
            self.avatarImageView.image = UIImage(named: "avatar")?.circleMasked
        }
    }
}
