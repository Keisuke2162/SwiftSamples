//
//  Book.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/12.
//

import Foundation

public struct BooksResult: Codable {
  public let items: [Book]
}

public struct Book: Identifiable, Codable, Equatable {
  public static func == (lhs: Book, rhs: Book) -> Bool {
    lhs.id == rhs.id
  }

  public let id: String
  public let volumeInfo: VolumeInfo
  public var isbn13Identifier: String? {
    volumeInfo.industryIdentifiers?.first(where: { $0.type == .isbn13 })?.identifier
  }
  public var isbn10Identifier: String? {
    volumeInfo.industryIdentifiers?.first(where: { $0.type == .isbn10 })?.identifier
  }
  public var thumbnailImageURL: URL? {
    if let isbn13ID = isbn13Identifier {
      return .init(string: "https://ndlsearch.ndl.go.jp/thumbnail/\(isbn13ID).jpg")
    } else if let isbn10ID = isbn10Identifier {
      return .init(string: "https://ndlsearch.ndl.go.jp/thumbnail/\(isbn10ID).jpg")
    } else {
      return nil
    }
  }

  public struct VolumeInfo: Codable {
    let title: String
    let description: String?
    let industryIdentifiers: [IndustryIdentifiers]?
  }

  public struct IndustryIdentifiers: Codable {
    let type: ISBNType
    let identifier: String
  }

  public init(id: String, title: String, description: String, isbn13ID: String) {
    self.id = id
    self.volumeInfo = .init(title: title, description: description, industryIdentifiers: [.init(type: .isbn13, identifier: isbn13ID)])
  }

  public enum ISBNType: String, Codable {
    case isbn13 = "ISBN_13"
    case isbn10 = "ISBN_10"
    case other = "OTHER"
  }
}

extension Book {
  public static func mock(id: String) -> Self {
    .init(
      id: id,
      title: "危機を乗り越える力",
      description: "ホンダに30年ぶりのＦ１タイトルをもたらしたパワーユニット開発の陣頭指揮を執り、９年連続で軽自動車販売トップを独走する「N-BOX」の生みの親でもある元ホンダ技術者が、プロジェクト成功の舞台裏を明かす。第２期Ｆ１時代の奮闘エピソード、ホンダ創業者・本田宗一郎さんとの思い出、初代オデッセイ、N-BOXの開発秘話、どん底からのＦ１プロジェクト立て直し、Ｆ１復帰に向けた「蜘蛛の糸作戦」の全貌、アストンマーティン・ホンダの勝算など。芸能界随一のＦ１ファン、堂本光一氏との対談も収録！",
      isbn13ID: "9784797674453"
    )
  }
}
