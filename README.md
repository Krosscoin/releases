# releases
## System and OS Requirements:<br>
1. Windows 10 and above or Ubuntu 18 VPS in case of Linux
2. Minimum 2 cores
3. 2GB RAM
4. 30GB SSD
2. Java version 8 and above must be installed in your VPS. If your windows VPS doesn't have it download it from [Here](https://www.java.com/en/download/) and set java in your [windows environment](https://confluence.atlassian.com/doc/setting-the-java_home-variable-in-windows-8895.html).
## Installing and configuring a Krosschain Platform full node on Windows VPS<br>
 Step 1: Click Here and [Download](https://github.com/Krosscoin/releases/archive/master.zip) the Zip Folder and Unzip it.<br>
 Step 2: Set the configuration file of your node in **mainnet.conf**<br>
Step 3: Click the file inside the folder named as **"start.bat"**

## How to run Node the KSS Node
**Step 1:** Download the [KSS Desktop Wallet](https://github.com/Krosscoin/DesktopWallet/archive/main.zip) and set KSS wallet as custom chain to generate a blank KSS account. (without funds)  
**Step 2:** Notedown the Encoded seed from KSS wallet. (You will required this encoded seed in mainnet.conf)<br>
**Step 3:** Right click the mainnet.conf file and open it in any text editor. (Like notepad in Windows and vi editor incase of Linux)<br>
**Step 4:** Change the below lines in mainnet.conf and save it<br>
a) node-name = "Type Your Node Name Here"<br>
b) declared-address = "127.0.0.1:6860" #declared ip address of your node<br>
c) seed = "Enter_Your_Encoded_Seed_Here_From_KSS_Wallet" <br>
d) password = "Enter any Random Password Here to protect your wallet" #Etner the Strong password to protect your Wallet<br>
e) save the mainnet.conf file after making above changes <br>
f) run the file start.bat and node must start downloading the block.<br>
