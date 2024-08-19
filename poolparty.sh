#!/bin/bash

YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

#*==================================================================
#*			  Fonction pour renommer les dossiers / fichiers
#*==================================================================

rename_item() {
    local old_name="$1"
    local new_name="$2"
    
    # Vérifier si le fichier ou le répertoire cible existe déjà
    if [ -e "$new_name" ]; then
        echo -e "${RED}\nErreur : '$new_name' existe déjà. Veuillez fournir un autre nom.${RESET}"
        return 1
    fi
    
    # Vérifier si le fichier ou le répertoire source existe avant de tenter de le renommer
    if [ -e "$old_name" ]; then
        echo -e "${YELLOW}Renommage de '$old_name' en '$new_name'${RESET}"
        mv "$old_name" "$new_name"
        
        # Vérifier si le nouvel élément est un répertoire ou un fichier
        if [ -d "$new_name" ]; then
            echo -e "${GREEN}Le répertoire a été renommé avec succès.${RESET}"
        elif [ -f "$new_name" ]; then
            echo -e "${GREEN}Le fichier a été renommé avec succès.${RESET}"
        else
            echo -e "${RED}Erreur : '$new_name' n'a pas pu être renommé.${RESET}"
        fi
    fi
    return 0
}

#*==================================================================
#*						Gestion dessin ASCII
#*==================================================================

# Fonction pour générer une couleur aléatoire
random_color() {
    local color=$((31 + RANDOM % 7)) # 31 à 37 pour les couleurs de base
    echo -e "$color"
}

