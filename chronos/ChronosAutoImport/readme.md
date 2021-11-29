### Import by Script
- **FIRST TIME:**
    - navigate to `C:\Theseus\Tools\ChronosAutoImport`
    - **right** click on `runImport.bat` and select `Send To -> Desktop (create a shortcut)`
    - Make sure all parameters are properly set for your use-case (see notes)


- Run `runImport.bat`from your desktop
- If you get an error "ERROR: file *XYZ* could not be found, please create it."
  - Navigate to `C:\ProgramData\MySQL\MySQL Server 8.0\Uploads` 
  - Duplicate `DO_NOT_DELETE_chronos.csv`
  - Rename new file to `chronos.csv`
  - Restart script
- When prompted input your credentials for DB access
- Verify that number from output of "GOT *XYZ* ITEMS" and "AFFECTED *XYZ* LINES" match
  - If they do not, procced at your own risk or do manual import and message Ian with problem
- Double check correct `items_list` table via MySql Workbench

##### Notes:
- Script params are located in `C:\Theseus\Tools\ChronosAutoImport\main.py`
  - `CHRONOS_LOCATION` and `CHRONOS_NAME` should point to location where .sql script expects .csv file
  - `SCRIPT_PATH` should point to path to .sql script (in **one command per line** format)
  - `DB_NAME` should contain name of MySQL DB you are importing to
  - `GOOGLE_DOCS_URL`should point to URL with which you can download .csv file from google sheets
    - format is `https://docs.google.com/spreadsheets/d/{{ID}}/gviz/tq?tqx=out:csv&sheet={{SHEET_NAME}}`
- **IMPORTANT:** do not remove `C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\DO_NOT_DELETE_chronos.csv`
  - If you still manage to f*** up and delete it, message Ian on slack, and *bring him a cookie*
