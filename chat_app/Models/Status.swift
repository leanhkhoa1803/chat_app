//
//  Status.swift
//  chat_app
//
//  Created by KhoaLA8 on 14/5/24.
//

import Foundation

enum Status: String {
    case Available = "Available"
    case Busy = "Busy"
    case AtSchool = "At School"
    case AtTheMovies = "At The Movies"
    case AtWork = "At Work"
    case BatteryAboutToDie = "Battery About To Die"
    case CanTalk = "Can Talk"
    case InAMeeting = "In A Meeting"
    case AtTheGym = "At The Gym"
    case Sleeping = "Sleeping"
    case UrgentCallOnly = "Urgent Call Only"
    
    static var array : [Status] {
        var a: [Status] = []
        switch Status.Available {
        case .Available:
            a.append(.Available);fallthrough
        case .Busy:
            a.append(.Busy);fallthrough
        case .AtSchool:
            a.append(.AtSchool);fallthrough
        case .AtTheMovies:
            a.append(.AtTheMovies);fallthrough
        case .AtWork:
            a.append(.AtWork);fallthrough
        case .BatteryAboutToDie:
            a.append(.BatteryAboutToDie);fallthrough
        case .CanTalk:
            a.append(.CanTalk);fallthrough
        case .InAMeeting:
            a.append(.InAMeeting);fallthrough
        case .AtTheGym:
            a.append(.AtTheGym);fallthrough
        case .Sleeping:
            a.append(.Sleeping);fallthrough
        case .UrgentCallOnly:
            a.append(.UrgentCallOnly);
            return a
        }
    }
}
