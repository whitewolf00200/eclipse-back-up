public class LocationlistController {

    public boolean isEdit{get;set;}
    public boolean isSaved{get;set;}
    public String selectedValue{get;set;}
    public Boolean flag {get;set;}
    
    
      String[] zone = new String[]{};
    
    public List<SelectOption> getItems() {
                            List<SelectOption> options = new List<SelectOption>();
                            options.add(new SelectOption('',''));
                            options.add(new SelectOption('1','1'));
                            options.add(new SelectOption('2','2'));
                            options.add(new SelectOption('3','4'));
                            options.add(new SelectOption('5','5'));
                            options.add(new SelectOption('6','6'));
                            options.add(new SelectOption('7','7'));
                            options.add(new SelectOption('8','8'));
                            options.add(new SelectOption('9','9'));
                            options.add(new SelectOption('10','10'));
                            options.add(new SelectOption('11','12'));
                            options.add(new SelectOption('13','13'));
                            options.add(new SelectOption('14','14'));
                            options.add(new SelectOption('15','15'));
                            options.add(new SelectOption('16','16'));
                            options.add(new SelectOption('17','17'));
                            options.add(new SelectOption('18','18'));
                            options.add(new SelectOption('19','19'));
                            options.add(new SelectOption('20','20'));
                            options.add(new SelectOption('21','21'));
                            options.add(new SelectOption('22','22'));
                            options.add(new SelectOption('23','23'));
                            options.add(new SelectOption('24','24'));
                            options.add(new SelectOption('25','25'));
                            options.add(new SelectOption('26','26'));
                            options.add(new SelectOption('27','27'));
                            options.add(new SelectOption('28','28'));
                            options.add(new SelectOption('29','29'));
                            options.add(new SelectOption('30','30'));
                            options.add(new SelectOption('31','31'));
                            options.add(new SelectOption('32','32'));
                            options.add(new SelectOption('33','33'));
                            options.add(new SelectOption('34','34'));
                            options.add(new SelectOption('35','35'));
                            options.add(new SelectOption('36','36'));
                            options.add(new SelectOption('37','37'));
                            options.add(new SelectOption('38','38'));
                            options.add(new SelectOption('39','39'));
                            options.add(new SelectOption('40','40'));
                            options.add(new SelectOption('41','41'));
                            options.add(new SelectOption('42','42'));
                            options.add(new SelectOption('43','43'));
                            options.add(new SelectOption('44','44'));
                            options.add(new SelectOption('45','45'));
                            options.add(new SelectOption('46','46'));
                            options.add(new SelectOption('47','47'));
                            options.add(new SelectOption('48','48'));
                            options.add(new SelectOption('49','49'));
                            options.add(new SelectOption('50','50'));
                            
                            return options;
                        }
                         
                          public String[] getZone  () {
                            return Zone;
                        }
                          
                        public void setZone (String[] Zone) {
                            this.Zone= Zone;
                            }
    
    String[] assettyp = new String[]{};
    public List<SelectOption> getValue() {
                            List<SelectOption> options = new List<SelectOption>();
                            options.add(new SelectOption('',''));
                            options.add(new SelectOption('Base','Base'));
                            options.add(new SelectOption('Beacon','Beacon'));
                            options.add(new SelectOption('Breakglass Callpoint','Breakglass Callpoint'));
                            options.add(new SelectOption('Door Release','Door Release'));
                            options.add(new SelectOption('EL Tube','EL Tube'));
                            options.add(new SelectOption('Fire Bell','Fire Bell'));
                            options.add(new SelectOption('Heat Detector','Heat Detector'));
                            options.add(new SelectOption('Heat Sounder','Heat Sounder'));
                            options.add(new SelectOption('Nicad Hi-Temp Cells X','Nicad Hi-Temp Cells X'));
                            options.add(new SelectOption('Other','Other'));
                            options.add(new SelectOption('Printer Consumables','Printer Consumables'));
                            options.add(new SelectOption('SLA Battery','SLA Battery'));
                            options.add(new SelectOption('Smoke Detector','Smoke Detector'));
                            options.add(new SelectOption('Smoke Sounder','Smoke Sounder'));
                            options.add(new SelectOption('Test Keys','Test Keys'));
                            options.add(new SelectOption('Breakglass Release','Breakglass Release'));
                            options.add(new SelectOption('Camera','Camera'));
                            options.add(new SelectOption('Door Contact','Door Contact'));
                            options.add(new SelectOption('Electronic Sounder','Electronic Sounder'));
                            options.add(new SelectOption('Glass Detector','Glass Detector'));
                            options.add(new SelectOption('Housing','Housing'));
                            options.add(new SelectOption('Maglock','Maglock'));
                            options.add(new SelectOption('PIR','PIR'));
                            options.add(new SelectOption('Proxi Card','Proxi Card'));
                            options.add(new SelectOption('Proxi Reader','Proxi Reader'));
                            options.add(new SelectOption('6L Water','6L Water'));
                            options.add(new SelectOption('9L Water','9L Water'));
                            options.add(new SelectOption('3L Water Mist','3L Water Mist'));
                            options.add(new SelectOption('6L Water Mist','6L Water Mist'));
                            options.add(new SelectOption('9L Water Mist','9L Water Mist'));
                            options.add(new SelectOption('2L AFFF','2L AFFF'));
                            options.add(new SelectOption('3L AFFF','3L AFFF'));
                            options.add(new SelectOption('6L AFFF','6L AFFF'));
                            options.add(new SelectOption('9L AFFF','9L AFFF'));
                            options.add(new SelectOption('2KG CO2','2KG CO2'));
                            options.add(new SelectOption('5KG CO2','5KG CO2'));
                            options.add(new SelectOption('1KG Dry Powder','1KG Dry Powder'));
                            options.add(new SelectOption('2KG Dry Powder','2KG Dry Powder'));
                            options.add(new SelectOption('4KG Dry Powder','4KG Dry Powder'));
                            options.add(new SelectOption('6KG Dry Powder','6KG Dry Powder'));
                            options.add(new SelectOption('9KG Dry Powder','9KG Dry Powder'));
                            options.add(new SelectOption('3L Wet Chemical','3L Wet Chemical'));
                            options.add(new SelectOption('6L Wet Chemical','6L Wet Chemical'));
                            options.add(new SelectOption('1x1m Fire Blanket','1x1m Fire Blanket'));
                            options.add(new SelectOption('1.2x1.2m Fire Blanket','1.2x1.2m Fire Blanket'));
                            options.add(new SelectOption('1.2 x 1.8m Fire Blanket','1.2 x 1.8m Fire Blanket'));
                            options.add(new SelectOption('Hose Reel 19mm','Hose Reel 19mm'));
                            options.add(new SelectOption('Alarm Unit','Alarm Unit'));
                            
                            
                            return options;
                        }
                         
                          public String[] getassettyp   () {
                            return assettyp ;
                        }
                          
                        public void setassettyp    (String[] assettyp ) {
                            this.assettyp = assettyp ;
                            }
   
    public LocationlistController(ApexPages.StandardController controller) {
    
      flag = false;
      isEdit=false;
      isSaved = true;

    }
    
     public class SystemLocationWrapper
    {
        public String systemLocation{get;set;}
        public String area{get;set;}
        public String zone{get;set;}
        public String assettyp{get;set;}
        
    }
    Location_List__c Locate = [select Id,Location_Description__c,Area__c,Zone__c,Asset_Type__c  from Location_List__c where id=:ApexPages.CurrentPage().getParameters().get('id')];
    List<SystemLocationWrapper> liSystemLocation = new List<SystemLocationWrapper>();
    
        
                            
    public List<SystemLocationWrapper> getSystemLocation()
    
    {
        if(liSystemLocation.isEmpty())
        {
          if(Locate.Location_Description__c!=null)
            {
                List<String> Locdes,are,zoneplace,astyp;
                Locdes=Locate.Location_Description__c.split(';',-1);
                for(Integer iterator=0;iterator<Locdes.size()-1;iterator++)
                {
                    SystemLocationWrapper instance = new SystemLocationWrapper();
                    instance.systemLocation = Locdes[iterator]; 
                    if(Locate.Area__c!=null)
                    {
                        are= Locate.Area__c.split(';',-1);
                        instance.area = are[iterator];
                    }
                    else
                    {
                        instance.area=''; 
                    }
                    if(Locate.Zone__c!=null)
                    {
                        zoneplace= Locate.Zone__c.split(';',-1);
                        instance.zone = zoneplace[iterator];
                    }
                    else
                    {
                        instance.zone =''; 
                    }
                    if(Locate.Asset_Type__c  !=null)
                    {
                        astyp= Locate.Asset_Type__c  .split(';',-1);
                        instance.assettyp= astyp[iterator];
                        
                           
                    }
                    else
                    {
                        instance.assettyp=''; 
                    }
                   
                    liSystemLocation.add(instance);
                }
                
                
            }
        }
        return liSystemLocation;
    }
   
       public void addSystemLocations(){
         
         SystemLocationWrapper instance = new SystemLocationWrapper();
         
         liSystemLocation.add(instance);
          
    }
    
    public PageReference saveSystemLocations()
    {    
        system.debug(flag + '>>>>>>>>>>>>>>>>>>>>> FLAg');
        system.debug(liSystemLocation+ '>>>>>>>>>>>>>>>>>>>>> LIST');
        if(flag)
        {
            liSystemLocation=new List<SystemLocationWrapper>();
        }
        String locdescr='',locarea='',loczone='',locass='';
        Boolean isError=false;
        Boolean isError2=false;
        Boolean isError3=false;
        Set<String> avoidDuplicate =  new Set<String>();
        for(SystemLocationWrapper iterator:liSystemLocation)
        {
            avoidDuplicate.add(iterator.systemLocation);
            if(locdescr=='')
            {
                if(iterator.systemLocation=='')
                {
                    isError2 = true;
                }
                locdescr = iterator.systemLocation;
                locarea = iterator.area;
                loczone = iterator.zone;
                locass = iterator.assettyp;
               
            }
            else
            {
                if(iterator.systemLocation=='')
                {
                    isError2 = true;
                }
                locdescr = locdescr + ';' + iterator.systemLocation;
                locarea = locarea + ';' + iterator.area;
                loczone = loczone + ';' + iterator.zone;
                locass = locass + ';' + iterator.assettyp;
                
            }
        }
        if(liSystemLocation.size()!=avoidDuplicate.size())
        {
            isError = true;
        }
        if(isError)
        {
            ApexPages.Message myMsg=new ApexPages.Message(ApexPages.Severity.Error, 'Please do not repeat same Names for Locations List');
            ApexPages.addMessage(myMsg);
        }
        else if(isError2)
        {
            ApexPages.Message myMsg=new ApexPages.Message(ApexPages.Severity.Error, 'Cannot save without System Location. Please enter a name for Location List or remove the row.');
            ApexPages.addMessage(myMsg);
        }
        else
        {            
            Locate.Location_Description__c= locdescr+';'; 
            Locate.Area__c= locarea+';';
            Locate.Zone__c= loczone+';';
            Locate.Asset_Type__c  = locass+';';
         
            try{
                database.update(Locate);
                isEdit=false;
                isSaved = true;
            }catch(Exception e){
                ApexPages.Message myMsg=new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
                ApexPages.addMessage(myMsg); 
                PageReference redirectPage=new PageReference('apex/Locationlist'); 
                redirectPage.setRedirect(true);
                return redirectPage; 
                 
            }
        }
        
        return null;
    }
    public PageReference editSystemLocations()
    {
        isEdit=true;
        isSaved = false;
        return null;
    }
    public PageReference remove()
    {    
        Integer listSize = liSystemLocation.size();
        system.debug(listSize + '>>>>>>>>>>>>>>>>>>>>> SIZE');
        selectedValue=ApexPages.currentPage().getParameters().get('removeRow');
        system.debug(selectedValue + '>>>>>>>>>>>>>>>>>>>>> ONE');
        Integer rowIndex;
        for(Integer i=0;i<liSystemLocation.size();i++)
        {
            if(liSystemLocation[i].systemLocation==selectedValue)
            {
                rowIndex=i;
            }
        }
        system.debug(rowIndex + '>>>>>>>>>>>>>>>>>>>>> INDEX');
        liSystemLocation.remove(rowIndex);
        if(liSystemLocation.size()==0){
            liSystemLocation.clear();
            flag = true;
         }else{
             flag = false;
         }
            
       
        
      
         //system.debug(liSystemLocation+ '>>>>>>>>>>>>>>>>>>>>> LIST');
        return null;
    }
}