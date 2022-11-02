//
//  FormDataGenerator.swift
//  MangoMarket
//
//  Created by RED on 2022/10/18.
//

import Foundation

enum MIMEType: String {
  case json = "application/json"
  case png = "image/png"
  case jpeg = "image/jpeg"
}

struct FormData {
  var type: MIMEType
  var name: String
  var filename: String?
  var data: Data?
}

final class FormDataGenerator {
  private var data: Data
  private let boundary: String
  private var boundaryPrefix: String { "\r\n--\(boundary)\r\n" }
  private var boundarySuffix: String { "\r\n--\(boundary)--\r\n" }
  
  init(boundary: String) {
    self.data = Data()
    self.boundary = boundary
  }
  
  private func appendFormData(_ form: FormData) {
    guard let formData = form.data else { return }
    data.appendString(boundaryPrefix)
    data.appendString("Content-Disposition: form-data; name=\"\(form.name)\"")
    if let filename = form.filename {
      data.appendString("; filename=\"\(filename)\"")
    }
    data.appendString("\r\n")
    data.appendString("Content-Type: \(form.type.rawValue)\r\n\r\n")
    data.append(formData)
  }
  
  private func appendFormDatas(_ forms: [FormData]) {
    forms.forEach { appendFormData($0) }
  }
  
  func createMutiPartFormData(_ forms: [FormData]) -> Data {
    appendFormDatas(forms)
    data.appendString(boundarySuffix)
    return data
  }
}
