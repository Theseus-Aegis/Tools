/*
 * Author: Rory
 *
 * Adds correct items/weapons to containers.
 *
 * Arguments:
 * 
 *
 */

//Names of the boxes in editor.
    _boxPistolAmmo = boxPistolAmmo;
    _boxPistolWeapons = boxPistolWeapons;
    _boxPistolSupport = boxPistolSupport;
    _boxRifleWeapons = boxRifleWeapons;
    _boxRiflesSupport = boxRiflesSupport;
    _boxRifleAmmo = boxRifleAmmo;
    _boxCQBammo = boxCQBammo;
    _boxCQBweapons = boxCQBweapons;
    _boxCQBsupport = boxCQBsupport;
    _boxFormationsWeapons = boxFormationsWeapons;
    _boxFormationsAmmo = boxFormationsAmmo;
    _boxContactWeapons = boxContactWeapons;
    _boxContactAmmo = boxContactAmmo;
    _boxLaunchers1 = boxLaunchers1;
    _boxLaunchers2 = boxLaunchers2;
    _boxPeelWeapons = boxPeelWeapons;
    _boxPeelAmmo = boxPeelAmmo;
    _boxBoundingWeapons = boxBoundingWeapons;
    _boxBoundingAmmo = boxBoundingAmmo;
 
//Removing all items from all boxes.
{
    clearWeaponCargoGlobal _x;
    clearMagazineCargoGlobal _x;
    clearItemCargoGlobal _x;
    clearBackpackCargoGlobal _x;
} forEach [
    _boxPistolAmmo, 
    _boxPistolWeapons, 
    _boxPistolSupport,
    _boxRifleWeapons,
    _boxRiflesSupport,
    _boxRifleAmmo,
    _boxCQBammo,
    _boxCQBweapons,
    _boxCQBsupport,
    _boxFormationsWeapons,
    _boxFormationsAmmo,
    _boxContactWeapons,
    _boxContactWeapons,
    _boxContactAmmo,
    _boxLaunchers1,
    _boxLaunchers2,
    _boxPeelWeapons,
    _boxPeelAmmo,
    _boxBoundingWeapons,
    _boxBoundingAmmo
];

 //Weaponry for the pistol course.
    _boxPistolAmmo addMagazineCargoGlobal ["16Rnd_9x21_Mag",25];
    _boxPistolAmmo addMagazineCargoGlobal ["9Rnd_45ACP_Mag",25];
    _boxPistolAmmo addMagazineCargoGlobal ["11Rnd_45ACP_Mag",25];
    _boxPistolAmmo addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder",25]; 
    _boxPistolAmmo addMagazineCargoGlobal ["rhsusf_mag_7x45acp_MHP",25]; 
    
    _boxPistolWeapons addWeaponCargoGlobal ["hgun_P07_F",5];
    _boxPistolWeapons addWeaponCargoGlobal ["hgun_Pistol_heavy_01_F",5];
    _boxPistolWeapons addWeaponCargoGlobal ["hgun_Pistol_heavy_02_F",5];
    _boxPistolWeapons addWeaponCargoGlobal ["hgun_Rook40_F",5];
    _boxPistolWeapons addWeaponCargoGlobal ["hgun_ACPC2_F",5];
    _boxPistolWeapons addWeaponCargoGlobal ["rhsusf_weap_m1911a1",5];
    
    _boxPistolSupport addItemCargoGlobal ["optic_MRD",5];
    _boxPistolSupport addItemCargoGlobal ["muzzle_snds_L",5];
    _boxPistolSupport addItemCargoGlobal ["muzzle_snds_acp",5];
    _boxPistolSupport addItemCargoGlobal ["optic_Yorris",5];


