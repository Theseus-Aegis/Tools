# Restart Apache (eg. after win-acme renewal)

echo "[INFO] Restarting Apache..."
C:\Apache24\bin\httpd.exe -k restart
echo "[INFO] Apache restarted."