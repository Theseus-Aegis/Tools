# Return contractors and their netbank balance, of those who were present on any campaign contract and have lower than maximum balance
SELECT DISTINCT field_contractors_topay_target_id, apollo.bankaccounts.balance, drupal.users.name
FROM drupal.field_data_field_contractors_topay
INNER JOIN apollo.bankaccounts ON field_contractors_topay_target_id=apollo.bankaccounts.id
INNER JOIN drupal.users ON drupal.users.uid=field_contractors_topay_target_id
WHERE entity_id in (689, 687, 684, 681)  # Node IDs of contracts to check for attendance
    AND balance < 15000;  # Maximum netbank balance for bonus legibility


# Return contractors and amount of campaign contracts they were present on
SELECT DISTINCT COUNT(field_contractors_topay_target_id) AS contracts_attended, CONCAT_WS(' ', first_name.field_first_name_value, last_name.field_last_name_value) AS name
FROM drupal.field_data_field_contractors_topay contract
INNER JOIN drupal.users ON drupal.users.uid=contract.field_contractors_topay_target_id
INNER JOIN drupal.field_data_field_first_name first_name ON drupal.users.uid=first_name.entity_id
INNER JOIN drupal.field_data_field_last_name last_name ON drupal.users.uid=last_name.entity_id
WHERE contract.entity_id in (772, 773, 774, 775, 777, 778, 779, 782, 783, 785, 786, 787)  # Node IDs of contracts to check for attendance
GROUP BY first_name.field_first_name_value, last_name.field_last_name_value
