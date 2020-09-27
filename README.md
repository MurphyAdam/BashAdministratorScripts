# Administrator Bash Scripts

Featured useful administrators bash scripts which handle crucial and time-consuming operations. Star, fork or contribute if you wish so. 

#### Current available scripts
1. central-logger
2. - new scripts will be added frequently

### Examples

##### central-logger
central-logger is a file watcher which detects only the keywords list changes in a file and logs them into a more dedicated destination file.

##### Shell arguments

-f : filename somefile.txt. Required
-k : keyword list to watch for. e.g. 'error|csrf|down'. Required
-o : output file. default output.log
-v 1: verbous mode. default none-verbous
-b 1: run process in background and return shell. default foreground

first time you run the script, make sure it has rwx permissions

```bash
chmod 777 central-logger.sh
```

then whenever you want to watch a file, just do as below.

```bash
bash ./central-logger -f hosts -k 'error|broke|warning|kill' -o vital-logs.log -v 1 -b 1
```

example above watches the file ```hosts``` for any entries defined in the passed keyword_list (-k 'error|broke|warning|kill') and then logs them to the output file ```vital-logs.log```
 
```bash
cat vital-logs
[2020-09-27T16:35:24+01:00] error [in ../hosts]
[2020-09-27T16:35:24+01:00] broken [in ../hosts]
[2020-09-27T16:35:24+01:00] warning [in ../hosts]
[2020-09-27T16:37:22+01:00] error [in ../hosts]
[2020-09-27T16:37:30+01:00] error [in ../hosts]
 ```

### GitHub repository
[https://github.com/MurphyAdam/BashAdministratorScripts](https://github.com/MurphyAdam/BashAdministratorScripts