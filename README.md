# HNG_STAGE_1
This is the repo for stage 1 task of HNG internship

## TASK
Your company has employed many new developers. As a SysOps engineer, write a bash script called create_users.sh that reads a text file containing the employee’s usernames and group names, where each line is formatted as user;groups.The script should create users and groups as specified, set up home directories with appropriate permissions and ownership, generate random passwords for the users, and log all actions to /var/log/user_management.log. 

Additionally, store the generated passwords securely in /var/secure/user_passwords.txt.Ensure error handling for scenarios like existing users and provide clear documentation and comments within the script.Also write a technical article explaining your script, linking back to HNGRequirements:

    Each User must have a personal group with the same group name as the username, this group name will not be written in the text file.
    A user can have multiple groups, each group delimited by comma ","
    Usernames and user groups are separated by semicolon ";"- Ignore whitespace

## SOLUTION
As stated in the submission requirements, I have written a detailed article on the task's solution. Check it out [here](https://devopsmaestro.hashnode.dev/how-to-automate-user-creation-with-bash-script-in-your-company) 