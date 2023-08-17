import Foundation

public struct HumanRequestDTO {
    let gender: Gender
    let page, results: Int

    public init(gender: Gender, page: Int, results: Int) {
        self.gender = gender
        self.page = page
        self.results = results
    }
}
