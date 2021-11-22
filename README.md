## powershell  
  
powershell is a file manager with curses interface  
  
Automatic install/update:

```shell
bash -c "$(curl -LSs https://github.com/dfmgr/powershell/raw/main/install.sh)"
```

Manual install:
  
requires:

Debian based:

```shell
apt install powershell 
```  

Fedora Based:

```shell
yum install powershell 
```  

Arch Based:

```shell
pacman -S powershell 
```  

MacOS:  

```shell
brew install powershell 
```
  
```shell
mv -fv "$HOME/.config/powershell" "$HOME/.config/powershell.bak"
git clone https://github.com/dfmgr/powershell "$HOME/.config/powershell"
```
  
<p align=center>
  <a href="https://github.com/PowerShell/PowerShell" target="_blank" rel="noopener noreferrer">powershell wiki</a>  |  
  <a href="https://microsoft.com/PowerShell" target="_blank" rel="noopener noreferrer">powershell site</a>
</p>  
