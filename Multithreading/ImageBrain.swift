//
//  ImageBrain.swift
//  Multithreading
//
//  Created by Виктор Петровский on 08.12.2020.
//

import Foundation

struct ImageBrain {
    
    typealias Completion = ((Data?, Data?, Data?, Data?) -> ())
    
    private enum TypeOfMultitheating: Int {
        case atTheSameTime = 1, chaotic, delay
        
        static func methodSelection() -> TypeOfMultitheating {
            return TypeOfMultitheating.init(rawValue: Int.random(in: 1...3)) ?? .atTheSameTime
        }
    }
    
    func getImage(completion: @escaping Completion) {
        let method = TypeOfMultitheating.methodSelection()
        print(method)
        
        switch method {
        case .atTheSameTime:
            getDataAtTheSameTime { (data1, data2, data3, data4) in
                completion(data1, data2, data3, data4)
            }
        case .chaotic:
            getDataChaotic { (data1, data2, data3, data4) in
                completion(data1, data2, data3, data4)
            }
        case .delay:
            getDataWithDelay { (data1, data2, data3, data4) in
                completion(data1, data2, data3, data4)
            }
        }
        
    }
    
    private func getDataAtTheSameTime(completion: @escaping Completion) {
        
        var dataImg1: Data?
        var dataImg2: Data?
        var dataImg3: Data?
        var dataImg4: Data?
        
        let  operationQuie = OperationQueue()
        
        let dataOfUrl1 = BlockOperation {
            downloadImage(with: Constants.img1) { dataImg1 = $0 }
        }
        
        let dataOfUrl2 = BlockOperation {
            downloadImage(with: Constants.img2) { dataImg2 = $0 }
        }
        
        let dataOfUrl3 = BlockOperation {
            downloadImage(with: Constants.img3) { dataImg3 = $0 }
        }
        
        let dataOfUrl4 = BlockOperation {
            downloadImage(with: Constants.img4) { dataImg4 = $0 }
        }
        
        operationQuie.addOperations([dataOfUrl1, dataOfUrl2, dataOfUrl3, dataOfUrl4], waitUntilFinished: true)
        
        DispatchQueue.main.async {
            completion(dataImg1, dataImg2, dataImg3, dataImg4)
        }
    }
    
    private func getDataChaotic(completion: @escaping Completion) {
        DispatchQueue.global().async {
            downloadImage(with: Constants.img1) { (data1) in
                completion(data1, nil, nil, nil)
            }
        }
        
        DispatchQueue.global().async {
            downloadImage(with: Constants.img2) { (data2) in
                completion(nil, data2, nil, nil)
            }
        }
        
        DispatchQueue.global().async {
            downloadImage(with: Constants.img3) { (data3) in
                completion(nil, nil, data3, nil)
            }
        }
        
        DispatchQueue.global().async {
            downloadImage(with: Constants.img4) { (data4) in
                completion(nil, nil, nil, data4)
            }
        }
    }
    
    
    
    private func getDataWithDelay(completion: @escaping Completion) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + Double(Int.random(in: 0...5))) {
            downloadImage(with: Constants.img1) { (data1) in
                completion(data1, nil, nil, nil)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + Double(Int.random(in: 0...5))) {
            downloadImage(with: Constants.img2) { (data2) in
                completion(nil, data2, nil, nil)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + Double(Int.random(in: 0...5))) {
            downloadImage(with: Constants.img3) { (data3) in
                completion(nil, nil, data3, nil)
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + Double(Int.random(in: 0...5))) {
            downloadImage(with: Constants.img4) { (data4) in
                completion(nil, nil, nil, data4)
            }
        }
    }
    
    
    private func downloadImage(with adress: String, _ completion: @escaping (Data?) -> ()) {
        
        if let url = URL(string: adress) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, _, error) in
                guard let safeData = data else { print("\(error!)"); return }
                completion(safeData)
            }
            task.resume()
        }
    }
}

