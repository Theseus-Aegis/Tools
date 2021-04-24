TRUNCATE item_list;
# Place CSV export in the following location and make sure there is an empty line at the end of the file
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/chronos.csv'
    INTO TABLE item_list
    FIELDS
        TERMINATED BY ','
        ENCLOSED BY '"'
    LINES
        TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (className, prettyName, category, subCategory, slot, price, salePrice, description, supplier, imageURL, available, accessLevel, requiredTrainings, availableMembers);
