//
//  RecentChat.swift
//  chat_app
//
//  Created by KhoaLA8 on 16/5/24.
//

import Foundation
import FirebaseFirestoreSwift


struct RecentChat: Codable {
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
}
