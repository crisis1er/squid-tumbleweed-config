# D I S C L A M E R

Please read this before proceeding

## Context and Objective:

This project sets up a caching proxy to enhance request speed while optimizing multimedia content. It also ensures confidentiality and security through SSL certificates, while incorporating ad-blocking features.

## Installation Instructions:

The squid.conf file is optimized for OpenSUSE Tumbleweed and can also be used to improve an existing Squid installation. The README provides installation guidance for OpenSUSE, but it is essential to check the command practices for other operating systems to avoid errors. Well-commented and structured, the file also aids in troubleshooting.

## Configuration

Key installation points include creating the cache with the command "squid -z," which may not provide a return to the user. If this occurs, you will need to perform a Ctrl+Z to complete the operation and then restart the system for the cache to take effect. Ensure that you correctly set the properties and permissions for the directories and files, and it may be necessary to convert the certificate to bump.p12 to include the key.

## Contribution:

You can contribute to improving the project or adapting it for your own distribution based on DEB, RPM, or INDEPENDENT formats.

## Contact:

GitHub or email.
