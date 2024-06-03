//
//  FileStorage.swift
//  chat_app
//
//  Created by KhoaLA8 on 13/5/24.
//

import Foundation
import FirebaseStorage
import ProgressHUD

let storage = Storage.storage()

class FileStorage {
    class func uploadImage(_ image: UIImage, directory: String, completion : @escaping (_ documentLink: String?)-> Void){
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        let imageData = image.jpegData(compressionQuality: 1.0)
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!,metadata: nil, completion: {(metadata,error) in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading image \(error!.localizedDescription)")
            }
            
            storageRef.downloadURL{ (url, error) in
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                completion(url?.absoluteString)
            }
        
        })
        
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.progress(CGFloat(progress))
        }
    }
    
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> Void){
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        print(imageUrl)
        print(imageFileName)
        if fileExistsAtPath(path: imageFileName){
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(filename: imageFileName)){
                completion(contentsOfFile)
            }else{
                completion(UIImage(named: "avatar"))
            }
        }else{
            print("download FB")
            if imageUrl != ""{
                let documentUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil {
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data as! Data))
                        }
                    }else{
                        print("no document in DB")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    //MARK: - Video
    class func uploadVideo(_ video: NSData, directory: String, completion: @escaping (_ videoLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
                
        var task: StorageUploadTask!
        
        task = storageRef.putData(video as Data, metadata: nil, completion: { (metadata, error) in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading video \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                guard let downloadUrl = url  else {
                    completion(nil)
                    return
                }
                
                completion(downloadUrl.absoluteString)
            }
        })
        
        
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.progress(CGFloat(progress))
        }
    }

    class func downloadVideo(videoLink: String, completion: @escaping (_ isReadyToPlay: Bool, _ videoFileName: String) -> Void) {
        
        let videoUrl = URL(string: videoLink)
        let videoFileName = fileNameFrom(fileUrl: videoLink) + ".mov"

        if fileExistsAtPath(path: videoFileName) {
                
            completion(true, videoFileName)
            
        } else {

            let downloadQueue = DispatchQueue(label: "VideoDownloadQueue")
            
            downloadQueue.async {
                
                let data = NSData(contentsOf: videoUrl!)
                
                if data != nil {
                    
                    //Save locally
                    FileStorage.saveFileLocally(fileData: data!, fileName: videoFileName)
                    
                    DispatchQueue.main.async {
                        completion(true, videoFileName)
                    }
                    
                } else {
                    print("no document in database")
                }
            }
        }
    }

    
    //MARK: - Save Locally
    class func saveFileLocally(fileData: NSData, fileName: String){
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docUrl, atomically: true)
    }
}

//Helpers
func fileInDocumentsDirectory(filename: String) -> String{
    return getDocumentsURL().appendingPathComponent(filename).path
}

func getDocumentsURL()-> URL{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func fileExistsAtPath(path : String)-> Bool{
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(filename: path))
}
