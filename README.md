# releases
## System and OS Requirements:<br>
1. Windows 11 and above or Ubuntu 24 VPS in case of Linux
2. Minimum 2 cores
3. 4GB RAM
4. 30GB SSD
2. Java version 11 and above must be installed in your VPS. If your windows VPS doesn't have it download it from [Here](https://www.java.com/en/download/) and set java in your [windows environment](https://confluence.atlassian.com/doc/setting-the-java_home-variable-in-windows-8895.html).
## Installing and configuring a Krosschain Platform full node on Windows VPS<br>
 Step 1: Click Here and [Download](https://github.com/Krosscoin/releases/releases/download/v1.5.7/kss-all-1.5.7jar) the node jar file.<br>
 Step 2: Download the [configuration file](https://github.com/Krosscoin/releases/blob/master/mainnet.conf) of your node in **mainnet.conf**<br>
 Step 3: Download the [bat file](https://github.com/Krosscoin/releases/blob/master/start.bat) of your node.<br>
 Step 4: [kss-all-xx.xx.xx.jar , start.bat , mainnet.conf ]  all 3 files should be in same folder, Click the **"start.bat"** to start the node once below part is done.<br>

## How to run Node the KSS Node
**Step 1:** Download the [KSS Desktop Wallet](https://github.com/Krosscoin/DesktopWallet/archive/main.zip) and set KSS wallet as custom chain to generate a blank KSS account. (without funds)  
**Step 2:** Notedown the Encoded seed from KSS wallet. (You will required this encoded seed in mainnet.conf)<br>
**Step 3:** Right click the mainnet.conf file and open it in any text editor. (Like notepad in Windows and vi editor incase of Linux)<br>
**Step 4:** Change the below lines in mainnet.conf and save it<br>
a) node-name = "Type Your Node Name Here"<br>
b) declared-address = "127.0.0.1:6860" #declared ip address of your node<br>
c) seed = "Enter_Your_Encoded_Backup_Seed_Here_From_KSS_Wallet" <br>
d) password = "Enter any Random Password Here to protect your wallet" #Enter the 15 words any Strong password to protect your Wallet<br>
e) save the mainnet.conf file after making above changes <br>
f) run the file start.bat and node must start downloading the block.<br>

## Installing and configuring a Krosschain Platform full node on Linux Server
## System and OS Requirements:<br>
1. Ubuntu 24 VPS in case of Linux<br>
2. Minimum 2 cores<br>
3. 2GB RAM<br>
4. 30GB SSD<br>

## Automatic Way to install node
> sudo wget https://raw.githubusercontent.com/Krosscoin/releases/master/node_automation.sh<br>
> sudo chmod +x node_automation.sh<br> 
> ./node_automation.sh<br>

**Command to Check node is running in background:**
> sudo journalctl --follow --unit kss_node.service --lines 100<br>

**Command to Check running node status in background:**
> sudo systemctl status kss_node.service<br>

**Command to Stop running node in background:**
> sudo systemctl stop kss_node.service<br>

**Command to Delete All KSS node relevent data, Services, Files: (From root level access)**
> sudo rm -rf /opt/kss/ releases-master node_automation.sh /etc/systemd/system/kss_node.service

**Note:** All commands are issued as root. If you do not use your root account most commands would probably require 'sudo' to work. Eg. "sudo apt update"<br>

## Manual Way to install node

**Step 1:** login into Linux server with the root account<br>

**Step 2:** Type Below Command<br>
> sudo apt update<br>
 
**Step 3:** Install Java development kit with following commands<br>
> sudo apt install openjdk-11-jre <br>
> sudo apt install openjdk-11-jdk <br>
> sudo apt update <br>
> sudo update-alternatives --config java

Once its installed check if you have the latest version.
> java -version

**Step 4:** create a screen by entering: sudo screen -S kss_node

Download the latest node version from Krosschain releases repository.<br>
> sudo wget https://github.com/Krosscoin/releases/releases/download/v1.5.7/kss-all-1.5.7.jar<br>

Command to download on Linux Server<br>
> wget https://github.com/Krosscoin/releases/archive/refs/heads/master.zip<br>

Type below command to install Unzip in Linux server and make the required changes in mainnet.conf<br>
> sudo apt-get install unzip<br>
> sudo unzip master.zip<br>
> sudo pwd<br>


> sudo mv kss-all-1.5.7.jar /root/releases-master<br>
**Note** ( replace “/root" with the value of pwd)

> sudo cd releases-master<br>
> sudo dir<br>

**Note:** <code>sudo dir</code> Command works as a Check point to ensure releases-master folder has following files:<br>
<code>README.md , kss-all-1.5.7.jar, mainnet.conf , start.bat</code><br>

**Incase any of above file or kss-all-1.x.xx.jar is missing from current folder then something wrong in last 2 steps**<br>

> screen<br>
> sudo vi mainnet.conf<br>

Press **Insert button** to enable typing and vi editor<br>

**Note:** if something went wrong during typing or don't wanna to save it just press escape and type **:qa!** to exit and use last command **sudo vi mainnet.conf** again)

**Step 5:** Download the [KSS Desktop Wallet](https://github.com/Krosscoin/DesktopWallet/archive/main.zip) in your Windows PC or Laptop or go to https://webwallet.krosscoin.io and save your Encoded backup seed to use in mainnet.conf

**Step 6:** Change the below lines in mainnet.conf and save it<br>
a) <code>node-name = "Type Your Node Name Here"</code><br>
b) <code>declared-address = "127.0.0.1:6860" #declared ip address of your node</code><br>
c) <code>seed = "Enter_Your_Encoded_Backup_Seed_Here_From_KSS_Wallet"</code><br>
d) <code>password = "Enter any Random Password Here to protect your wallet" #Enter the 15 words any Strong password to protect your Wallet</code><br>
e) <code>Use below command to save or write the channges in mainnet.conf file</code><br>

Press Escape button and type below command and press enter 
>:wq

Start the node with following command:
>java -jar kss-all-1.5.7.jar mainnet.conf 

Node will start downloading and synching the blockchain. If any error during starting of node means something wrong input in mainnet.conf

When blocks are synched then you can deattach the screen by pressing **CTRL+d** and close the window. Node has been set to run in background process of Linux VPS.

Good Luck and Enjoy the Mining and Leasing of KSS.
