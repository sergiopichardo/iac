add-content -path c:/users/sergio/.ssh/config -value @'

Host ${hostname}
    Hostname ${hostname}
    User ${user}
    IdentityFile ${identityfile}
'@