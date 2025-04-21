#!/bin/bash
####################################
####   M E N U    D I A L O G   ####
####################################
####     Niezbędne pakiety:     #### 
####  dialog, gnome-screenshot  ####
####################################
####    (c) Mateusz Makaryk     ####
####################################

options=(
    1  "Wyświetl logo Ascii"
    2  "Wyświetl użytkowników"
    3  "Wyświetl do jakich grup należy Twój użytkownik"
    4  "Wyświetl listę katalogów systemowych"
    5  "Zmiana daty"  
    6  "Zmiana czasu"
    7  "Pliki TMP"
    8  "Wyświetl informacje jak długo system jest uruchomiony"
    9  "Utwórz komunikat który będzie wyświetlać się raz dziennie"
    10 "Wyświetl konfigurację kart sieciowych"
    11 "Zmiana konfiguracji karty sieciowej"
    12 "Wyświetl ilość miejsca wolnego na dysku"
    13 "Zmień umask na wprowadzony"
    14 "Sprawdz umask"  
    15 "Zablokuj wybrane konto"  
    16 "Znajdź pliki większe niż x i wyświetl z numeracją wierszy"
    17 "Zrób zrzut ekranu i zapisz na Pulpit"  
    18 "Wylogowanie użytkownika"
    19 "Wyłączenie komputera"  
    20 "test inf02"
    21 "Wyjście"
)      
         
