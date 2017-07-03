import Moya
import Alamofire

public struct CustomEncoding: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else {
            return try urlRequest.asURLRequest()
        }

        let parametersString = parameters.map{$0.key + "=" + ($0.value as! String)}.joined(separator: "&")
        let body = parametersString.data(using: String.Encoding.utf8, allowLossyConversion: false)

        var request = try URLEncoding(destination: .queryString).encode(urlRequest, with: nil)
        request.httpBody = body
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return request
    }
    
}
