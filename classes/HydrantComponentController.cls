public class HydrantComponentController 
{ 
    public String mSSId {get;set;}//{get;
    //set{mSSId = value;}}
       
    public class MechanicalServiceSheetWrapper //Wrapper Class for retrieving and storing data Certificate Preview.
    {
    
  
        public String systemType{get;set;}
        public String quantity{get;set;}
        public String visitType{get;set;}
        public String inletLocations{get;set;}
        public String type{get;set;}
        public String cabinet{get;set;}
       
    }
     
    
    public class OutletSection
    {
        public String outletLocation{get;set;}
        public List<SelectOption> lci{get;set;}
        public List<SelectOption> seal{get;set;}
        public List<SelectOption> wheel{get;set;}
        public List<SelectOption> sign{get;set;}
        public List<SelectOption> valve{get;set;}
        public List<SelectOption> pipeWork{get;set;}
        
        public String staticPressure{get;set;}
        public String finalPressure{get;set;}
        public String times{get;set;}
        public String mins{get;set;}
        public String flowRate{get;set;}
        
        public String selectedlci{get;set;}
        public String selectedseal{get;set;}
        public String selectedwheel{get;set;}
        public String selectedsign{get;set;}
        public String selectedvalve{get;set;}
        public String selectedpipeWork{get;set;}
        
        public Boolean pass{get;set;}
        public Boolean fail{get;set;}
    }
  
   
    public Boolean pass{get;set;}
    List<MechanicalServiceSheetWrapper > mechServSheetList = new List<MechanicalServiceSheetWrapper > () ;
    public Mechanical_Service_Sheet__c mechsersht = new Mechanical_Service_Sheet__c();
     
    public List<MechanicalServiceSheetWrapper> getSystemDetails()// For populating System Details
    {  
   
        Mechanical_Service_Sheet__c mechsersht = new Mechanical_Service_Sheet__c();
       // System.assertEquals('1',mSSId);
        if(mSSId!=null||mSSId!='')
        {
           //System.assertEquals('1',mSSId);
           try{
                mechsersht= [select Id,Result__c,System_Type1__c,Quantity__c,Visit_Type__c,Inlet_Location__c,Type__c,Cabinet__c,Outlet_Location_Long__c from Mechanical_Service_Sheet__c where Id=:mSSId];
                 //System.assertEquals(null,mechsersht);
                 System.Debug('####'+mechsersht);
                //System.assertEquals(null,[select Id,Result__c,System_Type__c,Quantity__c,Visit_Type__c,Inlet_Location__c,Type__c,Cabinet__c,Outlet_Location_Long__c from Mechanical_Service_Sheet__c where Id=:mSSId]);
            }catch(Exception e){
                //System.assertEquals(e.getMessage(),null);
            }
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
                //Mechanical_Service_Sheet__c servSheetVals = [select Id,System_Type__c,Quantity__c,Visit_Type__c,Inlet_Location__c,Type__c,Cabinet__c,Outlet_Location_Long__c from Mechanical_Service_Sheet__c where Id=:ApexPages.currentPage().getParameters().get('id') limit 1];    
                List<String> sysTyp,quant,vsitTyp,inLoc,typ,cabnet,outLoc;    
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
                    for(Integer iterator=0;iterator<sysTyp.size()-1;iterator++)
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
                        mechServSheetList.add(instance);
                    }
                }
            }
            return mechServSheetList;
        }
        else
        {
            System.assertEquals('I will return Null','I give up');
            return null;
            
        }
        
        // return null;
    }
       
    public List<OutletSection> outletSectionWrapper = new List<OutletSection>();
    public List<OutletSection> getOutletLocations()
    {
         if(mSSId!=null||mSSId!='')
        {
            mechsersht= [Select Id,Outlet_Location_Long__c from Mechanical_Service_Sheet__c where Id=:mSSId limit 1];
            
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
                        instan.pipework = new List<SelectOption>();
                        instan.pipework.add(new SelectOption('Pass','Pass'));
                        instan.pipework.add(new SelectOption('Fail','Fail'));
                        
                        
                        instan.outletLocation = iterator.split(',',-1)[0];
                        instan.selectedlci = iterator.split(',',-1)[1];
                        instan.selectedseal = iterator.split(',',-1)[2]; 
                        instan.selectedwheel = iterator.split(',',-1)[3];
                        instan.selectedsign = iterator.split(',',-1)[4];
                        instan.selectedvalve = iterator.split(',',-1)[5];
                        instan.selectedpipeWork = iterator.split(',',-1)[6];
                        instan.staticPressure = iterator.split(',',-1)[7];
                        instan.finalPressure = iterator.split(',',-1)[8];
                        instan.times= iterator.split(',',-1)[9];
                        instan.mins= iterator.split(',',-1)[10];
                        instan.flowRate= iterator.split(',',-1)[11];
                        instan.pass = Boolean.valueOf(iterator.split(',',-1)[12]);
                        instan.fail = Boolean.valueOf(iterator.split(',',-1)[13]);
                        outletSectionWrapper.add(instan);
                    }
                }
            }
            return outletSectionWrapper;
        }
        else
        {
            return null;
        }
    }
}