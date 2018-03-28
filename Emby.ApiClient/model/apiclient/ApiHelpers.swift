//
//  ApiHelpers.swift
//  Emby.ApiClient
//

import Foundation

public final class ApiHelpers {
    public static func getSlugName(name: String?) -> String {
        return name!.replace(what: "/", with: "-").replace(what: "?", with: "-").replace(what: "&", with: "-")
    }
}
