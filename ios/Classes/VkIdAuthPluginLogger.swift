/// Логгер плагина.
public final class VkIdAuthPluginLogger {

    /// Логирует передаваемое сообщение.
    public static func log(_ message: String) {
        NSLog("[VkIdAuthPlugin] | \(message)")
    }
}
