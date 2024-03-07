#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m' 

# Check if highlight log exists, if not create it
if [ ! -f highlight_log.txt ]; then
    touch highlight_log.txt
fi

# Function to check and display users with passwords
display_users_with_passwords() {
    echo "Users with Passwords:"
    while IFS=: read -r username password _; do
        if [[ "$password" != "!" && "$password" != "*" && "$password" != "" ]]; then
            if grep -q "^$username$" highlight_log.txt; then
                echo -e "${RED}$username${NC}"
            else
                echo "$username"
            fi
        fi
    done < /etc/shadow
    echo "" 
}

# Function to display users in groups and specifically highlight new sudo group members
display_users_in_groups_and_highlight_sudo() {
    echo "Users in Groups:"
    local current_sudo_members=$(getent group sudo | cut -d ':' -f4 | tr ',' '\n')
    local previous_sudo_members=$(grep "sudo group members:" original_state.txt | sed 's/sudo group members: //g' | tr ',' '\n')

    declare -A prev_members_map
    for member in $previous_sudo_members; do
        prev_members_map["$member"]=1
    done

    local updated_member_list=""
    for member in $current_sudo_members; do
        if [[ -z "${prev_members_map[$member]}" ]]; then
            echo -e "${RED}$member (new sudo member)${NC}"
            echo "$member" >> highlight_log.txt
        else
            if grep -qw "^$member$" highlight_log.txt; then
                echo -e "${RED}$member${NC}"
            else
                echo "$member"
            fi
        fi
        updated_member_list+="$member,"
    done

    if [ ! -z "$updated_member_list" ]; then
        updated_member_list=${updated_member_list%,} 
        sed -i "/sudo group members:/c\sudo group members: $updated_member_list" original_state.txt
        echo "$(date '+%Y-%m-%d %H:%M:%S') - New sudo member(s): $updated_member_list" >> change_log.txt
    fi

    echo "" 
}
# Function to display and update information
display_and_update_info() {
    echo "Current State:"
    echo "Users:"
    while IFS= read -r line; do
        user_info=$(echo "$line" | cut -d ":" -f1,7)
        if [ ! "$(grep -F "$user_info" original_state.txt)" ]; then
            echo -e "${RED}$user_info${NC}"
            echo "$user_info" >> highlight_log.txt
            echo "$user_info" >> original_state.txt
            echo "$(date '+%Y-%m-%d %H:%M:%S') - New user: $user_info" >> change_log.txt
        elif grep -qw "^$user_info$" highlight_log.txt; then
            echo -e "${RED}$user_info${NC}"
        else
            echo "$user_info"
        fi
    done < <(grep -v '/bin/false\|/usr/sbin/nologin' /etc/passwd)

    display_users_with_passwords
    display_users_in_groups_and_highlight_sudo
}

# Initialize and capture the base configuration if not already done
if [ ! -f original_state.txt ]; then
    echo "Initializing base configuration..."
    touch original_state.txt
    echo "Users:" >> original_state.txt
    grep -v '/bin/false\|/usr/sbin/nologin' /etc/passwd | cut -d ":" -f1,7 >> original_state.txt
    echo "sudo group members: $(getent group sudo | cut -d ':' -f4)" >> original_state.txt
else
    echo "Base configuration already initialized."
    echo ""
fi

echo "Base Configuration:"
cat original_state.txt
echo ""
echo "Monitoring for changes. New entries will be highlighted."

while true; do
    clear
    display_and_update_info
    sleep 10
done
