#!/usr/bin/env bash

while getopts d: option
do
    case "${option}"
    in
        d) APP_DIR_PATH=${OPTARG};;
    esac
done


echo "Building SA3 directory structure"

# Build siteadmin directory structure
mkdir -p "${APP_DIR_PATH}"

cd "${APP_DIR_PATH}"
declare -a sa_directories=(
    "html"
    "uploads"
    "sa_tmp"
    "tmp"
    "siteadmin/components"
    "siteadmin/config"
    "siteadmin/generated_code"
    "siteadmin/migrations"
    "siteadmin/includes"
    "siteadmin/modules"
    "siteadmin/tests"
    "siteadmin/themes"
    "siteadmin/vendor"
    "siteadmin/views"
)

for dir in "${sa_directories[@]}"
do
    mkdir -p ${dir}
done

echo "Installing bootstrap files"

# Make index.php file
cat > html/index.php << EOF
<?php require("../siteadmin/includes/bootstrap.php");
EOF

# Make .htaccess file
cat > html/.htaccess << EOF
RewriteEngine on
RewriteCond %\{REQUEST_FILENAME\} !-f
RewriteRule . index.php [L]
EOF

# Make composer.json file
cat > siteadmin/composer.json << EOF
{
    "repositories": [
        {
            "type": "composer",
            "url": "https://pkg.elinkstaging.com"
        }
    ],
    "require": {
        "sa/siteadmin": ">=3.1.1.968",
        "sa/module/store": "1.*",
        "sa/module/dashboard": "1.*"
    }
}
EOF

# Make app.php
cat > siteadmin/includes/app.php << EOF
<?php
require("bootstrap.php");
EOF

cat > siteadmin/includes/bootstrap.php << EOF
<?php

use sa\application\app;

error_reporting(E_ALL & ~E_NOTICE &~E_STRICT);
date_default_timezone_set("America/New_York");

/* SETUP THE AUTOLOADERS */

\$path = str_replace("\\\\", "/", __DIR__);
\$pathArray = explode("/", \$path);
array_pop(\$pathArray);
\$installPath = implode("/", \$pathArray);

require_once(\$installPath."/vendor/autoload.php");
if (file_exists(\$installPath."/vendor/sa/siteadmin/src/application/autoloader.php")) {
    require_once(\$installPath . "/vendor/sa/siteadmin/src/application/autoloader.php");
}

session_start();

/* RUN THE APP */
\$app = app::getCreateInstance( \$argv );
\$app->run();
EOF

# Make .gitignore files
echo "Initializing .gitignore files"

cat > .gitignore << EOF
*.DS_Store
*.sublime-project
*.sublime-workspace
*.php~
.idea
/siteadmin/config/devconfig.php
/siteadmin/composer.lock
/siteadmin/composer.phar
/docs
/html/docs
/*.iml
EOF

cat > siteadmin/vendor/.gitignore << EOF
*!.gitignore
EOF

cat > tmp/.gitignore << EOF
*!.gitignore
EOF

cat > siteadmin/generated_code/.gitignore << EOF
*!.gitignore
EOF
cat > siteadmin/tests/.gitignore << EOF
*!.gitignore
EOF

cat > siteadmin/migrations/.gitignore << EOF
*!.gitignore
EOF

cat > uploads/.gitignore << EOF
*!.gitignore
EOF

cd "${APP_DIR_PATH}/siteadmin"

echo "Installing composer dependencies in: ${APP_DIR_PATH}/siteadmin"
/usr/local/bin/composer install

echo "Updating database"
#php vagrant/application/siteadmin/includes/app.php -e=production -c=doctrine orm:schema:update