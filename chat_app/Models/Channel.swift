//
//  Channel.swift
//  chat_app
//
//  Created by KhoaLA8 on 23/5/24.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Channel: Codable {
    
    var id = ""
    var name = ""
    var adminId = ""
    var memberIds = [""]
    var avatarLink = ""
    var aboutChannel = ""
    @ServerTimestamp var createdDate = Date()
    @ServerTimestamp var lastMessageDate = Date()

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case adminId
        case memberIds
        case avatarLink
        case aboutChannel
        case createdDate
        case lastMessageDate = "date"
    }
}
