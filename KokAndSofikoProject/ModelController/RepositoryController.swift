import UIKit

class RepositoryController {

    static func getRepoList(authData: String, _ completionHandler: @escaping (_ repositoryList:[Repository]) -> Void) {
        var repositoryList : [Repository] = []
        Request.new(address: "https://api.github.com/user/repos", headers: ["User-Agent" : "Awesome-Octocat-App", "Authorization" : "Basic " + Data(authData.utf8).base64EncodedString()], method: "GET", {response in
            if let repoList = response?.value as? [Any] {
                for _repo in repoList {
                    if let repo = _repo as? [String : Any] {
                        let newRepository = Repository()
                        newRepository.id = repo["id"] as? Int ?? -1
                        newRepository.name = repo["name"] as? String ?? "-"
                        repositoryList.append(newRepository)
                    }
                }
            }
            completionHandler(repositoryList)
        })
    }

}
