SELECT DISTINCT field_contractors_topay_target_id, apollo.bankaccounts.balance, drupal.users.name
FROM drupal.field_data_field_contractors_topay
INNER JOIN apollo.bankaccounts ON field_contractors_topay_target_id=apollo.bankaccounts.id
INNER JOIN drupal.users ON drupal.users.uid=field_contractors_topay_target_id
WHERE entity_id in (689, 687, 684, 681)  # Node IDs of contracts to check for attendance
    AND balance < 15000;  # Maximum netbank balance for bonus legibility
