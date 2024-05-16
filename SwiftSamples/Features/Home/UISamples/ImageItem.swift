//
//  ImageItem.swift
//  SwiftSamples
//
//  Created by Kei on 2024/05/15.
//

import SwiftUI

struct PhotoItem: Identifiable, Hashable, Equatable {
  let id: String = UUID().uuidString
  let title: String
  let image: UIImage?
  let linkURL: URL
}

extension PhotoItem {
  public static func mock() -> [Self] {
    return [
      .init(title: "994605", image: UIImage(named: "pexels1"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/994605/")!),
      .init(title: "237272", image: UIImage(named: "pexels2"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/237272/")!),
      .init(title: "64219", image: UIImage(named: "pexels3"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/64219/")!),
      .init(title: "355465", image: UIImage(named: "pexels4"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/355465/")!),
      .init(title: "129495", image: UIImage(named: "pexels5"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/129495/")!),
      .init(title: "2062426", image: UIImage(named: "pexels6"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/2062426/")!),
      .init(title: "851555", image: UIImage(named: "pexels7"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/851555/")!),
      .init(title: "773471", image: UIImage(named: "pexels8"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/773471/")!),
      .init(title: "1115167", image: UIImage(named: "pexels9"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/1115167/")!),
      .init(title: "164212", image: UIImage(named: "pexels10"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/164212/")!),
//      .init(title: "17809274", image: UIImage(named: "pexels11"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/17809274/")!),
//      .init(title: "1884574", image: UIImage(named: "pexels12"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/1884574/")!),
//      .init(title: "1389429", image: UIImage(named: "pexels13"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/1389429/")!),
//      .init(title: "1152359", image: UIImage(named: "pexels14"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/1152359/")!),
//      .init(title: "206359", image: UIImage(named: "pexels15"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/206359/")!),
//      .init(title: "360912", image: UIImage(named: "pexels16"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/360912/")!),
//      .init(title: "39578", image: UIImage(named: "pexels17"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/39578/")!),
//      .init(title: "20054044", image: UIImage(named: "pexels18"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/20054044/")!),
//      .init(title: "546819", image: UIImage(named: "pexels19"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/546819/")!),
//      .init(title: "267350", image: UIImage(named: "pexels20"), linkURL: URL(string: "https://www.pexels.com/ja-jp/photo/267350/")!)
    ]
  }
}
