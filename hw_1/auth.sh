#!/bin/bash
exec 2>auth_errors
while [[ 1 -eq 1 ]]
do
    echo "Введите логин: " 
    read user_login
    flag=0
    while read login
    do
        if [[ $flag -eq 2 ]]
        then
            password=$login
            flag=1
        fi
        if [[ $user_login == $login ]]
        then
            flag=2
        fi
    done < database
    if [[ $flag -eq 0 ]]
    then
        echo "Такого логина не существует. Попробуйте ещё раз!"
        echo "Логина: $user_login не существует. Попробуйте ещё раз!">&2
    else
        new_flag=0
        attemption=0
        while [[ $attemption -ne 3 ]]
        do
            echo "Введите пароль: " 
            read -t 10 -s user_password
            echo "$user_password" |md5sum >user_pass
            check=0
            while read ps
            do
                check=$ps
            done <user_pass
            if [[ $check == $password ]]
            then
                new_flag=1
            fi
            if [[ $new_flag -eq 1 ]]
            then
                echo 'Вы успешно вошли!'
                break
            else
                attemption=$(($attemption+1))
                echo "Неверный пароль попыток осталось $((3-$attemption))!"
                echo "Пользователь $user_login ввёл неверный пароль попыток осталось $((3-$attemption))!" >&2
            fi
        done
        if [[ $attemption -eq 3 ]]
        then
            echo "Неуспешная авторизация!"
            echo "Пользователь $user_login не смог авторизироваться!" >&2
        fi
        break
    fi
done