function glowne() {
    choices=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --menu "(c)Mateusz Makaryk Dialog" 26 120 20 "${options[@]}" 2>&1 >/dev/tty)
    for option in $choices; do    
        case $option in
            1)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --infobox "  
                ────█▀█▄▄▄▄─────██▄  
                ────█▀▄▄▄▄█─────█▀▀█  
                ─▄▄▄█─────█──▄▄▄█    
                ██▀▄█─▄██▀█─███▀█      
                ─▀▀▀──▀█▄█▀─▀█▄█▀ " 12 25
                sleep 4
                ;;
            2)
                users=$(who | cut -d' ' -f1 | sort | uniq)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Lista użytkowników" --msgbox "$users" 20 70
                ;;
            3)
                obecnyuz=$(id -Gn $USER | tr ' ' '\n')
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Grupy do jakich należy $USER:" --msgbox "$obecnyuz" 20 70
                ;;
            4)
                srodowiska=$(ls -la /usr/share/ | head -20)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Katalogi systemowe:" --msgbox "$srodowiska" 20 70  
                ;;
            5)
                data=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Ustaw datę" --inputbox "Wprowadź datę (format YYYY-MM-DD)" 10 30 2>&1 >/dev/tty)
                if [ -n "$data" ]; then
                    # Try to set date in a format that works across systems
                    if sudo date -s "$data" 2>/dev/null; then
                        dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Sukces" --msgbox "Data została pomyślnie ustawiona na $data." 10 50
                    else
                        dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Błąd" --msgbox "Nie udało się ustawić daty. Sprawdź poprawność formatu daty i uprawnienia." 10 50
                    fi
                else
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Błąd" --msgbox "Nie wprowadzono daty!" 10 30
                fi
                ;;
            6)
                godzina=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Ustaw godzinę" --inputbox "Wprowadź godzinę (format HH:MM:SS)" 10 30 2>&1 >/dev/tty)
                if [ -n "$godzina" ]; then
                    if sudo date +%T -s "$godzina" 2>/dev/null; then
                        dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Sukces" --msgbox "Godzina została pomyślnie ustawiona na $godzina." 10 50
                    else
                        dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Błąd" --msgbox "Nie udało się ustawić godziny. Sprawdź poprawność formatu godziny i uprawnienia." 10 50
                    fi
                else
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Błąd" --msgbox "Nie wprowadzono godziny!" 10 30
                fi
                ;;
            7)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Pliki TMP" --msgbox "$(ls -l /tmp)" 20 70
                dialog --backtitle "(c) Mateusz Makaryk dialog" --yesno "Czy chcesz usunąć wszystkie pliki tymczasowe?" 10 30
                response=$?
                if [ $response -eq 0 ]; then
                    sudo rm -rf /tmp/*
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Sukces" --msgbox "Pliki tymczasowe zostały usunięte." 10 50
                else
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Informacja" --msgbox "Nie usunięto plików tymczasowych." 10 50
                fi
                ;;
            8)
                uptime_info=$(uptime)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Czas pracy systemu" --msgbox "$uptime_info" 10 50
                ;;
            9)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Ustawienie przypomnienia" --yesno 'Czy chcesz dodać przypomnienie w cronie: "Kocham systemy operacyjne :D"? \nBędzie on wyświetlany codziennie o 8:00 rano.' 0 0
                yn=$?
                case $yn in
                0) 
                    (crontab -l 2>/dev/null; echo "0 8 * * * echo 'Kocham systemy operacyjne :D' >> $HOME/reminder_log.txt") | crontab -
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Przypomnienie zostało ustawione. Będzie zapisywane do pliku $HOME/reminder_log.txt codziennie o 8:00" 0 0 
                    ;;
                1) 
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Komunikat nie został ustawiony" 0 0 
                    ;;
                esac
                ;;
            10)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Konfiguracja kart sieciowych" --msgbox "$(ifconfig 2>/dev/null || ip addr)" 30 80
                ;;
            11)
                if command -v ip >/dev/null 2>&1; then
                    karty_sieciowe=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo)
                else
                    karty_sieciowe=$(ifconfig -l 2>/dev/null | tr ' ' '\n' | grep -v lo)
                fi
                
                wybrana_karta=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --menu "Wybierz kartę sieciową" 20 60 10 $(
                    for karta in $karty_sieciowe; do
                        echo "$karta" ""
                    done) 2>&1 >/dev/tty)

                if [ -n "$wybrana_karta" ]; then
                    operacja=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --menu "Operacje na karcie sieciowej $wybrana_karta" 20 60 10 \
                        "Ustaw adres IP" "" \
                        "Ustaw nową maskę podsieci" "" \
                        "Ustaw bramę domyślną" "" \
                        "Ustaw serwer DNS" "" \
                        "Powrót" "" 2>&1 >/dev/tty)

                    case $operacja in
                        "Ustaw adres IP")
                            nowe_ip=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --inputbox "Podaj nowy adres IP:" 8 40 2>&1 >/dev/tty)
                            if [ -n "$nowe_ip" ]; then
                                sudo ifconfig $wybrana_karta inet $nowe_ip 2>/dev/null || sudo ip addr add $nowe_ip dev $wybrana_karta 2>/dev/null
                                dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Próba ustawienia IP: $nowe_ip" 8 40
                            fi
                            ;;
                        "Ustaw nową maskę podsieci")
                            nowa_maska=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --inputbox "Podaj nową maskę podsieci:" 8 40 2>&1 >/dev/tty)
                            if [ -n "$nowa_maska" ]; then
                                sudo ifconfig $wybrana_karta netmask $nowa_maska 2>/dev/null
                                dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Próba ustawienia maski: $nowa_maska" 8 40
                            fi
                            ;;
                        "Ustaw bramę domyślną")
                            nowa_brama=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --inputbox "Podaj nową bramę domyślną:" 8 40 2>&1 >/dev/tty)
                            if [ -n "$nowa_brama" ]; then
                                sudo route add default gw $nowa_brama 2>/dev/null || sudo ip route add default via $nowa_brama 2>/dev/null
                                dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Próba ustawienia bramy: $nowa_brama" 8 40
                            fi
                            ;;
                        "Ustaw serwer DNS")
                            nowy_dns=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --inputbox "Podaj nowy serwer DNS:" 8 40 2>&1 >/dev/tty)
                            if [ -n "$nowy_dns" ]; then
                                dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Aby ustawić DNS, należy edytować plik resolv.conf.\nPodano serwer: $nowy_dns" 8 50
                            fi
                            ;;
                        *)
                            ;;
                    esac
                fi
                ;;
            12)
                df_output=$(df -h)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Ilość miejsca wolnego na dysku" --msgbox "$df_output" 20 70
                ;;
            13)
                umask_value=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Zmień umask" --inputbox "Wprowadź nową wartość umask:" 10 30 2>&1 >/dev/tty)
                if [ -n "$umask_value" ]; then
                    umask $umask_value
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Ustawiono nową wartość umask: $umask_value" 10 40
                fi
                ;;
            14)
                umask_value=$(umask)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Wartość umask" --msgbox "Aktualna wartość umask: $umask_value" 0 0
                ;;
            15)
                bloknijuz=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --inputbox "Podaj nazwę użytkownika do zablokowania:" 0 0 2>&1 >/dev/tty)

                if id "$bloknijuz" &>/dev/null; then
                    bloknij=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --menu "Wybierz akcję:" 0 0 0 1 "Zablokuj konto" 2>&1 >/dev/tty)
                   
                    case $bloknij in
                        1)
                            sudo passwd -l "$bloknijuz" 2>/dev/null || sudo usermod -L "$bloknijuz" 2>/dev/null
                            dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Próba zablokowania użytkownika: $bloknijuz" 0 0
                            ;;
                        *)
                            dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Anulowano lub wybrano nieprawidłową opcję." 0 0
                            ;;
                    esac
                else
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --msgbox "Podany użytkownik nie istnieje." 0 0
                fi
                ;;
            16)
                x=$(dialog --backtitle "(c) Mateusz Makaryk dialog" --inputbox "Podaj rozmiar pliku w bajtach:" 8 40 2>&1 >/dev/tty)
                if [ -n "$x" ]; then
                    find . -type f -size +${x}c 2>/dev/null | awk '{print NR, $0}' > /tmp/plikczasowy
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --textbox /tmp/plikczasowy 0 0
                    rm /tmp/plikczasowy
                fi
                ;;
            17)
                if command -v gnome-screenshot >/dev/null 2>&1; then
                    gnome-screenshot -f ~/Desktop/screenshot.png
                elif command -v import >/dev/null 2>&1; then
                    import -window root ~/Desktop/screenshot.png
                elif command -v screencapture >/dev/null 2>&1; then
                    screencapture -x ~/Desktop/screenshot.png
                else
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Błąd" --msgbox "Nie znaleziono narzędzia do zrzutów ekranu. Zainstaluj gnome-screenshot, imagemagick lub podobne." 10 50
                    glowne
                    continue
                fi
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Zrzut ekranu" --msgbox "Zrzut ekranu został zapisany na pulpicie jako 'screenshot.png'" 10 50
                ;;
            18)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Uwaga" --yesno "Czy na pewno chcesz się wylogować?" 10 30
                if [ $? -eq 0 ]; then
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Uwaga" --msgbox "Zostaniesz wylogowany za 5 sekund!" 10 30
                    sleep 5
                    if [ -n "$DISPLAY" ]; then
                        pkill -KILL -u $USER &
                    else
                        sudo pkill -KILL -u $USER &
                    fi
                fi
                ;;
            19)
                dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Uwaga" --yesno "Czy na pewno chcesz wyłączyć komputer?" 10 30
                if [ $? -eq 0 ]; then
                    dialog --backtitle "(c) Mateusz Makaryk dialog" --title "Uwaga" --msgbox "Komputer zostanie wyłączony za 10s!" 10 30
                    sleep 10
                    sudo shutdown -h now 2>/dev/null || sudo poweroff 2>/dev/null || sudo halt 2>/dev/null
                fi
                ;;  
            20)
                function ask_question {
                    local question="$1"
                    local answer1="$2"
                    local answer2="$3"
                    local answer3="$4"
                    local answer4="$5"
                    local correct_answer="$6"
                    local user_answer

                    user_answer=$(dialog --backtitle "(c) Egzamin INF02 Mateusz Makaryk" \
                                         --title "Pytanie" \
                                         --menu "$question" 0 0 0 \
                                         1 "$answer1" \
                                         2 "$answer2" \
                                         3 "$answer3" \
                                         4 "$answer4" \
                                         2>&1 >/dev/tty)

                    if [[ "$user_answer" == "$correct_answer" ]]; then
                        dialog --backtitle "(c) Egzamin INF02 Mateusz Makaryk" \
                               --title "Odpowiedź" \
                               --msgbox "Poprawna odpowiedź!" 0 0
                        return 1
                    else
                        dialog --backtitle "(c) Egzamin INF02 Mateusz Makaryk" \
                               --title "Odpowiedź" \
                               --msgbox "Zła odpowiedź!" 0 0
                        return 0
                    fi
                }

                start_time=$(date +%s)

                # Pytanie 1
                ask_question "Użytkownik systemu Windows otrzymuje komunikaty o zbyt małej pamięci wirtualnej. Problem ten można rozwiązać przez:" \
                              "zamontowanie dodatkowej pamięci cache procesora." \
                              "zwiększenie rozmiaru pliku virtualfilr.sys." \
                              "zamontowanie dodatkowego dysku." \
                              "zwikszenie pamięci RAM." \
                              4
                question1_result=$?

                # Pytanie 2
                ask_question "W systemach operacyjnych Windows ograniczenie użytkownikom dostępu do poszczególnych katalogów, plików lub dysków umożliwia system plików:" \
                              "FAT16" \
                              "FAT32" \
                              "NTFS" \
                              "EXT3" \
                              3
                question2_result=$?

                # Pytanie 3
                ask_question "W celu dokonania aktualizacji zainstalowanego systemu operacyjnego Linux Ubuntu należy użyć polecenia:" \
                              "yum upgrade" \
                              "kernel upgrade" \
                              "system upgrade" \
                              "apt-get upgrade" \
                              4
                question3_result=$?

                # Pytanie 4
                ask_question "W systemie operacyjnym Fedora katalogi domowe użytkowników umieszczone są w katalogu:" \
                              "/bin" \
                              "/users" \
                              "/user" \
                              "/home" \
                              4
                question4_result=$?

                # Pytanie 5
                ask_question "W systemie operacyjnym Ubuntu konto użytkownika student można usunąć za pomocą polecenia:" \
                              "userdel student" \
                              "del user student" \
                              "net user student /del" \
                              "user net student /del" \
                              1
                question5_result=$?

                end_time=$(date +%s)
                duration=$((end_time - start_time))

                total_points=$((question1_result + question2_result + question3_result + question4_result + question5_result))

                dialog --backtitle "(c) Egzamin INF02 Mateusz Makaryk" --title "Podsumowanie" --msgbox "Czas rozwiązania egzaminu: $duration sekund.\nZdobyte punkty: $total_points na 5." 0 0
                ;;
            21)
                clear
                exit 0
                ;;
        esac
    done
    glowne                
}
glowne