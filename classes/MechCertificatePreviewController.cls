public class MechCertificatePreviewController {  
    public MechCertificatePreviewController(ApexPages.StandardController controller) {

    }
    public Boolean pass{get;set;}
    public class MechanicalServiceSheetWrapper //Wrapper Class for retrieving and storing data Certificate Preview.
    {
        public String systemType{get;set;}
        public String quantity{get;set;}
        public String visitType{get;set;}
        public String inletLocations{get;set;}
        public String type{get;set;}
        public String cabinet{get;set;}
        public String StaticPressure{get;set;}
        public String Times{get;set;}
        public String FinalPressure{get;set;}
        public String Pipework{get;set;}
        public String Pass{get;set;}
        public String Fail{get;set;}
    }
    public class OutletSection
    {
        public String outletLocation{get;set;}
        public List<SelectOption> lci{get;set;}
        public List<SelectOption> seal{get;set;}
        public List<SelectOption> wheel{get;set;}
        public List<SelectOption> sign{get;set;}
        public List<SelectOption> valve{get;set;}
        public String selectedlci{get;set;}
        public String selectedseal{get;set;}
        public String selectedwheel{get;set;}
        public String selectedsign{get;set;}
        public String selectedvalve{get;set;}
        public String pressure{get;set;}
        public Boolean pass{get;set;}
        public Boolean fail{get;set;}
    }
    
    
    List<MechanicalServiceSheetWrapper > mechServSheetList = new List<MechanicalServiceSheetWrapper >();
    public List<OutletSection> outletSectionWrapper = new List<OutletSection>();
    Mechanical_Service_Sheet__c mechsersht= [select Id,Result__c,System_Type1__c,Quantity__c,Visit_Type__c,Inlet_Location__c,Type__c,Cabinet__c,Static_Pressure__c,Time__c,Final_Pressure__c,Pipework__c,Pass_System_Location__c,Fail_System_Location__c,Outlet_Location_Long__c from Mechanical_Service_Sheet__c where Id=:ApexPages.currentPage().getParameters().get('id') limit 1];
    public List<MechanicalServiceSheetWrapper> getSystemDetails()// For populating System Details
    {    
        //System.assertEquals(mechServSheetList,null);
        if(mechsersht.Result__c=='Pass')
        {
            pass = true;
        }
        else
        {
            pass = false;
        }
        if(mechServSheetList.isEmpty())//Avoids list getting repopulated with same Values over and over again.
        {
            //Mechanical_Service_Sheet__c servSheetVals = [select Id,System_Type1__c,Quantity__c,Visit_Type__c,Inlet_Location__c,Type__c,Cabinet__c,Outlet_Location_Long__c from Mechanical_Service_Sheet__c where Id=:ApexPages.currentPage().getParameters().get('id') limit 1];    
            List<String> sysTyp,quant,vsitTyp,inLoc,typ,cabnet,StPress,pipework,Tims,FinalPress,pas,fil,outLoc;    
            if(mechsersht.System_Type1__c!=null && mechsersht!=null)// Only if fields from which the data is getting filled are populated.
            {
                sysTyp = mechsersht.System_Type1__c.split(';',-1);
                if(mechsersht.Quantity__c!=null)
                    quant = mechsersht.Quantity__c.split(';',-1);
                if(mechsersht.Visit_Type__c!=null)
                    vsitTyp= mechsersht.Visit_Type__c.split(';',-1);
                if(mechsersht.Inlet_Location__c!=null)
                    inLoc = mechsersht.Inlet_Location__c.split(';',-1);
                if(mechsersht.Type__c!=null)
                   typ = mechsersht.Type__c.split(';',-1);
                if(mechsersht.Cabinet__c!=null)
                   cabnet = mechsersht.Cabinet__c.split(';',-1);
                if(mechsersht.Static_Pressure__c!=null)
                   StPress = mechsersht.Static_Pressure__c.split(';',-1);
                if(mechsersht.Time__c!=null)
                   Tims = mechsersht.Time__c.split(';',-1);
                if(mechsersht.Final_Pressure__c!=null)
                   FinalPress = mechsersht.Final_Pressure__c.split(';',-1);
                if(mechsersht.Pipework__c!=null)
                   pipework = mechsersht.Pipework__c.split(';',-1);
                if(mechsersht.Pass_System_Location__c!=null)
                   pas = mechsersht.Pass_System_Location__c.split(';',-1);   
                if(mechsersht.Fail_System_Location__c!=null)
                   fil = mechsersht.Fail_System_Location__c.split(';',-1);   
                             
                for(Integer iterator=0;iterator<sysTyp.size();iterator++)
                {
                    MechanicalServiceSheetWrapper instance = new MechanicalServiceSheetWrapper();
                    if(sysTyp!=null)
                    instance.systemType = sysTyp[iterator];
                    if(quant!=null)
                    instance.quantity = quant[iterator];
                    if(vsitTyp!=null)
                    instance.visitType = vsitTyp[iterator];
                    if(inLoc!=null)
                    instance.inletLocations = inLoc[iterator];
                    if(typ!=null)
                    instance.type = typ[iterator];
                    if(cabnet!=null)
                    instance.cabinet = cabnet[iterator];
                    if(StPress!=null)
                    instance.StaticPressure = StPress[iterator];
                    if(Tims !=null)
                    instance.Times = Tims [iterator];
                    if(FinalPress!=null)
                    instance.FinalPressure= FinalPress[iterator];
                    if(pipework!=null)
                    instance.Pipework= pipework[iterator];
                    if(pas!=null)
                    instance.Pass = pas[iterator];
                    if(fil!=null)
                    instance.Fail= fil[iterator];
                    mechServSheetList.add(instance);
                }
            }
        }
        return mechServSheetList;
    }
    
    public List<OutletSection> getOutletLocations()
    {
        if(outletSectionWrapper.isEmpty())
        {
            //Mechanical_Service_Sheet__c mechsersht= [select Outlet_Location_Long__c from Mechanical_Service_Sheet__c where Id=:ApexPages.currentPage().getParameters().get('id')];
            if(mechsersht.Outlet_Location_Long__c!=null)
            {
                List<String> outletData = mechsersht.Outlet_Location_Long__c.split(';',-1);
                outletData.remove(outletData.size()-1);
                for(String iterator:outletData)
                {
                    OutletSection instan = new OutletSection();
                    
                    instan.lci = new List<SelectOption>();
                    instan.lci.add(new SelectOption('Pass','Pass'));
                    instan.lci.add(new SelectOption('Fail','Fail'));
                    instan.seal = new List<SelectOption>();
                    instan.seal.add(new SelectOption('Pass','Pass'));
                    instan.seal.add(new SelectOption('Fail','Fail'));
                    instan.wheel= new List<SelectOption>();
                    instan.wheel.add(new SelectOption('Pass','Pass'));
                    instan.wheel.add(new SelectOption('Fail','Fail'));
                    instan.sign= new List<SelectOption>();
                    instan.sign.add(new SelectOption('Pass','Pass'));
                    instan.sign.add(new SelectOption('Fail','Fail'));
                    instan.valve = new List<SelectOption>();
                    instan.valve.add(new SelectOption('Pass','Pass'));
                    instan.valve.add(new SelectOption('Fail','Fail'));
                    
           
                    
                    instan.outletLocation = iterator.split(',',-1)[0];
                    instan.selectedlci = iterator.split(',',-1)[1];
                    instan.selectedseal = iterator.split(',',-1)[2]; 
                    instan.selectedwheel = iterator.split(',',-1)[3];
                    instan.selectedsign = iterator.split(',',-1)[4];
                    instan.selectedvalve = iterator.split(',',-1)[5];
                   /*  instan.pressure = iterator.split(',',-1)[6];
                    instan.pass = Boolean.valueOf(iterator.split(',',-1)[7]);
                    instan.fail = Boolean.valueOf(iterator.split(',',-1)[8]);  */
                    if(iterator.split(',',-1).size()>8){ 
                        instan.pressure = iterator.split(',',-1)[6];
                        instan.pass = Boolean.valueOf(iterator.split(',',-1)[7]);
                        instan.fail = Boolean.valueOf(iterator.split(',',-1)[8]);
                    }else{                       //Handling old records
                        instan.pass = Boolean.valueOf(iterator.split(',',-1)[6]);
                        instan.fail = Boolean.valueOf(iterator.split(',',-1)[7]);
                    }
                    
                    
                    outletSectionWrapper.add(instan);
                }
            }
        }
        return outletSectionWrapper;
    }
  
}