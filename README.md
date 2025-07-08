# 🔐 ServePass - Advanced FiveM Server Password Protection
<div align="center">
  <img src="assets/Lucid_Realism_Create_a_professional_banner_logo_for_ServePass__0.png" alt="ServePass Banner" width="100%" max-width="1200px">
</div>
<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-blue.svg)](https://fivem.net/)
[![Version](https://img.shields.io/badge/Version-2.0.0-green.svg)](https://github.com/mostaghell/ServerPass/releases)
[![Telegram](https://img.shields.io/badge/Telegram-@MostaQeell-blue.svg)](https://t.me/MostaQeell)
[![Website](https://img.shields.io/badge/Website-mostaghell.com-orange.svg)](https://mostaghell.com)

A comprehensive FiveM resource that provides advanced server password protection with modern web UI, extensive logging, security features, and administrative tools.

---

### 🏆 Developed by **Mostaghell Team**

*A leading independent label in the world of music and technology, operating as a comprehensive platform. This label specializes in music production, composition, and creating unique content and projects, expanding the boundaries of creativity and helping flourish innovative ideas in various fields.*

**🌐 Official Links:**
- 📱 **Telegram Channel**: [https://t.me/MostaQeell](https://t.me/MostaQeell)
- 🌍 **Official Website**: [mostaghell.com](https://mostaghell.com)

---

</div>

## ✨ Features

### 🔒 Security Features
- **Password Protection**: Secure server access with customizable passwords
- **Rate Limiting**: Prevent brute force attacks with configurable rate limits
- **Whitelist System**: Optional whitelist for trusted players
- **Admin Bypass**: Automatic authentication bypass for administrators
- **Session Management**: Secure session handling with cleanup
- **Attempt Limiting**: Configurable maximum password attempts

### 🎨 User Experience
- **Modern Web UI**: Beautiful, responsive password prompt interface
- **Real-time Feedback**: Instant validation and error messages
- **Player Control Lockdown**: Complete restriction until authentication
- **Customizable Messages**: Configurable UI text and notifications
- **Mobile Friendly**: Works on all screen sizes

### 📊 Logging & Monitoring
- **Comprehensive Logging**: Detailed logs for all authentication events
- **Security Event Tracking**: Monitor suspicious activities
- **Performance Metrics**: Track authentication success rates
- **Admin Commands**: Console commands for server management
- **Real-time Status**: Live authentication status monitoring

### ⚙️ Administration
- **Console Commands**: Powerful admin tools for server management
- **Dynamic Configuration**: Change settings without restart
- **Bulk Operations**: Kick all unauthenticated players at once
- **Status Monitoring**: Real-time player authentication status
- **Password Management**: Secure password changing via console

## 🚀 Quick Installation

### Automatic Installation (Recommended)

1. Download the latest release from [GitHub Releases](https://github.com/mostaghell/ServerPass/releases)
2. Extract to your FiveM server root directory
3. Run `install.bat` (Windows) or `install.sh` (Linux)
4. Edit `resources/[local]/serve-pass/config.lua` with your settings
5. Restart your server

### Manual Installation

1. Clone or download this repository
2. Copy the `serve-pass` folder to your `resources/[local]/` directory
3. Add `ensure serve-pass` to the **top** of your `server.cfg`
4. Configure the resource (see Configuration section)
5. Restart your FiveM server

## ⚙️ Configuration

### Basic Setup

Edit `config.lua` to customize ServePass:

```lua
-- Basic Settings
Config.Password = "your_secure_password_here"  -- Change this!
Config.MaxAttempts = 3                         -- Max password attempts
Config.KickOnMaxAttempts = true               -- Kick after max attempts

-- Security Features
Config.EnableRateLimit = true                 -- Enable rate limiting
Config.EnableWhitelist = false               -- Enable whitelist mode
Config.EnableLogging = true                  -- Enable detailed logging
```

### Advanced Configuration

```lua
-- Rate Limiting
Config.RateLimitWindow = 300        -- 5 minutes
Config.MaxAttemptsPerWindow = 5     -- Max attempts per IP

-- Logging
Config.LogLevel = "INFO"            -- DEBUG, INFO, WARN, ERROR
Config.LogFile = "servepass.log"    -- Log file name

-- UI Customization
Config.UISettings = {
    title = "Server Authentication",
    subtitle = "Please enter the server password",
    placeholder = "Enter password..."
}
```

### Server.cfg Setup

**IMPORTANT**: Place ServePass at the top of your resource list:

```cfg
# ServePass - Load FIRST for early authentication
ensure serve-pass

# Core Resources
ensure chat
ensure spawnmanager
ensure sessionmanager

# Other Resources
# ... your other resources here
```

## Usage

### For Players

1. **Connect**: Join the server normally through FiveM
2. **Spawn**: Wait for your character to spawn in the world
3. **Authentication**: A modern password prompt will appear automatically
4. **Enter Password**: Type the server password (case-sensitive)
5. **Submit**: Click "Submit" or press Enter to authenticate
6. **Play**: Once authenticated, all restrictions are lifted

**Note**: While unauthenticated, you cannot:
- Move your character
- Use chat, weapons, or vehicles
- Access phone, map, or pause menu
- Interact with the world

### For Administrators

#### Console Commands

All admin commands must be executed from the **server console**:

```bash
# Check authentication status
servepass:status

# Kick all unauthenticated players
servepass:kickunauthenticated

# Change server password
servepass:changepassword <new_password>
```

#### Command Examples

```bash
# View current player status
servepass:status
# Output: [ServePass] Players: 15 total, 12 authenticated, 3 pending

# Remove unauthenticated players
servepass:kickunauthenticated
# Output: [ServePass] Kicked 3 unauthenticated players

# Change password securely
servepass:changepassword MyNewSecurePassword123
# Output: [ServePass] Password changed successfully
```

## How It Works

1. **Connection**: Players connect to the server normally
2. **Spawn**: When a player spawns, they are marked as unauthenticated
3. **Password Prompt**: A modern web UI appears requiring password input
4. **Restrictions**: Unauthenticated players cannot:
   - Move or control their character
   - Use chat, weapons, vehicles, or other features
   - Access phone, map, or pause menu
5. **Authentication**: Players enter the password through the web interface
6. **Verification**: Server validates the password and either:
   - Removes restrictions if correct
   - Shows error and allows retry if incorrect
7. **Full Access**: Only authenticated players can fully participate in gameplay

## 🔒 Security Features

### Built-in Security
- **Rate Limiting**: Prevents brute force attacks with configurable windows
- **Attempt Limiting**: Configurable maximum attempts before kick
- **Session Management**: Secure session handling with automatic cleanup
- **IP Tracking**: Monitor and log authentication attempts by IP
- **Whitelist Support**: Optional whitelist for trusted players
- **Admin Bypass**: Automatic authentication for administrators

### Security Best Practices
- **Strong Passwords**: Use complex passwords with mixed characters
- **Regular Updates**: Keep ServePass updated to the latest version
- **Monitor Logs**: Regularly check authentication logs for suspicious activity
- **Backup Config**: Keep secure backups of your configuration
- **Console Access**: Restrict server console access to trusted administrators

## 🛠️ Troubleshooting

### Common Issues

#### Password Prompt Not Appearing
```bash
# Check resource status
refresh
ensure serve-pass

# Verify in server console:
# [ServePass] ServePass system initialized successfully
```

**Solutions:**
1. Ensure `serve-pass` is at the top of your `server.cfg`
2. Check for script errors in server console
3. Verify all files are present in the resource folder
4. Restart the resource: `restart serve-pass`

#### Authentication Failures
```bash
# Check logs for errors
servepass:status

# Common log entries:
# [WARN] Player entered incorrect password
# [ERROR] Failed to get identifier for connecting player
```

**Solutions:**
1. Verify password in `config.lua` (case-sensitive)
2. Check for special characters or encoding issues
3. Ensure player identifiers are working correctly
4. Test with a simple password first

#### UI/NUI Issues
```bash
# Client-side debugging (F8 console)
resmon

# Look for:
# NUI errors
# Resource loading issues
# JavaScript console errors
```

**Solutions:**
1. Clear FiveM cache and restart
2. Check `html/` folder contains all files
3. Verify no conflicting resources
4. Test with default UI settings

### Debug Mode

Enable debug mode in `config.lua`:
```lua
Config.DebugMode = true
Config.LogLevel = "DEBUG"
```

This provides detailed logging for troubleshooting.

## 🎨 Customization

### UI Customization

Modify `config.lua` for basic UI changes:
```lua
Config.UISettings = {
    title = "Your Server Name",
    subtitle = "Enter the secret code",
    placeholder = "Secret code...",
    submitText = "Enter",
    cancelText = "Leave"
}
```

### Advanced UI Styling

Edit files in the `html/` folder:
- **`index.html`** - Structure and layout
- **`style.css`** - Colors, fonts, and animations
- **`script.js`** - Interactive behavior

#### Custom Theme Example
```css
/* Dark theme in html/style.css */
.container {
    background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
}

.modal {
    background: rgba(0, 0, 0, 0.9);
    border: 1px solid #00ff88;
    box-shadow: 0 0 20px rgba(0, 255, 136, 0.3);
}

.input-field {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid #00ff88;
    color: #00ff88;
}
```

### Adding Features

ServePass is designed to be extensible:

```lua
-- Example: Custom authentication logic
function CustomAuth.validatePlayer(source, password)
    -- Add your custom validation here
    -- Database checks, API calls, etc.
    return true -- or false
end
```

## 📊 Monitoring & Analytics

### Log Analysis

ServePass generates detailed logs for monitoring:

```bash
# Authentication events
[INFO] Authentication SUCCESS - Player: John [steam:123] - Attempts: 1
[WARN] Authentication FAILED - Player: BadActor [steam:456] - Attempts: 3

# Security events
[WARN] Security Event: RATE_LIMIT_EXCEEDED - IP: 192.168.1.100
[WARN] Security Event: MAX_ATTEMPTS_EXCEEDED - Player: Hacker [steam:789]

# System events
[INFO] System Event: PASSWORD_CHANGED - Details: Console
[INFO] System Event: STARTUP - Details: ServePass initialized
```

### Performance Monitoring

```bash
# Check resource performance
resmon

# Monitor player counts
servepass:status

# Track authentication success rate
# Review logs for patterns and issues
```

## 🤝 Contributing

We welcome contributions to ServePass! Here's how you can help:

### Reporting Issues
1. Check existing [issues](https://github.com/mostaghell/ServerPass/issues) first
2. Create a detailed bug report with:
   - FiveM server version
   - ServePass version
   - Steps to reproduce
   - Server console logs
   - Expected vs actual behavior

### Feature Requests
1. Open an [issue](https://github.com/mostaghell/ServerPass/issues/new) with the "enhancement" label
2. Describe the feature and its use case
3. Explain why it would benefit the community

### Pull Requests
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes with proper testing
4. Update documentation if needed
5. Submit a pull request with a clear description

### Development Setup
```bash
# Clone the repository
git clone https://github.com/mostaghell/ServerPass.git
cd servepass

# Create a test server environment
# Copy to your FiveM server for testing
```

## 📋 Changelog

### Version 2.0.0
- ✨ **New**: Comprehensive logging system
- ✨ **New**: Rate limiting and security features
- ✨ **New**: Whitelist system
- ✨ **New**: Admin console commands
- ✨ **New**: Configuration file system
- 🔧 **Improved**: Error handling and validation
- 🔧 **Improved**: Session management
- 🔧 **Improved**: UI/UX with better feedback
- 🐛 **Fixed**: Multiple authentication attempts
- 🐛 **Fixed**: Memory leaks and cleanup issues

### Version 1.0.0
- 🎉 Initial release
- Basic password protection
- Web-based UI
- Post-spawn authentication

## 🆘 Support

<div align="center">

### 🏢 **Official Mostaghell Team Support**

[![Telegram Support](https://img.shields.io/badge/Telegram%20Support-@MostaQeell-blue?style=for-the-badge&logo=telegram)](https://t.me/MostaQeell)
[![Website Support](https://img.shields.io/badge/Website%20Support-mostaghell.com-orange?style=for-the-badge&logo=web)](https://mostaghell.com)

</div>

### Getting Help
- 📖 **Documentation**: Read this README thoroughly
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/mostaghell/ServerPass/issues)
- 📱 **Telegram**: Join our official channel [@MostaQeell](https://t.me/MostaQeell)
- 🌍 **Website**: Visit [mostaghell.com](https://mostaghell.com) for more projects
- 💬 **Community**: [FiveM Forums](https://forum.cfx.re/)

### Frequently Asked Questions

**Q: Can I use this on a production server?**
A: Yes, ServePass is designed for production use with proper configuration.

**Q: Does this work with ESX/QBCore?**
A: Yes, ServePass is framework-agnostic and works with any FiveM setup.

**Q: Can I have multiple passwords?**
A: Currently, ServePass supports one password. Multi-password support is planned for future versions.

**Q: Is this compatible with other authentication systems?**
A: ServePass can be integrated with existing systems through custom validation functions.

**Q: Do you provide custom development services?**
A: Yes! Contact us through [Telegram](https://t.me/MostaQeell) or visit [mostaghell.com](https://mostaghell.com) for custom FiveM development services.

## 🏆 Credits

- **Development**: ServePass Team
- **UI Design**: Modern web standards and best practices
- **Security Consulting**: FiveM community feedback
- **Testing**: Community beta testers

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Mostaghell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">

**⭐ If you find ServePass useful, please give it a star on GitHub! ⭐**

[![GitHub stars](https://img.shields.io/github/stars/mostaghell/ServerPass?style=social)](https://github.com/mostaghell/ServerPass/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/mostaghell/ServerPass?style=social)](https://github.com/mostaghell/ServerPass/network)

[Report Bug](https://github.com/mostaghell/ServerPass/issues) • [Request Feature](https://github.com/mostaghell/ServerPass/issues) • [Contribute](https://github.com/mostaghell/ServerPass/pulls)

---

### 💝 Support the Developers

**Join our community and stay updated:**

[![Telegram](https://img.shields.io/badge/Join%20Telegram-@MostaQeell-blue?style=for-the-badge&logo=telegram)](https://t.me/MostaQeell)
[![Website](https://img.shields.io/badge/Visit%20Website-mostaghell.com-orange?style=for-the-badge&logo=web)](https://mostaghell.com)

---

*Made with ❤️ by **Mostaghell Team** for the FiveM community*

**© 2025 Mostaghell Team. All rights reserved.**

</div>
