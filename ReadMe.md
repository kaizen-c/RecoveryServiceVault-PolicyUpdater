# Introduction

This script can be used to update Recovery Services Vault policies within Azure. 

## Usage

1. First Download both powershell scripts and the csv file to a windows machine where you have AzPowershell installed. Required modules would be 

*  1.9.1      Az.Accounts 
* 2.11.0     Az.RecoveryServices

2. Then run 01_RSV_PolicyReader.ps1 script while being inside a powershell ISE session which will help you to quickly troubleshoot any errors. This script will generate a csv file (RSVPolicyNames.csv) while looping through each and every azure vm you have access and get the policy name associated to each vm. 

3. Once that's completed you need to run the second script (02_RSVPolicyUpdater.ps1) to update the azure policy for each vm. Policy updation script will do following activities.

* Update scheduleRunFrequency from weekly to daily
* Enable Daily schedule

Once you run the second script it will create a PolicyUpdatedCustomerList.csv file with the results. 



## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)