## Create FSFS files in SVN server

Getting BDB svn repo
```bash
rsync -av /home/svn/umov.sources/repo-obj ./
```

Creating FSFS svn repo
```bash
rm -rf repo-onj-fsfs
svnadmin create repo-onj-fsfs --fs-type fsfs
```

Loading BDB data to FSFS repo \
This may fail if the cp was done while data was changing, with the server running
You can shutdown the server or try again several times until this works
```bash
svnadmin dump $BDB -q | svnadmin load $FSFS
```
