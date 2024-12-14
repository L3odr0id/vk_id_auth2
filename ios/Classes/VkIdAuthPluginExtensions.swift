import VKID

/// Расширение над классом [UserSession] VK ID SDK для конвертации объекта [UserSession]
/// в [Dictionary<String, Any?>].
extension UserSession {

    var toDictionary: Dictionary<String, Any?> {
        var dictionary = Dictionary<String, Any?>()
        let token = accessToken.value
        let userId = user?.id.value
        let user = user?.toDictionary
        dictionary.updateValue(token, forKey: "token")
        dictionary.updateValue(userId, forKey: "userId")
        dictionary.updateValue(user, forKey: "userData")
        return dictionary
    }

}

/// Расширение над классом [User] VK ID SDK для конвертации объекта [User]
/// в [Dictionary<String, Any?>].
extension User {

    var toDictionary: Dictionary<String, Any?> {
        var dictionary = Dictionary<String, Any?>()
        dictionary.updateValue(firstName, forKey: "firstName")
        dictionary.updateValue(lastName, forKey: "lastName")
        dictionary.updateValue(email, forKey: "email")
        dictionary.updateValue(phone, forKey: "phone")
        return dictionary
    }
}
