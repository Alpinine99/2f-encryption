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

# CentOS/RHEL
sudo yum install -y make cryptsetup file which

# Ubuntu specific
sudo add-apt-repository ppa:neurobin/ppa
sudo apt-get update
sudo apt-get install shc

# Elsewhere
# Install shc from source
git clone https://github.com/neurobin/shc.git
cd shc
./configure
make
sudo make install
```

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
# bash users
nano ~/.bashrc

# zsh users
nano ~/.zshrc

# Add the following lines at the top of the file for login validation
if [ -o login ]; then
    $HOME/.local/bin/mapperx
    [ $? -ne 0 ] && logout
fi
```

- **Configure for automatic unmounting on logout:**

```bash
# bash users
nano ~/.bash_logout

# zsh users
nano ~/.zlogout

# Add the following line at the bottom of the file to unmount and encrypt data on logout
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

## 🕵️‍♀️ Security Considerations

- Ensure that the passkey used for 2FA is stored as there is no passkey backup and you'll lose access to your encrypted data if you forget it.

- Don't lose the binary or run make uninstall if you still hav sensitive data encrypted as that will also result in loss of access to your encrypted data.

- Don't setup encryption on root as you can easily lock yourself out of your system if you forget the passkey or if there are issues with the 2FA system, instead change files permissions for root sensitive data.

## 🚮 Uninstallation

- **To uninstall the project:**

```bash
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
nano ~/.zshrc   # zsh users

# Comment out the lines for login validation
#if [ -o login ]; then
#    $HOME/.local/bin/mapperx
#    [ $? -ne 0 ] && logout
#fi

nano ~/.bash_logout # bash users
nano ~/.zlogout # zsh users

# Comment out the line for logout unmounting
#$HOME/.local/bin/umapperx  
```

</details>

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
