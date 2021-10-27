# devops-netology
Благодаря добавленному файлу .gitignore в будущем будут проигнорированы некоторые конфигурационные файлы терраформ, а именно файлы и каталоги:
**/.terraform/* - будет проигнорировано все содержимое директории .terraform, независимо от того где находится сама директория (** перед названием директории - означает любой уровень вложенности, то есть директория .terraform может находиться внутри любой другой директории и с любым количеством вложенных директорий). /* - после названия директории означает любой файл в этой директории (0 и более символов).

*.tfstate
*.tfstate.* - исключаются все файлы заканчивающиеся на .tfstate либо имеющие в середине названия слово .tfstate. 

crash.log - исключается из отслеживания гитом конкретный файл с названием crash.log

*.tfvars - исключаются все файлы заканчивающиеся на .tfvars

override.tf - исключается конкретный файл override.tf
override.tf.json - исключается конкретный файл override.tf.json
*_override.tf - исключаются все файлы заканчивающиеся на _override.tf
*_override.tf.json - исключаются все файлы, заканчивающиеся на _override.tf.json

.terraformrc - исключается файл с названием .terraformrc
terraform.rc - исключается файл с названием terraform.rc