# Lire le fichier ligne par ligne
while IFS= read -r line; do
    index=0
    while [ $index -lt ${#line} ]; do
        char="${line:$index:2500}"
        color=$(random_color)
        # Utiliser printf pour éviter l'affichage incorrect des séquences d'échappement
        printf "\e[${color}m%s\e[0m" "$char"
        ((index += 2500))
    done
    echo -e # Passe à la ligne suivante
    sleep 0.05
done < $HOME/Documents/Pool_Party/drawing.txt


echo -e "${YELLOW}"
echo -e "Verification du dossier racine"
i=0
while [ $i -ne 31 ]; do
  echo -n "-"
  i=$((i + 1))
  sleep 0.02
done
echo -e "\n"


# Obtenir le nom du dossier courant
current_directory=$(basename "$PWD")

# Vérifier que le nom du dossier commence par "C" suivi de deux chiffres
if [[ $current_directory =~ ^C[0-9]{2}$ ]]; then
  echo -e "${GREEN}Le dossier courant ($current_directory) est valide.${RESET}"
else
  echo -e "${RED}Le dossier courant ($current_directory) n'est pas valide. Il doit commencer par 'C' suivi de deux chiffres.${RESET}"
  exit -1
fi
echo -e "\n\n"

#*=============================================================================================
#*					Verification si le dossier ne contient que des exXX
#*=============================================================================================

all_directories=$(ls)
valid=1
check=1

echo -e "${YELLOW}"
echo -e "Verification des noms des sous-dossiers"
i=0
while [ $i -ne 40 ]; do
  echo -n "-"
  i=$((i + 1))
  sleep 0.02
done
echo -e "\n"

for dir in $all_directories; do
  if [[ ! "$dir" =~ ^ex[0-9]{2}$ ]]; then
    echo -e "${RED}$dir n'est pas un dossier valide, ou n'est pas un dossier${RESET}"
    valid=0
    while [ $check -eq 1 ]; do
      echo -e "${YELLOW}Entrez le nouveau nom pour le dossier '$dir' : ${RESET}"
      read -p "" new_name
      rename_item "$dir" "$new_name"
      check=$?
    done
    check=1
  fi
done

if [[ $valid -eq 1 && -n "$all_directories" ]]; then
  echo -e "${GREEN}Le dossier courant ne contient que des dossiers valides.${RESET}"
elif [[ ! -n "$all_directories" ]]; then
  echo -e "${RED}Le dossier courant est vide${RESET}"
  exit -1
else
  exit -1
fi
echo -e "\n\n"


#*=============================================================================================
#*					Verification du contenu des sous-dossiers
#*=============================================================================================

check=1

echo -e "${YELLOW}"
echo -e "Verification du contenu des sous-dossiers"
i=0
while [ $i -ne 42 ]; do
  echo -n "-"
  i=$((i + 1))
  sleep 0.02
done
echo -e "\n"

# Boucle à travers tous les sous-dossiers
for dir in */; do
    # Compter le nombre de fichiers dans le sous-dossier
    file_count=$(find "$dir" -type f | wc -l)

    # Vérifier s'il y a un seul fichier et s'il est un fichier .c
    if [ "$file_count" -eq 1 ] && find "$dir" -type f | grep -q '\.c$'; then
        check=$check
    elif [ "$file_count" -eq 0 ]; then
        echo -e "${RED}Le dossier $dir est vide${RESET}"
        exit -1
    else
        echo -e "\n${RED}Le dossier $dir ne satisfait pas les conditions${RESET}\n"

        # Trouver et afficher les fichiers qui ne sont pas des .c
        non_c_files=$(find "$dir" -type f ! -name '*.c')

        if [ -n "$non_c_files" ]; then
            echo -e "${RED}Fichiers non .c trouvés dans $dir : ${RESET} "
            echo -e "${RED}$non_c_files${RESET}\n"

            # Demander à l'utilisateur s'il souhaite supprimer ces fichiers
            echo -e "${YELLOW}Souhaitez-vous supprimer ce(s) fichier(s) ? (o/n) ${RESET}"
            read -p "" response
            if [[ "$response" == "o" ]]; then
                echo -e "$non_c_files" | xargs rm
                echo -e "\n${GREEN}Fichiers supprimés.${RESET}"
                file_count=$(find "$dir" -type f | wc -l)
                if [ "$file_count" -eq 0 ]; then
                  echo -e "\n${RED}Le dossier $dir est vide${RESET}\n"
                  exit -1
                fi
            fi
        fi
        check=-1
    fi
done
if [ $check -eq 1 ]; then
    echo -e "${GREEN}Tous les sous dossiers sont bons${RESET}"
fi
echo -e "\n\n"

#*=============================================================================================
#*				                    	Application du chmod 777
#*=============================================================================================

echo -e "${YELLOW}"
echo -e "Application du chmod 777 a chaque fichier"
i=0
while [ $i -ne 42 ]; do
  echo -n "-"
  i=$((i + 1))
  sleep 0.02
done
echo -e "\n"

for dir in */; do
    # Appliquer chmod 777 à tous les fichiers dans le sous-dossier
    find "$dir" -type f -exec chmod 777 {} \;
done

echo -e "${GREEN}Permissions 777 appliquées à tous les fichiers${RESET}\n\n\n"

#*=============================================================================================
#*				                    	Verification de printf
#*=============================================================================================

echo -e "${YELLOW}"
echo -e "Verification de l'utilisation de printf"
i=0
while [ $i -ne 40 ]; do
  echo -n "-"
  i=$((i + 1))
  sleep 0.02
done
echo -e "\n"

for dir in */; do
  # Chercher tous les fichiers dans le répertoire et vérifier s'ils contiennent "printf"
  while IFS= read -r file; do
    if grep -q "printf" "$file"; then
      echo -e "${RED}$file contient au moins un printf${RESET}"
      exit -1
    fi
  done < <(find "$dir" -type f)
done
echo -e "${GREEN}Aucun fichier ne contient un printf${RESET}"
echo -e "\n\n"

#*=============================================================================================
#*				                    	Verification de la norme
#*=============================================================================================

echo -e "${YELLOW}"
echo -e "Verification de la norme"
i=0
while [ $i -ne 25 ]; do
  echo -n "-"
  i=$((i + 1))
  sleep 0.02
done
echo -e "${PURPLE}\n"

norminette
echo -e "${RESET}\n"
#*=============================================================================================
#*				                    	Verification du git
#*=============================================================================================

echo -e "${YELLOW}"
echo -e "Verification du git"
i=0
while [ $i -ne 20 ]; do
  echo -n "-"
  i=$((i + 1))
  sleep 0.02
done
echo -e "${BLUE}\n"

git status
echo -e "${RESET}"