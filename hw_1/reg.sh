#!/bin/bash
exec 2>reg_errors
while [[ 1 -eq 1 ]]
do
    end_flag=0
    echo 'Введите логин: '
    read user_login
    user_login_lenght=${#user_login}
    if [[ $user_login_lenght -lt 5 ]]
    then
        echo "Минимальная длина логина 5 символов!"
        echo "Пользователь ввёл логин, длина которого меньше 5!" >&2
    else
        flag=0
        while read login
        do
            if [[ $user_login == $login ]]
            then
                flag=1
            fi
        done < database
        if [[ $flag -eq 0 ]]
        then
            while [[ 1 -eq 1 ]]
            do
                echo "Введите пароль: " 
                read -s user_password
                user_password_lenght=${#user_password}
                if [[ user_password_lenght -lt 8 ]]
                then
                    echo "Длина пароля меньше 8 символов!"
                    echo "Пользователь ввёл пароль, длина которого меньше 8!" >&2
                else
                    echo "$user_login">>database
                    echo "$user_password" | md5sum>>database
                    echo "Вы успешно зарегистрировались!"
                    end_flag=1
                    break
                fi
            done
        else
            echo 'Такой логин уже существует!'
            echo "Логин $user_login уже существует!" >&2
        fi
    fi
    if [[ end_flag -eq 1 ]]
    then
        break
    fi
done

