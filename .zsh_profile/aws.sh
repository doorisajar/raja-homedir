# pilfered from https://gitlab.windlogics.com/Jordan.Love/dotfiles

# awsaccid: Get AWS account ID for default or specified profile
awsaccount() {
   if [[ $1 == "-p" ]]
   then
     profile=$2
     aws sts get-caller-identity --output text --profile $profile| cut -f1
   else
     aws sts get-caller-identity --output text | cut -f1
   fi     
}
