trigger ServSheetOpp on Engineer_Checklist__c (after insert,after update) {
/*
if(!RecursiveHandler.runSSO_TriggerOnce())
        return;
//try{
if(Test.isRunningTest()||!OnceSSO.hasAlreadyRound()){
OnceSSO.setAlreadyRound();

Set<String> spc = new Set<String>();
spc.add('XXXX');
spc.add('C9LWAT');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('C6LAFFF');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('C1KGDP');
spc.add('C2KGDP');
spc.add('C4KGDP');
spc.add('XXXX');
spc.add('C9KGDP');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('CHOSER');
spc.add('XXXX');
spc.add('H8230');
spc.add('H7776');
spc.add('XXXX');
spc.add('H0002');
spc.add('H7808');
spc.add('XXXX');
spc.add('H7804');
spc.add('H7780');
spc.add('H9264');
spc.add('H7792');
spc.add('H7784');
spc.add('H8238');
spc.add('H9260');
spc.add('H7788');
spc.add('H8242');
spc.add('XXXX');
spc.add('H8234');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('H8230');
spc.add('H7776');
spc.add('XXXX');
spc.add('H0002');
spc.add('XXXX');
spc.add('H7808');
spc.add('XXXX');
spc.add('H7804');
spc.add('H7780');
spc.add('H9264');
spc.add('H7792');
spc.add('H7784');
spc.add('H8238');
spc.add('H9260');
spc.add('H7788');
spc.add('H8248');
spc.add('XXXX');
spc.add('H8234');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('S6LWAT');
spc.add('S9LWAT');
spc.add('S3LWATM');
spc.add('S6LWATM');
spc.add('S9LWATM');
spc.add('S2LAFFF');
spc.add('S3LAFFF');
spc.add('S6LAFFF');
spc.add('S9LAFFF');
spc.add('S2KGC');
spc.add('S5KGC');
spc.add('S1KGDP');
spc.add('S2KGDP');
spc.add('S4KGDP');
spc.add('S6KGDP');
spc.add('S9KGDP');
spc.add('XXXX');
spc.add('S6LWETC');
spc.add('SFIREB');
spc.add('SFIREB');
spc.add('SFIREB');
spc.add('SHOSER');
spc.add('SAL');
spc.add('S6LWATR_4005');
spc.add('S9LWATR_4005');
spc.add('S3LWATMR_4005');
spc.add('S6LWATMR_4005');
spc.add('S9LWATMR_4005');
spc.add('S2LAFFFR');
spc.add('S3LAFFFR');
spc.add('S6LAFFFR');
spc.add('S9LAFFFR');
spc.add('S2KGCR');
spc.add('S5KGCR');
spc.add('S1KGDPR');
spc.add('S2KGDPR');
spc.add('S4KGDPR');
spc.add('S6KGDPR');
spc.add('S9KGDPR');
spc.add('XXXX');
spc.add('S6LETCR');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('S2KGDPX');
spc.add('S4KGDPX');
spc.add('S6KGDPX');
spc.add('S9KGDPX');
spc.add('XXXX');
spc.add('S6LWETCX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('XXXX');
spc.add('S6LWATX_4005');
spc.add('S9LWATX_4005');
spc.add('S3LWATMX_4005');
spc.add('S6LWATMX_4005');
spc.add('S9LWATMX_4005');
spc.add('S2LAFFFX');
spc.add('S3LAFFFX');
spc.add('S6LAFFFX');
spc.add('S9LAFFFX');
spc.add('S2KGCX');
spc.add('S5KGCX');
spc.add('S1KGDPX');

Map<String,Id> pbid = new Map<String,Id>();
Map<String,Double> pbup = new Map<String,Double>();
List<PricebookEntry> lpbe = ([select Id,Product2.ProductCode,UnitPrice
                                 from PricebookEntry where
                                  Product2.ProductCode IN: spc
                                  AND
                                  Pricebook2.Name='Standard Price Book']);
for(PricebookEntry pbe : lpbe){
    pbid.put(pbe.Product2.ProductCode,pbe.Id);
    pbup.put(pbe.Product2.ProductCode,pbe.UnitPrice);
}

Datetime asofnow = system.now();
String litasofnow = asofnow.format();
List<Opportunity> lopp = new List<Opportunity>();
for(Engineer_Checklist__c ss : trigger.new){
Boolean ofc = false;
try{ofc= trigger.oldMap.get(ss.id).Fire_Extinguisher_Service_complete__c;}catch(Exception exofc){}
Boolean nfc = trigger.newMap.get(ss.id).Fire_Extinguisher_Service_complete__c;
if(nfc&&nfc!=ofc&&(ss.RecordTypeID=='01228000000D11b' || Test.isRunningTest())){
    Opportunity op = new Opportunity(
    AccountID = ss.Site__c,
    CloseDate = system.today(),
    StageName = 'Closed Won',
    Name = 'Service Sheet Complete '+ss.Site_Name__c+' '+system.today().format(),
    Service_Sheet__c = ss.id,
    ss_run_date__c = asofnow,
    Technician_Groups__c=ss.Technician_Group__c,    // Modified by Puthuvannam for the ticket - SFD000044 and Date 08/05/2014
    Technician_Super_Groups__c=ss.Technician_Super_Group__c,    // Modified by Puthuvannam for the ticket - SFD000044 and Date 08/05/2014
    Engineer_Completed_Service__c=true
    );
    lopp.add(op);
    if(lopp.size()>95){
        insert lopp;
        lopp.clear();
    }
}
}
if(lopp.size()>0){
    insert lopp;
    lopp.clear();
}

lopp = ([select Id, Service_Sheet__r.Id
          from Opportunity where
          ss_run_date__c =: asofnow]);  
Map<Id,Id> ssop = new Map<Id,Id>();
for(Opportunity op : lopp){
    ssop.put(op.Service_Sheet__r.Id, op.Id);
}

List<OpportunityLineItem> loli = new List<OpportunityLineItem>();
for(Engineer_Checklist__c ss : trigger.new){
Boolean ofc=false;
try{ofc= trigger.oldMap.get(ss.id).Fire_Extinguisher_Service_complete__c;}catch(Exception exofc){}
Boolean nfc = trigger.newMap.get(ss.id).Fire_Extinguisher_Service_complete__c;
if(nfc&&nfc!=ofc&&(ss.RecordTypeID=='01228000000D11b' || Test.isRunningTest())){
    
    Id opid = ssop.get(ss.Id);
loli=dooli(loli,opid,ss.X6L_Water_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X9L_Water_Condemned__c,pbid.get('C9LWAT_4005'),pbup.get('C9LWAT_4005'));
loli=dooli(loli,opid,ss.X3L_Water_Mist_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Water_Mist_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X9L_Water_Mist_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X2L_AFFF_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X3L_AFFF_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_AFFF_Condemned__c,pbid.get('C6LAFFF'),pbup.get('C6LAFFF'));
loli=dooli(loli,opid,ss.X9L_AFFF_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X2KG_CO2_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X5KG_CO2_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X1KG_Dry_Powder_Condemned__c,pbid.get('C1KGDP'),pbup.get('C1KGDP'));
loli=dooli(loli,opid,ss.X2KG_Dry_Powder_Condemned__c,pbid.get('C2KGDP'),pbup.get('C2KGDP'));
loli=dooli(loli,opid,ss.X4KG_Dry_Powder_Condemned__c,pbid.get('C4KGDP'),pbup.get('C4KGDP'));
loli=dooli(loli,opid,ss.X6KG_Dry_pow_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X9KG_Dry_Powder_Condemned__c,pbid.get('C9KGDP'),pbup.get('C9KGDP'));
loli=dooli(loli,opid,ss.X3L_Wet_Chem_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Wet_Chem_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X1x1_Fire_blank_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x12_FB_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x18_FB_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.XHose_Reel_19_Condemned__c,pbid.get('CHOSER'),pbup.get('CHOSER'));
loli=dooli(loli,opid,ss.ALUnit_Condemned__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Water_New_Equipment_Left_On_Site__c,pbid.get('H8230'),pbup.get('H8230'));
loli=dooli(loli,opid,ss.X9L_New_Equipment_Left_On_Site__c,pbid.get('H7776'),pbup.get('H7776'));
loli=dooli(loli,opid,ss.X3L_Water_Mist_New_Equipment_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Water_Mist_New_Equip_Left_On_Site__c,pbid.get('H0002'),pbup.get('H0002'));
loli=dooli(loli,opid,ss.X2_AFFF_New_Equipment_Left_On_Site__c,pbid.get('H7808'),pbup.get('H7808'));
loli=dooli(loli,opid,ss.X3L_AFFF_New_Equipt_Left_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_AFFF_New_Equip_Left_On_Site__c,pbid.get('H7804'),pbup.get('H7804'));
loli=dooli(loli,opid,ss.X9L_AFFF_New_Equipment_Left_On_Site__c,pbid.get('H7780'),pbup.get('H7780'));
loli=dooli(loli,opid,ss.X2KG_CO2_New_Equipment_Left_On_Site__c,pbid.get('H9264'),pbup.get('H9264'));
loli=dooli(loli,opid,ss.X5KG_CO2_New_Equipment_Left_On_Site__c,pbid.get('H7792'),pbup.get('H7792'));
loli=dooli(loli,opid,ss.X1KG_Dry_Pow_New_Equipment_Left_On_Site__c,pbid.get('H7784'),pbup.get('H7784'));
loli=dooli(loli,opid,ss.X2KG_Dry_Pow_New_Equipment_Left_On_Site__c,pbid.get('H8238'),pbup.get('H8238'));
loli=dooli(loli,opid,ss.X4KG_Dry_Pow_New_Equipment_Left_On_Site__c,pbid.get('H9260'),pbup.get('H9260'));
loli=dooli(loli,opid,ss.X6KG_Dry_Pow_New_Equipment_Left_On_Site__c,pbid.get('H7788'),pbup.get('H7788'));
loli=dooli(loli,opid,ss.X9KG_Dry_Pow_New_Equipment_Left_On_Site__c,pbid.get('H8242'),pbup.get('H8242'));
loli=dooli(loli,opid,ss.X3L_Wet_Chem_New_Equipment_Left_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Wet_Chem_New_Equip_Left_On_Site__c,pbid.get('H8234'),pbup.get('H8234'));
loli=dooli(loli,opid,ss.X1x1_Fire_blan_New_Equipt_Left_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x12_FB_New_Equipment_Left_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x18_FB_New_Equipment_Left_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.Hose_Reel_19_New_Equipment_Left_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.ALUnit_New_Equipment_Left_On_Site__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_New_Equipment_To_Be_Dispatched__c,pbid.get('H8230'),pbup.get('H8230'));
loli=dooli(loli,opid,ss.X9L_New_Equipment_To_Be_Dispatched__c,pbid.get('H7776'),pbup.get('H7776'));
loli=dooli(loli,opid,ss.X3L_Water_Mist_New_Equip_To_Be_Dispat__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Water_Mist_New_Equip_To_Be_Dispat__c,pbid.get('H0002'),pbup.get('H0002'));
loli=dooli(loli,opid,ss.X9L_Water_Mist_New_Equip_To_Be_Dispat__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X2L_AFFF_New_Equipment_To_Be_Dispatched__c,pbid.get('H7808'),pbup.get('H7808'));
loli=dooli(loli,opid,ss.X3L_AFFF_New_Equipment_To_Be_Dispatched__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_AFFF_New_Equipment_To_Be_Dispatched__c,pbid.get('H7804'),pbup.get('H7804'));
loli=dooli(loli,opid,ss.X9L_AFFF_New_Equipment_To_Be_Dispatched__c,pbid.get('H7780'),pbup.get('H7780'));
loli=dooli(loli,opid,ss.X2KG_CO2_New_Equipment_To_Be_Dispatched__c,pbid.get('H9264'),pbup.get('H9264'));
loli=dooli(loli,opid,ss.X5KG_CO2_New_Equipment_To_Be_Dispatched__c,pbid.get('H7792'),pbup.get('H7792'));
loli=dooli(loli,opid,ss.X1KG_Dry_Pow_New_Equip_To_Be_Dispatched__c,pbid.get('H7784'),pbup.get('H7784'));
loli=dooli(loli,opid,ss.X2KG_Dry_Pow_New_Equip_To_Be_Dispatched__c,pbid.get('H8238'),pbup.get('H8238'));
loli=dooli(loli,opid,ss.X4KG_Dry_Pow_New_Equip_To_Be_Dispatched__c,pbid.get('H9260'),pbup.get('H9260'));
loli=dooli(loli,opid,ss.X6KG_Dry_Pow_New_Equip_To_Be_Dispatched__c,pbid.get('H7788'),pbup.get('H7788'));
loli=dooli(loli,opid,ss.X9KG_Dry_Pow_New_Equip_To_Be_Dispatched__c,pbid.get('H8248'),pbup.get('H8248'));
loli=dooli(loli,opid,ss.X3L_Wet_Chem_New_Equip_To_Be_Dispatched__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Wet_Chem_New_Equip_To_Be_Dispatched__c,pbid.get('H8234'),pbup.get('H8234'));
loli=dooli(loli,opid,ss.X1x1_Fire_Blan_New_Equip_To_Be_Dispatc__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x12_FB_New_Equipment_To_Be_Dispatched__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x18_FB_New_Equipment_To_Be_Dispatched__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.Hose_Reel_19_New_Equip_To_Be_Dispatched__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.ALUnit_New_Equipment_To_Be_Dispatched__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Water_Qty__c,pbid.get('S6LWAT_4005'),pbup.get('S6LWAT_4005'));
loli=dooli(loli,opid,ss.X9L_Water_Qty__c,pbid.get('S9LWAT_4005'),pbup.get('S9LWAT_4005'));
loli=dooli(loli,opid,ss.X3L_Water_Mist_Qty__c,pbid.get('S3LWATM_4005'),pbup.get('S3LWATM_4005'));
loli=dooli(loli,opid,ss.X6L_Water_Mist_Qty__c,pbid.get('S6LWATM_4005'),pbup.get('S6LWATM_4005'));
loli=dooli(loli,opid,ss.X9L_Water_Mist_Qty__c,pbid.get('S9LWATM_4005'),pbup.get('S9LWATM_4005'));
loli=dooli(loli,opid,ss.X2L_AFFF_Qty__c,pbid.get('S2LAFFF'),pbup.get('S2LAFFF'));
loli=dooli(loli,opid,ss.X3L_AFFF_Qty__c,pbid.get('S3LAFFF'),pbup.get('S3LAFFF'));
loli=dooli(loli,opid,ss.X6L_AFFF_Qty__c,pbid.get('S6LAFFF'),pbup.get('S6LAFFF'));
loli=dooli(loli,opid,ss.X9L_AFFF_Qty__c,pbid.get('S9LAFFF'),pbup.get('S9LAFFF'));
loli=dooli(loli,opid,ss.X2KG_CO2_Qty__c,pbid.get('S2KGC'),pbup.get('S2KGC'));
loli=dooli(loli,opid,ss.X5KG_CO2_Qty__c,pbid.get('S5KGC'),pbup.get('S5KGC'));
loli=dooli(loli,opid,ss.X1_KG_Dry_Powder_Qty__c,pbid.get('S1KGDP'),pbup.get('S1KGDP'));
loli=dooli(loli,opid,ss.X2KG_Dry_Powder_Qty__c,pbid.get('S2KGDP'),pbup.get('S2KGDP'));
loli=dooli(loli,opid,ss.X4KG_Dry_Powder_Qty__c,pbid.get('S4KGDP'),pbup.get('S4KGDP'));
loli=dooli(loli,opid,ss.X6KG_Dry_Powder_Qty__c,pbid.get('S6KGDP'),pbup.get('S6KGDP'));
loli=dooli(loli,opid,ss.X9KG_Dry_Powder_Qty__c,pbid.get('S9KGDP'),pbup.get('S9KGDP'));
loli=dooli(loli,opid,ss.X3L_Wet_Chem_Qty__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Wet_Chem_Qty__c,pbid.get('S6LWETC'),pbup.get('S6LWETC'));
loli=dooli(loli,opid,ss.X1X1_Fire_blan_Qty__c,pbid.get('SFIREB'),pbup.get('SFIREB'));
loli=dooli(loli,opid,ss.X12x12_FB_Qty__c,pbid.get('SFIREB'),pbup.get('SFIREB'));
loli=dooli(loli,opid,ss.X12x18_FB_Qty__c,pbid.get('SFIREB'),pbup.get('SFIREB'));
loli=dooli(loli,opid,ss.XHose_Reel_19_Qty__c,pbid.get('SHOSER'),pbup.get('SHOSER'));
loli=dooli(loli,opid,ss.ALUnit_Qty__c,pbid.get('SAL'),pbup.get('SAL'));
loli=dooli(loli,opid,ss.X6L_Water_Re_Charged__c,pbid.get('S6LWATR_4005'),pbup.get('S6LWATR_4005'));
loli=dooli(loli,opid,ss.X9L_Water_Re_Charged__c,pbid.get('S9LWATR_4005'),pbup.get('S9LWATR_4005'));
loli=dooli(loli,opid,ss.X3L_Water_Mist_Re_Charged__c,pbid.get('S3LWATMR_4005'),pbup.get('S3LWATMR_4005'));
loli=dooli(loli,opid,ss.X6L_Water_Mist_Re_charged__c,pbid.get('S6LWATMR_4005'),pbup.get('S6LWATMR_4005'));
loli=dooli(loli,opid,ss.X9L_Water_Mist_Re_Charged__c,pbid.get('S9LWATMR_4005'),pbup.get('S9LWATMR_4005'));
loli=dooli(loli,opid,ss.X2L_AFFF_Re_Charged__c,pbid.get('S2LAFFFR'),pbup.get('S2LAFFFR'));
loli=dooli(loli,opid,ss.X3L_AFFF_Re_Charged__c,pbid.get('S3LAFFFR'),pbup.get('S3LAFFFR'));
loli=dooli(loli,opid,ss.X6L_AFFF_Re_Charged__c,pbid.get('S6LAFFFR'),pbup.get('S6LAFFFR'));
loli=dooli(loli,opid,ss.X9L_AFFF_Re_Charged__c,pbid.get('S9LAFFFR'),pbup.get('S9LAFFFR'));
loli=dooli(loli,opid,ss.X2KG_CO2_Re_Charged__c,pbid.get('S2KGCR'),pbup.get('S2KGCR'));
loli=dooli(loli,opid,ss.X5KG_CO2_Re_Charged__c,pbid.get('S5KGCR'),pbup.get('S5KGCR'));
loli=dooli(loli,opid,ss.X1KG_Dry_Powder_Re_Charged__c,pbid.get('S1KGDPR'),pbup.get('S1KGDPR'));
loli=dooli(loli,opid,ss.X2KG_Dry_Powder_Re_Charged__c,pbid.get('S2KGDPR'),pbup.get('S2KGDPR'));
loli=dooli(loli,opid,ss.X4KG_Dry_Powder_Re_Charged__c,pbid.get('S4KGDPR'),pbup.get('S4KGDPR'));
loli=dooli(loli,opid,ss.X6KG_Dry_Pow_Re_Charged__c,pbid.get('S6KGDPR'),pbup.get('S6KGDPR'));
loli=dooli(loli,opid,ss.X9KG_Dry_Powder_Re_Charged__c,pbid.get('S9KGDPR'),pbup.get('S9KGDPR'));
loli=dooli(loli,opid,ss.X3L_Wet_Chem_Re_Charged__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Wet_Chem_Re_Charged__c,pbid.get('S6LETCR'),pbup.get('S6LETCR'));
loli=dooli(loli,opid,ss.X1x1_Fire_Blan_Re_Charged__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x12_FB_Re_Charged__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x18_FB_Re_Charged__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.XHose_Reel_19_Re_Charged__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.ALUnit_Re_Charged__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X2KG_Dry_Pow_Service_Exchange__c,pbid.get('S2KGDPX'),pbup.get('S2KGDPX'));
loli=dooli(loli,opid,ss.X4KG_Dry_Pow_Service_Exchange__c,pbid.get('S4KGDPX'),pbup.get('S4KGDPX'));
loli=dooli(loli,opid,ss.X6KG_Dry_Powder_Service_Exchange__c,pbid.get('S6KGDPX'),pbup.get('S6KGDPX'));
loli=dooli(loli,opid,ss.X9KG_Dry_Pow_Service_Exchange__c,pbid.get('S9KGDPX'),pbup.get('S9KGDPX'));
loli=dooli(loli,opid,ss.X3L_Wet_Chem_Service_Exchange__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Wet_Chem_Service_Exchange__c,pbid.get('S6LWETCX'),pbup.get('S6LWETCX'));
loli=dooli(loli,opid,ss.X1x1_Fire_Blan_Service_Exchange__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x12_FB_Service_Exchange__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X12x18_FB_Service_Exchange__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.Hose_Reel_19_Service_Exchange__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.ALUnit_Service_Exchange__c,pbid.get('XXXX'),pbup.get('XXXX'));
loli=dooli(loli,opid,ss.X6L_Water_Service_Exchange__c,pbid.get('S6LWATX_4005'),pbup.get('S6LWATX_4005'));
loli=dooli(loli,opid,ss.X9L_Water_Service_Exchange__c,pbid.get('S9LWATX'),pbup.get('S9LWATX'));
loli=dooli(loli,opid,ss.X3L_Water_Mist_Service_Exchange__c,pbid.get('S3LWATMX'),pbup.get('S3LWATMX'));
loli=dooli(loli,opid,ss.X6L_water_mist_Service_Exchange__c,pbid.get('S6LWATMX'),pbup.get('S6LWATMX'));
loli=dooli(loli,opid,ss.X9L_water_mist_Service_Exchange__c,pbid.get('S9LWATMX'),pbup.get('S9LWATMX'));
loli=dooli(loli,opid,ss.X2L_AFFF_Service_Exchange__c,pbid.get('S2LAFFFX'),pbup.get('S2LAFFFX'));
loli=dooli(loli,opid,ss.X3L_AFFF_Service_Exchange__c,pbid.get('S3LAFFFX'),pbup.get('S3LAFFFX'));
loli=dooli(loli,opid,ss.X6L_AFFF_Service_Exchange__c,pbid.get('S6LAFFFX'),pbup.get('S6LAFFFX'));
loli=dooli(loli,opid,ss.X9L_AFFF_Service_Exchange__c,pbid.get('S9LAFFFX'),pbup.get('S9LAFFFX'));
loli=dooli(loli,opid,ss.X2KG_CO2_Service_Exchange__c,pbid.get('S2KGCX'),pbup.get('S2KGCX'));
loli=dooli(loli,opid,ss.X5KG_CO2_Service_Exchange__c,pbid.get('S5KGCX'),pbup.get('S5KGCX'));
loli=dooli(loli,opid,ss.X1KG_Dry_Pow_Service_Exchange__c,pbid.get('S1KGDPX'),pbup.get('S1KGDPX'));
    
    
}
}
if(loli.size()>0){
    insert loli;
    loli.clear();
}
}   
//}catch(Exception exall){}
public List<OpportunityLineItem> dooli(List<OpportunityLineItem>floli,
                                       Id fopid,
                                       Decimal fquant,
                                       Id fpbe,
                                       Double fup){
//try{
if(fopid!=null&&fquant!=null&&fquant>0.0&&fpbe!=null&&fup!=null){
    OpportunityLineItem oli = new OpportunityLineItem(
    OpportunityID = fopid,
    PricebookEntryID = fpbe,
    Quantity = fquant,
    UnitPrice = fup
    );
    floli.add(oli);
    if(floli.size()>95){
        insert floli;
        floli.clear();
    }
}
//}catch(Exception exdooli){}
return floli;                                           
                                     }
*/  
}