# backupdubs x pyrekordbox

Retrieve RekordBox Data with Pyrekordbox

```
pip install -r requirements.txt
```

** if not sure
```
pip3 install pyrekordbox
```

## Generate Key into cache (MacOS and Linux, not sure Windows??)

```
python -m pyrekordbox download-key
```

If you have the key by yourself you can use the following pyrekordbox function:

```bash
write_db6_key_cache("<YOUR_KEY>")
```

**See documentation: https://pyrekordbox.readthedocs.io/en/stable/key.html**
**Database Format: https://pyrekordbox.readthedocs.io/en/stable/formats/db6.html**


should create somehting similar with the key:

```
usr/local/lib/python3.9/site-packages/pyrekordbox/rb.cache
```


Next Step => https://github.com/Holzhaus/rekordcrate (Rust Project)