//Weaponry for the rifle course.
    _boxRifleWeapons addWeaponCargoGlobal ["rhs_weap_m16a4_carryhandle",15];
    _boxRifleWeapons addWeaponCargoGlobal ["rhs_weap_m4_carryhandle",15];
    _boxRifleWeapons addWeaponCargoGlobal ["rhs_weap_m249_pip",15];
    _boxRifleWeapons addWeaponCargoGlobal ["rhs_weap_m4a1_carryhandle",15];
    _boxRifleWeapons addWeaponCargoGlobal ["rhs_weap_m14ebrri",10];
    _boxRifleWeapons addWeaponCargoGlobal ["LMG_Mk200_F",10];
    _boxRifleWeapons addWeaponCargoGlobal ["arifle_MX_F",10]; 

    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_rotex5_grey",10];
    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_rotex5_tan",10];
    _boxRiflesSupport addItemCargoGlobal ["muzzle_snds_B",10];
    _boxRiflesSupport addItemCargoGlobal ["muzzle_snds_H",10];
    _boxRiflesSupport addItemCargoGlobal ["muzzle_snds_H_MG",10];
    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_SF3P556",10];
    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_SFMB556",10];
    _boxRiflesSupport addItemCargoGlobal ["acc_pointer_IR",10];
    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_compm4",10];
    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_eotech_552",10];
    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_ACOG",10];
    _boxRiflesSupport addItemCargoGlobal ["rhsusf_acc_ELCAN",10];
    _boxRiflesSupport addItemCargoGlobal ["bipod_01_F_blk",20];

    _boxRifleAmmo addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag",100];
    _boxRifleAmmo addMagazineCargoGlobal ["200Rnd_65x39_cased_Box",100];
    _boxRifleAmmo addMagazineCargoGlobal ["rhsusf_100Rnd_556x45_soft_pouch",50];
    _boxRifleAmmo addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag",100];
    _boxRifleAmmo addMagazineCargoGlobal ["rhsusf_20rnd_762x51_m993_mag",100];  


//Weaponry used for the CQB Course.
    _boxCQBammo addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag",100];
    _boxCQBammo addMagazineCargoGlobal ["rhsusf_100Rnd_556x45_soft_pouch",50];
    _boxCQBammo addMagazineCargoGlobal ["SmokeShell",25];
    _boxCQBammo addMagazineCargoGlobal ["SmokeShellGreen",25];
    _boxCQBammo addMagazineCargoGlobal ["HandGrenade",25];

    _boxCQBweapons addWeaponCargoGlobal ["rhs_weap_m16a4_carryhandle",15];
    _boxCQBweapons addWeaponCargoGlobal ["rhs_weap_m249_pip",15];

    _boxCQBsupport addItemCargoGlobal ["acc_pointer_IR",20];
    _boxCQBsupport addItemCargoGlobal ["rhsusf_acc_compm4",15];
    _boxCQBsupport addItemCargoGlobal ["rhsusf_acc_eotech_552",15];
    _boxCQBsupport addItemCargoGlobal ["rhsusf_acc_ACOG",10];

//Weaponry used for the formations course.
    _boxFormationsWeapons addWeaponCargoGlobal ["rhs_weap_m16a4_carryhandle",15];

    _boxFormationsAmmo addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_M200_Stanag",25]; 

//Weaponry used for the contact calls course.
    _boxContactWeapons addWeaponCargoGlobal ["rhs_weap_m16a4_carryhandle",15];

    _boxContactAmmo addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag",100];

//Weaponry used for the AT range.
    _boxLaunchers1 addWeaponCargoGlobal ["rhs_weap_M136",20];
    _boxLaunchers1 addWeaponCargoGlobal ["launch_NLAW_F",10];
    _boxLaunchers1 addWeaponCargoGlobal ["launch_B_Titan_short_F",3];
    _boxLaunchers1 addMagazineCargoGlobal ["Titan_AT",10];
    _boxLaunchers1 addMagazineCargoGlobal ["NLAW_F",20];

    _boxLaunchers2 addWeaponCargoGlobal ["rhs_weap_M136",20];
    _boxLaunchers2 addWeaponCargoGlobal ["launch_NLAW_F",10];
    _boxLaunchers2 addWeaponCargoGlobal ["launch_B_Titan_short_F",3];
    _boxLaunchers2 addMagazineCargoGlobal ["Titan_AT",10];
    _boxLaunchers2 addMagazineCargoGlobal ["NLAW_F",20];

//Weaponry used for the Peel course.
    _boxPeelWeapons addWeaponCargoGlobal ["rhs_weap_m16a4_carryhandle",15];

    _boxPeelAmmo addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag",100];
    _boxPeelAmmo addMagazineCargoGlobal ["SmokeShell",25];
    _boxPeelAmmo addMagazineCargoGlobal ["SmokeShellGreen",25];

//Weaponry used for the bounding course.
    _boxBoundingWeapons addWeaponCargoGlobal ["rhs_weap_m16a4_carryhandle",15];

    _boxBoundingAmmo addMagazineCargoGlobal ["rhs_mag_30Rnd_556x45_M855A1_Stanag",100];
    _boxBoundingAmmo addMagazineCargoGlobal ["SmokeShell",25];
    _boxBoundingAmmo addMagazineCargoGlobal ["SmokeShellGreen",25];
    