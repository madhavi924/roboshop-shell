script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head() {
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<\e[0m"
  }