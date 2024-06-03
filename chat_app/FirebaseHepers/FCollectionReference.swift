//
//  FCollectionReference.swift
//  chat_app
//
//  Created by KhoaLA8 on 23/4/24.
//

import Foundation
import FirebaseFirestoreInternal

enum FCollectionReference : String{
    case User
    case Recent
    case Messages
    case Typing
    case Channel
}

func FirebaseReference(_ collectionReference : FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
