<?php

$wgDBserver = '{{ database_ip }}';
$wgDBport = 3306;
$wgDBname = '{{ wiki_database }}';
$wgDBuser = '{{ wiki_user }}';
$wgDBpassword = '{{ wiki_password }}';
$wgDBtype = 'mysql';
$wgDBssl = false;
$wgDBcompress = false;
$wgDBadminuser = null;
$wgDBadminpassword = null;
$wgSearchType = null;
$wgSearchTypeAlternatives = null;
$wgDBprefix = '';
$wgDBTableOptions = 'ENGINE=InnoDB';
$wgSQLMode = '';
$wgDBmwschema = null;
$wgSQLiteDataDir = '';
$wgAllDBsAreLocalhost = false;
$wgSharedDB = null;
$wgSharedPrefix = false;
$wgSharedTables = array( 'user', 'user_properties' );
$wgSharedSchema = false;
$wgDBservers = false;
