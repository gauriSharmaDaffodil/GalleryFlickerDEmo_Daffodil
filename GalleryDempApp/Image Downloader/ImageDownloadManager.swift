
import Foundation
import UIKit

class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    
    private init () {}
    
    lazy private var config = URLSessionConfiguration.default
    
    lazy private var session = URLSession(configuration: config)
    
    lazy private var cache = NSCache<AnyObject, AnyObject>()
    
    lazy private var tasks = [IndexPath: URLSessionDataTask]()
    
    
    /// This method is used to get the image from url
    ///
    /// - Parameters:
    ///   - urlString: string url of the image
    ///   - onCompletion: Completion block
    ///   - onFailure: Failure block
    func getImageWithURL(urlString: String, indexPath: IndexPath, onCompletion: @escaping (_ url: URL, _ image: UIImage)->Void, onFailure: @escaping (_ url: URL)->Void){
        
        // Remove completed tasks from task holder
        self.removeCompletedTasksFromTaskHolder()

        //Check if any running task already downloading image
        if checkIfRunningTaskAlreadyDownloadingImage(indexPath: indexPath).result{
            
            //update existing task with higher priority
            let task = checkIfRunningTaskAlreadyDownloadingImage(indexPath: indexPath).task
            task?.priority = URLSessionDataTask.highPriority
            
        }
        else{
            
            //prepare new task to download
            
            let url = URL(string: urlString)!
            
            if let image = cache.object(forKey: urlString as AnyObject) as? UIImage{
                
                onCompletion(url, image)
            }
            else{
                
                let task = session.dataTask(with: url) { [weak self] (data, response, error)  in
                    if error != nil{
                        onFailure(url)
                    }
                    
                    if data != nil{
                        
                        let image = UIImage(data: data!)
                        self?.cache.setObject(image!, forKey: urlString as AnyObject)
                        
                        onCompletion(url, image!)
                    }
                }
                
                task.priority = URLSessionDataTask.defaultPriority
                tasks[indexPath] = task
                
                task.resume()
            }
        }
    }
    
    
    /// This function is used to update the task pool
    private func removeCompletedTasksFromTaskHolder(){
        for eachTask in tasks{
            if eachTask.value.state == .completed{
                tasks.removeValue(forKey: eachTask.key)
            }
        }
    }
    
    
    /// This function is used to check
    ///
    /// - Parameter newTaskURLString: New task image url
    /// - Returns: (result: Bool, task: URLSessionDataTask?)
    private func checkIfRunningTaskAlreadyDownloadingImage(indexPath: IndexPath)->(result: Bool, task: URLSessionDataTask?){
        let task = self.tasks.filter { (key, value) -> Bool in
            return indexPath == key
        }
        
        if task.keys.count > 0{
            return (true, task.values.first)
        }
        else{
            return (false, nil)
        }
    }
    
    
    /// This function is used to reduce the priority of current executing tasks
    ///
    /// - Parameter indexPath: [indexPath] for the tasks to decrease priority
    func reducePriorityForTasks(withIndexPaths indexPath: [IndexPath]){
        let tasks = self.tasks.filter { (key, value) -> Bool in
            return indexPath.contains(key)
        }
        
        for task in tasks{
            task.value.priority = URLSessionDataTask.lowPriority
        }
    }
    
    
    /// This method is used to get all executing tasks
    ///
    /// - Returns: [indexPath] for executing tasks
    func getIndexPathForAllExecutingTasks()->[IndexPath]{
        return Array(tasks.keys)
    }
    
}

