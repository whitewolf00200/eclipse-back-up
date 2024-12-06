public class SSOppDefaults {
 public static set<string> getfe(){
        set<string> ss = new set<string>(); 
        ss.add('X6L_Water_Qty__c');
        ss.add('ALUnit_Qty__c');
        ss.add('X9L_Water_Qty__c');
        ss.add('X3L_Water_Mist_Qty__c');
        ss.add('X6L_Water_Mist_Qty__c');
        ss.add('X9L_Water_Mist_Qty__c');
        ss.add('X2L_AFFF_Qty__c');
        ss.add('X3L_AFFF_Qty__c');
        ss.add('X6L_AFFF_Qty__c');
        ss.add('X9L_AFFF_Qty__c');
        ss.add('X2KG_CO2_Qty__c');
        ss.add('X5KG_CO2_Qty__c');
        ss.add('X1_KG_Dry_Powder_Qty__c');
        ss.add('X2KG_Dry_Powder_Qty__c');
        ss.add('X4KG_Dry_Powder_Qty__c');
        ss.add('X6KG_Dry_Powder_Qty__c');
        ss.add('X9KG_Dry_Powder_Qty__c');
        ss.add('X3L_Wet_Chem_Qty__c');
        ss.add('X6L_Wet_Chem_Qty__c');
        return ss;
 }
 public static set<string> getfb(){
        set<string> ss = new set<string>();
        ss.add('X1X1_Fire_blan_Qty__c');
        ss.add('X12x12_FB_Qty__c');
        ss.add('X12x18_FB_Qty__c');
        return ss;
}
 public static set<string> getvt(){
        set<string> ss = new set<string>();
        ss.add('Service Revisit');
        ss.add('Client Request');
        ss.add('Extra Work');
        ss.add('Holiday');
        ss.add('Other');
        ss.add('Projects');
        ss.add('Reactive');
        ss.add('Service Revisit');
        ss.add('Service Revisit FOC');
        ss.add('Sick');
        ss.add('Training');
        return ss;
}
public static set<string> getel(){
        set<string> ss = new set<string>();
        ss.add('FA_Emergency_Light_Qty__c');
        return ss;  
 }
public static set<string> gethr(){
        set<string> ss = new set<string>();
        ss.add('XHose_Reel_19_Qty__c');
        return ss;
}
public static set<string> getpc(){
        set<string> ss = new set<string>();
        ss.add('Parking_Costs__c');
        ss.add('Congestion_Charge__c');
        return ss;
}
 public static string fapid(string s){
       string p = '01t280000005nIY';
       if(s=='Nurse Call / Disabled Alarm Maintenance')p='01t280000005nKg';
       if(s=='Smoke Vent / Curtain Maintenance')p='01t280000005nKF';
       if(s=='Type D Inspection & Test of Emergency Lighting')p='01t280000005nK9';
       if(s=='Type 25 Inspection & Test of Access Control System')p='01t280000005nK4';
       if(s=='Type 50 Inspection & Test of Access Control System')p='01t280000005nK5';
       if(s=='Type A Inspection & Test of Access Control System')p='01t280000005nK6';
       if(s=='Type 25 Inspection & Test of CCTV System')p='01t280000005nJT';
       if(s=='Type 50 Inspection & Test of CCTV System')p='01t280000005nJV';
       if(s=='Type A Inspection & Test of CCTV System')p='01t280000005nK7';
       if(s=='Type 25 Inspection & Test of Intruder Alarm System')p='01t280000005nJU';
       if(s=='Type 50 Inspection & Test of Intruder Alarm System')p='01t280000005nJX';
       if(s=='Type A Inspection & Test of Intruder Alarm System')p='01t280000005nK8';
       if(s=='Type 25 Inspection & Test of Fire Alarm')p='01t280000005nJS';
       if(s=='Type 50 Inspection & Test of Fire Alarm')p='01t280000005nJW';
       if(s=='Type 52 Inspection & Test of Fire Alarm')p='01t280000005nJY';
       if(s=='Type 6D Inspection & Test of Emergency Lighting')p='01t280000005nJZ';
       if(s=='Type 12D Inspection & Test of Emergency Lighting')p='01t280000005nJQ';
       if(s=='Type 25 & D Inspection & Test of Fire Alarm & Emergency Lighting')p='01t280000005nJy';
       if(s=='Type 50 & D Inspection & Test of Fire Alarm & Emergency Lighting')p='01t280000005nJz';
       if(s=='Type 52 & D Inspection & Test of Fire Alarm & Emergency Lighting')p='01t280000005nK0';
       if(s=='Type 25 & 6D Inspection & Test of Fire Alarm & Emergency Lighting')p='01t280000005nK1';
       if(s=='Type 50 & 6D Inspection & Test of Fire Alarm & Emergency Lighting')p='01t280000005nK2';
       if(s=='Type 52 & 6D Inspection & Test of Fire Alarm & Emergency Lighting')p='01t280000005nK3';
       if(s=='Type 50 & 12D Inspection & Test of Fire Alarm & Emergency Lighting')p='01t280000005nKJ';
       if(s=='Other')p='01t280000005nHl';            //Added by Puthuvannam on 6th May, 2014 for Ticket #SFD000025
       return p;
 }
}