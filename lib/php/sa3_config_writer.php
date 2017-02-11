<?php
$appDir = null;
foreach($argv as $key => $arg) {
    if($arg == '-d' && array_key_exists($key + 1, $argv)) {
        $appDir = $argv[$key + 1];
    }
}

if($appDir == null) {
    print 'ERROR: App directory parameter (-d) not passed into script.';
    exit();
}

include "$appDir/siteadmin/vendor/autoload.php";

use sa\utilities;

$filePath = "$appDir/siteadmin-installer.json";
$defaultConfigPath = 'defaultconfig.php';

if(!file_exists($filePath)) {
    echo "Failed to initialize SA configuration file. Siteadmin installer config not found at $filePath.";
    exit(1);
}

$saInstallerConfig = json_decode(file_get_contents($filePath), true);

$applicationSettings = array(
    'hasBeenSetup'      => true,
    'site_url'          => 'http://' . $saInstallerConfig['domain'],
    'secure_site_url'   => 'https://' . $saInstallerConfig['domain'],
    'session_domain'    =>  $saInstallerConfig['domain'],

    'uploadsDir' => null,
    'tempDir'     => null,

    'db_driver' => 'pdo_mysql',
    'db_path' => '',
    'db_name' => $saInstallerConfig['mysql']['app']['name'],
    'db_username' => $saInstallerConfig['mysql']['app']['user'],
    'db_password' => $saInstallerConfig['mysql']['app']['pass'],
    'db_server' => $saInstallerConfig['mysql']['app']['host']
);

$ref = new ReflectionClass('sa\application\app');

/** @var sa\application\app $app */
$app = $ref->newInstanceWithoutConstructor();
$app->buildDefaultConfigs();
include "$appDir/siteadmin/config/config.php";
utilities\configWriter::writeConfig($applicationSettings, $defaultConfigPath);