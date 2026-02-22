# Shell Login 2 Factor Authentication With Data Encryption

## 💡 Introduction

This project implements a two-factor authentication (2FA) system for shell login, utilizing data encryption to enhance security. The 2FA system requires users to provide a passkey after user password authentication, before granting access to the shell, ensuring that only authorized users can log in. The data encryption component ensures that sensitive information, such as user credentials and authentication tokens, is securely stored and transmitted.

## 🔥 Features

- Two-factor authentication for shell login
- Data encryption for secure storage and transmission of sensitive information

## 💻 Installation

- **Clone the repository:**

```bash
git clone https://github.com/Alpinine99/2f-encryption.git
cd 2f-encryption
```

- **Install the required dependencies:**

| tool                | description               |
| ------------------- | ------------------------- |
| `make`              | Build automation tool     |
| `cryptsetup`        | Disk encryption utility   |
| `file`              | File type identification  |
| `shc`               | Shell script compiler     |
| `which`             | Command locator           |

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y make cryptsetup file
```

```bash
# CentOS/RHEL
sudo yum install -y make cryptsetup file which
```

Now installing `shc` which is not available in the default repositories of most distributions, you can either install it from a third-party repository or build it from source.

```bash
# Ubuntu specific
sudo add-apt-repository ppa:neurobin/ppa
sudo apt-get update
sudo apt-get install shc
```

```bash
# Any other distribution
# Install shc from source
git clone https://github.com/neurobin/shc.git
cd shc
./configure
make
sudo make install
```

In any case if you have issues with make execute the following:

```bash
# If you have issues with shc installation from source, you can:
sudo apt-get update
sudo apt-get install automake
./autogen.sh
make
sudo make install
```

> Make sure to use your distribution's package manager.

- **Run make to build the project:**

```bash
make
```

> **Note:** Ensure you follow the instructions and provide the necessary information when prompted during the build process.

- **Install the compiled binary:**

```bash
# No sudo as the binary is user specific and owned by the user not root
make install
```

> For stealth you can delete the image information file on the folder `YOUR_MOUNTPATH/backup/about.txt` although it does contain some useful information about your image file.

![make output](/res/image.png)

- **Configure the user's path to include the binary:**

```bash
# Bash users
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Zsh users
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

> As of now you can call `mapperx` to decrypt and mount your data and `umapperx` to unmount and encrypt your data.

- **Configure for automatic mounting on login:**

```bash
nano ~/.bashrc # bash users
```

```bash
nano ~/.zshrc # zsh users
```

At the top of the file, add the following lines:

```bash
# Make sure to add this to distinguish between login and non-login shells to avoid issues with scp and rsync for those using ssh
# These lines might be present already just paste the rest below
case $- in
    *i*) ;;
      *) return;;
esac

if [ -o login ]; then
    $HOME/.local/bin/mapperx
    [ $? -ne 0 ] && logout
fi
```

- **Configure for automatic unmounting on logout:**

```bash
nano ~/.bash_logout # bash users
```

```bash
nano ~/.zlogout # zsh users
```

Add the following line at the end of the file:

```bash
$HOME/.local/bin/umapperx
```

- **Bypass sudo for `sync`, `mount`, `umount`, and `cryptsetup` commands:**

```bash
# Create a sudoers file for the user
sudo visudo -f /etc/sudoers.d/mapperx

# Add the following line to allow the user to run the necessary commands without a password
username ALL=(ALL) NOPASSWD: /bin/sync, /bin/mount, /bin/umount, /usr/sbin/cryptsetup
```

> **Note:** Replace `username` with your actual username. This configuration allows the user to execute the specified commands without being prompted for a password, which is necessary for the automatic mounting and unmounting processes to work seamlessly during login and logout. Also use `which` to find the correct paths for the commands if they are different on your system.

![login output](/res/image2.png)

## 🕹️ Usage

- **To manually mount and decrypt data:**

```bash
mapperx
```

- **To manually unmount and encrypt data:**

```bash
umapperx
```

- **Help menu:**

```bash
mapperx -h
```

```bash
umapperx -h
```

- **Usage examples:**

```bash
# To mount and decrypt data from a specific image file
mapperx -p /path/to/image.img
```

```bash
# To dump decryption key
mapperx -p /path/to/image.img -d dumpfile.txt   # Specific image file
mapperx -d dumpfile.txt                         # Default image file
```

```bash
# To pass the passkey directly as an argument (not recommended for security reasons)
mapperx -p /path/to/image.img -k your_passkey   # Specific image file
mapperx -k your_passkey                         # Default image file
```

```bash
# To get binary mount point
mapperx -m
```

```bash
# To unmount and encrypt data from a specific image file
umapperx -p /path/to/mountpoint
```

- **Important:** The `mapperx` binary is only compatible with the user who compiled it, and it will not work for other users on the system. This is because the binary is designed to confirm the user id before producing any output and for any other user there is no output apart from return code 1.

## 🕵️‍♀️ Security Considerations

- Ensure that the passkey used for 2FA is stored as there is no passkey backup and you'll lose access to your encrypted data if you forget it.

- Don't lose the binary or run make uninstall if you still have sensitive data encrypted as that will also result in loss of access to your encrypted data.

- Don't setup encryption on root as you can easily lock yourself out of your system if you forget the passkey or if there are issues with the 2FA system, instead change files permissions for root sensitive data.

## 🚮 Uninstallation

- **To uninstall the project:**

```bash
# Backup your encryption key
mapperx -d backup_key.txt

# Move to the project directory
cd 2f-encryption
make uninstall
```

> **Note:** Uninstalling the project will not delete your encrypted data, but you will lose access to it if you uninstall without decrypting it first. Make sure to decrypt your data before uninstalling if you want to retain access to it.

<details>
<summary>

## 🛡️ Bypass 2FA Authentication

</summary>

### In case you are locked out of your account due to issues with the 2FA system or if you forget your passkey, you can bypass the 2FA authentication by following these steps

- **Open a login shell and use `ctrl+c` to interrupt the 2FA prompt**

This will not configure your terminal and nor will it decrypt your data but it will allow you to log in and access your shell. You can then troubleshoot the issue else if your intension was not to mount and decrypt your data well and good.

- **Else if no prompt and logs you out immediately then you can login as root and reconfigure the 2FA system**

Start by commenting out the lines you added to your shell configuration file for login validation and logout unmounting, then you can login normally and troubleshoot the issue with the 2FA system. After fixing the issue you can uncomment the lines to re-enable the 2FA system.

```bash
nano ~/.bashrc  # bash users
```

```bash
nano ~/.zshrc   # zsh users
```

```bash
# Comment out the lines for login validation
#if [ -o login ]; then
#    $HOME/.local/bin/mapperx
#    [ $? -ne 0 ] && logout
#fi
```

```bash
nano ~/.bash_logout # bash users
```

```bash
nano ~/.zlogout # zsh users
```

```bash
# Comment out the line for logout unmounting
#$HOME/.local/bin/umapperx  
```

</details>

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
