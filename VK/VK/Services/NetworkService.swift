//import Foundation
//
//struct NetworkService {
//    static func request(for configutarion: AppConfiguration) {
//        switch configutarion {
//        case .species(let urlString):
//            dataTask(urlString: urlString)
//        case .vehicles(let urlString):
//            dataTask(urlString: urlString)
//        case .starships(let urlString):
//            dataTask(urlString: urlString)
//        }
//    }
//}
//
//func dataTask(urlString: String) {
//    if let url = URL(string: urlString) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                if let decodedData = String(data: data, encoding: String.defaultCStringEncoding) {
//                    print("data: ", decodedData)
//                }
//            }
//            if let response = response {
//                if let httpUrlResposce = response as? HTTPURLResponse {
//                    print("allHeaderFields: ", httpUrlResposce.allHeaderFields)
//                    print("statusCode: ", httpUrlResposce.statusCode)
//                }
//            }
//            if let error = error {
//                print("responce error: ", error.localizedDescription)
//            }
//        }
//        task.resume()
//    } else {
//        print("Cannot create URL")
//    }
//}
