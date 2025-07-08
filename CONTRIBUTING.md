# Contributing to ServePass

<div align="center">

[![Telegram](https://img.shields.io/badge/Join%20Community-@MostaQeell-blue?style=for-the-badge&logo=telegram)](https://t.me/MostaQeell)
[![Website](https://img.shields.io/badge/Visit%20Website-mostaghell.com-orange?style=for-the-badge&logo=web)](https://mostaghell.com)

</div>

First off, thank you for considering contributing to ServePass! It's people like you that make ServePass such a great tool for the FiveM community.

**ServePass** is proudly developed and maintained by the **Mostaghell Team** - a leading independent label in the world of music and technology, operating as a comprehensive platform specializing in music production, composition, and creating unique content and projects.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for ServePass. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

**Before Submitting A Bug Report:**
- Check the [existing issues](https://github.com/your-username/servepass/issues) to see if the problem has already been reported
- Check the [troubleshooting section](README.md#troubleshooting) in the README
- Collect information about the bug:
  - FiveM server version
  - ServePass version
  - Operating system and version
  - Steps to reproduce the issue
  - Expected behavior vs actual behavior
  - Server console logs
  - Client console logs (F8 in FiveM)

**How Do I Submit A Bug Report?**

Bugs are tracked as [GitHub issues](https://github.com/your-username/servepass/issues). Create an issue and provide the following information:

- **Use a clear and descriptive title** for the issue
- **Describe the exact steps to reproduce the problem** in as many details as possible
- **Provide specific examples** to demonstrate the steps
- **Describe the behavior you observed** after following the steps
- **Explain which behavior you expected to see instead** and why
- **Include screenshots or recordings** if they help explain the problem
- **Include server and client logs** that show the error

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for ServePass.

**Before Submitting An Enhancement Suggestion:**
- Check if the enhancement has already been suggested
- Check if the enhancement fits the scope of ServePass
- Consider if the enhancement would be useful to the broader community

**How Do I Submit An Enhancement Suggestion?**

Enhancement suggestions are tracked as [GitHub issues](https://github.com/your-username/servepass/issues). Create an issue and provide the following information:

- **Use a clear and descriptive title** for the issue
- **Provide a step-by-step description** of the suggested enhancement
- **Provide specific examples** to demonstrate the enhancement
- **Describe the current behavior** and **explain which behavior you expected to see instead**
- **Explain why this enhancement would be useful** to most ServePass users
- **Specify which version of ServePass** you're using

### Pull Requests

The process described here has several goals:

- Maintain ServePass's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible ServePass
- Enable a sustainable system for ServePass's maintainers to review contributions

**Development Process:**

1. **Fork** the repository
2. **Create a branch** from `main` for your feature or fix
3. **Make your changes** following our coding standards
4. **Test your changes** thoroughly
5. **Update documentation** if necessary
6. **Submit a pull request**

**Pull Request Guidelines:**

- **Fill in the required template**
- **Do not include issue numbers in the PR title**
- **Include screenshots and animated GIFs** in your pull request whenever possible
- **Follow the Lua coding standards**
- **Include thoughtfully-worded, well-structured tests**
- **Document new code** based on the Documentation Styleguide
- **End all files with a newline**

## Development Setup

### Prerequisites

- FiveM Server (latest version recommended)
- Text editor or IDE (VS Code recommended)
- Git for version control

### Setting Up Development Environment

1. **Clone your fork:**
   ```bash
   git clone https://github.com/your-username/servepass.git
   cd servepass
   ```

2. **Set up test server:**
   - Copy the resource to your FiveM server's resources folder
   - Add `ensure serve-pass` to your server.cfg
   - Configure test settings in config.lua

3. **Make your changes:**
   - Create a new branch: `git checkout -b feature/your-feature-name`
   - Make your modifications
   - Test thoroughly

4. **Submit your changes:**
   ```bash
   git add .
   git commit -m "Add your descriptive commit message"
   git push origin feature/your-feature-name
   ```

## Coding Standards

### Lua Style Guide

- **Indentation:** Use 4 spaces (no tabs)
- **Line Length:** Maximum 100 characters
- **Naming Conventions:**
  - Variables: `camelCase`
  - Functions: `camelCase`
  - Constants: `UPPER_SNAKE_CASE`
  - Files: `snake_case.lua`

- **Comments:**
  ```lua
  -- Single line comments
  
  --[[
      Multi-line comments
      for complex explanations
  ]]
  
  --- Function documentation
  -- @param source number Player source ID
  -- @param password string Password to validate
  -- @return boolean Success status
  function validatePassword(source, password)
      -- Implementation
  end
  ```

### File Structure

```
serve-pass/
├── config.lua              # Configuration file
├── fxmanifest.lua          # Resource manifest
├── server.lua              # Main server script
├── client.lua              # Legacy client script
├── connection_client.lua   # Main client script
├── server/
│   ├── logger.lua          # Logging system
│   └── security.lua        # Security functions
├── html/
│   ├── index.html          # UI structure
│   ├── style.css           # UI styling
│   └── script.js           # UI functionality
└── docs/
    └── api.md              # API documentation
```

### Testing

**Manual Testing Checklist:**

- [ ] Resource loads without errors
- [ ] Password prompt appears after spawn
- [ ] Correct password allows authentication
- [ ] Incorrect password shows error
- [ ] Max attempts kick works
- [ ] Rate limiting functions
- [ ] Admin commands work
- [ ] UI is responsive
- [ ] No console errors
- [ ] Performance is acceptable

**Test Scenarios:**

1. **Basic Authentication:**
   - Connect to server
   - Enter correct password
   - Verify full access granted

2. **Failed Authentication:**
   - Connect to server
   - Enter incorrect password
   - Verify error message
   - Test max attempts

3. **Rate Limiting:**
   - Make multiple rapid attempts
   - Verify rate limiting kicks in

4. **Admin Functions:**
   - Test console commands
   - Verify admin bypass
   - Test bulk operations

## Documentation

### Code Documentation

- Document all public functions
- Include parameter types and descriptions
- Provide usage examples
- Explain complex logic

### README Updates

- Update feature lists
- Add new configuration options
- Include new troubleshooting steps
- Update version information

## Community

### Communication Channels
- **📱 Telegram**: Join our official community [@MostaQeell](https://t.me/MostaQeell) for real-time discussions
- **🌍 Website**: Visit [mostaghell.com](https://mostaghell.com) for more projects and updates
- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For general questions and community discussions
- **Pull Requests**: For code contributions

### Getting Help
If you need help with contributing:
1. **Primary**: Join our [Telegram community](https://t.me/MostaQeell) for fastest response
2. Check existing issues and discussions on GitHub
3. Visit our [official website](https://mostaghell.com) for additional resources
4. Create a new issue with the "question" label
5. Be patient and respectful in all interactions

### Recognition
Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- GitHub contributors page
- Special mentions in our [Telegram community](https://t.me/MostaQeell)

### Contact the Mostaghell Team
For direct communication with the development team:
- **Telegram**: [@MostaQeell](https://t.me/MostaQeell)
- **Website**: [mostaghell.com](https://mostaghell.com)
- **Business Inquiries**: Contact us through our official channels

## Release Process

1. **Version Bump:** Update version in fxmanifest.lua
2. **Changelog:** Update CHANGELOG.md
3. **Testing:** Comprehensive testing
4. **Documentation:** Update README if needed
5. **Release:** Create GitHub release with notes

## Questions?

Don't hesitate to ask questions! You can:

- **Primary**: Join our [Telegram community](https://t.me/MostaQeell) for fastest response
- Open an issue with the "question" label
- Visit our [official website](https://mostaghell.com) for additional resources
- Contact maintainers directly

---

<div align="center">

**Thank you for contributing to ServePass! 🎉**

*Developed with ❤️ by **Mostaghell Team***

[![Telegram](https://img.shields.io/badge/Join%20Us-@MostaQeell-blue?style=social&logo=telegram)](https://t.me/MostaQeell)
[![Website](https://img.shields.io/badge/Visit-mostaghell.com-orange?style=social&logo=web)](https://mostaghell.com)

</div>