# List of features to implement

- ~~Download projects from gitlab~~
- Destroy project
    - files, database and database user
- Automatically add `siteadmin-installer.json` to `.gitignore`
- Download database and migrate into local project.
- ~~IOC reload~~
    -~~removes IOC files so they can be regenerated~~
- ~~Composer watcher~
    - ~~watches `composer.json` file and keeps backups as it changes~~
- Composer undo/redo
    - restores another version of the `composer.json` file from history
- Composer change history
    - lists all of the changes made to the `composer.json` file (stored in `.sa-cli` directory)
- update doctrine
- ~~generate installer config from existing project~~
- get vagrant IP address
- separate vagrant provision from core CLI
    - ruby and other dependencies should be installed by the CLI
    
    
    
# Suggested changes

- ~~`init`: create `siteadmin-installer.json` from existing project~~
- ~~`install`~~
    - ~~If param 1 is gitlab url, install existing project~~
    - ~~If param 1 is text, install new project~~