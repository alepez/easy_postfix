Easy Postfix
============

Help mantaining Postfix configurations.

## Virtual and Domains

Create database directory

    mkdir db
    cd db

Create domain directory    
    
    mkdir example.com
    cd example.com

Create *info* list and add some users

    echo jondoe@example.com >> info
    echo alice@example.com >> info

Update /etc/postfix/virtual and /etc/postfix/domains

    sudo ./easy_postfix.rb
    sudo postmap /etc/postfix/virtual /etc/postfix/domains
