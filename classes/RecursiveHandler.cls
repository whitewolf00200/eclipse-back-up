public class RecursiveHandler{
    //Initialize the variable and set the static value
     private static boolean runRSTH_TRLC= true;
    private static boolean run = true;
    private static boolean run1 = true;   
    private static boolean runCTH_UPC = true;
    private static boolean runSSTH_UOPLD = true; 
    private static boolean runSSTH_ULELD = true; 
    private static boolean runSSTH_ULSSD = true; 
    private static boolean runSSTH_USVT = true; 
    private static boolean runSSTH_UVCT = true;
    private static boolean runSSTH_UPON = true;
    private static boolean runSSTH_TRLCR = true;
    private static boolean runSSTH_UVRF = true; 
    private static boolean runSSTH_UVC = true; 
    private static boolean runMSSSSOB= true;
    private static boolean runMSSSSTH_UOPLD = true;
    private static boolean runMSSSSTH_UVOLT = true; 
    private static boolean runOTH_SEA= true; 
    private static boolean runSSOAD_Trigger= true;
    private static boolean runOTH_CCOPP= true;
    private static boolean runOTH_SINAB= true;
    private static boolean runOTH_USRS= true;
    private static boolean runOTH_SRI= true;
    private static boolean runOTH_USST= true;
    private static boolean runOTH_UAF = true;
    private static boolean runOTH_USVT= true;
    private static boolean runACC_USCT= true;
    private static boolean runVT_UOPP= true;
    private static boolean runVT_USSN= true;
    private static boolean runVT_UST = true;
    private static boolean runVT_UNEV= true;
    private static boolean runVT_UMSSST=true;
    private static boolean runSW_UVC= true;
    private static boolean runSW_USVT= true;
    private static boolean runSW_UPON= true; 
    private static boolean runPS_USVT= true;
    private static boolean runPS_UVC= true;
    private static boolean runPS_UPON= true;
    private static boolean runPS_UVOLT= true;
    private static boolean runMSSSSTH_UVC= true;
    private static boolean runMSSSSTH_UPON= true;
    private static boolean runMSSSSTH_UST= true;
    private static boolean runNV_Trigger= true;
    private static boolean runRV_Trigger= true;
    private static boolean runRO_Trigger= true;
    private static boolean runRSTH_UPON= true;
    private static boolean runRSTH_UST= true;
    private static boolean runSSO_Trigger=true;
    private static boolean runSSV_Trigger=true;
    private static boolean runSSOAFE_Trigger=true;
    private static boolean runSSOB_Trigger=true; 
    private static boolean runOH_UMSSSAU=true;
    private static boolean runPO_Trigger= true; 
    private static boolean runPV_Trigger=true;
    public static boolean runMSSTH_ULMSSD=true;
    public static boolean runACC_UALOnce=true;
    public static boolean runServiceM8PostOnce=true;
    
     //UpdateAmsecLogo control
    public static boolean runACC_UALOnce(){
        if(runACC_UALOnce){
            runACC_UALOnce=false;
            return true;
        }else{
            return runACC_UALOnce;
        }
    }
    
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
    //Controls Complaint Trigger Handler
    public static boolean runCTH_UPCOnce(){
        if(runCTH_UPC){
            runCTH_UPC=false;
            return true;
        }else{
            return runCTH_UPC;
        }
    }
    
    //Controls Reactive Sheet Trigger Handler
     public static boolean runRSTH_UPONOnce(){
        if(runRSTH_UPON){
            runRSTH_UPON=false;
            return true;
        }else{
            return runRSTH_UPON;
        }
    }
     public static boolean runRSTH_USTOnce(){
        if(runRSTH_UST){
            runRSTH_UST=false;
            return true;
        }else{
            return runRSTH_UST;
        }
    }
    
    //Controls Opportunity Trigger Handler
     public static boolean runOTH_USSTOnce(){
        if(runOTH_USST){
            runOTH_USST=false;
            return true;
        }else{
            return runOTH_USST;
        }
    }
    public static boolean runOTH_UAFOnce(){
        if(runOTH_UAF){
            runOTH_UAF=false;
            return true;
        }else{
            return runOTH_UAF;
        }
    }
     public static boolean runOTH_USVTOnce(){
        if(runOTH_USVT){
            runOTH_USVT=false;
            return true;
        }else{
            return runOTH_USVT;
        }
    }
    
    //Controls the updateMSSServiceTypeAU Method in OpportunityHandler Class
    public static boolean runOH_UMSSSAUOnce(){
        if(runOH_UMSSSAU){
            runOH_UMSSSAU=false;
            return true;
        }else{
            return runOH_UMSSSAU;
        }
    }
    //Controls the ServSheetVisit Trigger
    public static boolean runSSV_TriggerOnce(){
        if(runSSV_Trigger){
            runSSV_Trigger=false;
            return true;
        }else{
            return runSSV_Trigger;
        }
    }
    //Controls the ServSheetOpp Trigger
    public static boolean runSSO_TriggerOnce(){
        if(runSSO_Trigger){
            runSSO_Trigger=false;
            return true;
        }else{
            return runSSO_Trigger;
        }
    }
    //Controls the ServSheetOppAutoFE Trigger
    public static boolean runSSOAFE_TriggerOnce(){
        if(runSSOAFE_Trigger){
            runSSOAFE_Trigger=false;
            return true;
        }else{
            return runSSOAFE_Trigger;
        }
    }
    //Controls the ServSheetOppBasic Trigger
    public static boolean runSSOB_TriggerOnce(){
        if(runSSOB_Trigger){
            runSSOB_Trigger=false;
            return true;
        }else{
            return runSSOB_Trigger;
        }
    }
    
    //Controls the NextVisit Trigger
    public static boolean runNV_TriggerOnce(){
        if(runNV_Trigger){
            runNV_Trigger=false;
            return true;
        }else{
            return runNV_Trigger;
        }
    }
     //Controls the ReactiveVisit Trigger
    public static boolean runRV_TriggerOnce(){
        if(runRV_Trigger){
            runRV_Trigger=false;
            return true;
        }else{
            return runRV_Trigger;
        }
    }
    //Controls the ProjectVisit Trigger
    public static boolean runPV_TriggerOnce(){
        if(runPV_Trigger){
            runPV_Trigger=false;
            return true;
        }else{
            return runPV_Trigger;
        }
    }
    //Opportunity Trigger Handler COntrol
    public static boolean runOTH_SINABOnce(){
        if(runOTH_SINAB){
            runOTH_SINAB=false;
            return true;
        }else{
            return runOTH_SINAB;
        }
    }
     //Controls the ReactiveOpp Trigger
    public static boolean runRO_TriggerOnce(){
        if(runRO_Trigger){
            runRO_Trigger=false;
            return true;
        }else{
            return runRO_Trigger;
        }
    }
    
    //Controls the ProjectOpp Trigger
    public static boolean runPO_TriggerOnce(){
        if(runPO_Trigger){
            runPO_Trigger=false;
            return true;
        }else{
            return runPO_Trigger;
        }
    }
    
    //MSS SS Trigger Handler
    public static boolean runMSSSSTH_UVCOnce(){
        if(runMSSSSTH_UVC){
            runMSSSSTH_UVC=false;
            return true;
        }else{
            return runMSSSSTH_UVC;
        }
    } 
    
    public static boolean runMSSSSTH_UPONOnce(){
        if(runMSSSSTH_UPON){
            runMSSSSTH_UPON=false;
            return true;
        }else{
            return runMSSSSTH_UPON;
        }
    } 
    
    public static boolean runMSSSSTH_USTOnce(){
        if(runMSSSSTH_UST){
            runMSSSSTH_UST=false;
            return true;
        }else{
            return runMSSSSTH_UST;
        }
    } 
    
    public static boolean runMSSSSTH_UOPLDOnce(){
        if(runMSSSSTH_UOPLD ){
            runMSSSSTH_UOPLD =false;
            return true;
        }else{
            return runMSSSSTH_UOPLD ;
        }
    }
     public static boolean runMSSSSTH_UVOLTOnce(){
        if(runMSSSSTH_UVOLT ){
            runMSSSSTH_UVOLT =false;
            return true;
        }else{
            return runMSSSSTH_UVOLT ;
        }
    }
    
      public static boolean runRSTH_TRLCOnce(){
        if(runRSTH_TRLC){
            runRSTH_TRLC=false;
            return true;
        }else{
            return runRSTH_TRLC;
        }
    }
    
    public static boolean runMSSTH_ULMSSDOnce(){
        if(runMSSTH_ULMSSD){
            runMSSTH_ULMSSD=false;
            return true;
        }else{
            return runMSSTH_ULMSSD;
        }
    } 
    
    //Small Works Trigger Handler Control
    public static boolean runSW_UPONOnce(){
        if(runSW_UPON){
            runSW_UPON=false;
            return true;
        }else{
            return runSW_UPON;
        }
    }
     public static boolean runSW_USVTOnce(){
        if(runSW_USVT){
            runSW_USVT=false;
            return true;
        }else{
            return runSW_USVT;
        }
    }
    public static boolean runSW_UVCOnce(){
        if(runSW_UVC){
            runSW_UVC=false;
            return true;
        }else{
            return runSW_UVC;
        }
    }
     //Project Sheet Trigger Handler Control
    public static boolean runPS_USVTOnce(){
        if(runPS_USVT){
            runPS_USVT=false;
            return true;
        }else{
            return runPS_USVT;
        }
    }
    public static boolean runPS_UPONOnce(){
        if(runPS_UPON){
            runPS_UPON=false;
            return true;
        }else{
            return runPS_UPON;
        }
    }
     public static boolean runPS_UVOLTOnce(){
        if(runPS_UVOLT){
            runPS_UVOLT=false;
            return true;
        }else{
            return runPS_UVOLT;
        }
    }
    public static boolean runPS_UVCOnce(){
        if(runPS_UVC){
            runPS_UVC=false;
            return true;
        }else{
            return runPS_UVC;
        }
    }
    //Visit Trigger Handler Control 
    public static boolean runVT_USSNOnce(){
        if(runVT_USSN){
            runVT_USSN=false;
            return true;
        }else{
            return runVT_USSN;
        }
    }
    public static boolean runVT_UMSSSTOnce(){
        if(runVT_UMSSST){
            runVT_UMSSST=false;
            return true;
        }else{
            return runVT_UMSSST;
        }
    }
    public static boolean runVT_USTOnce(){
        if(runVT_UST){
            runVT_UST=false;
            return true;
        }else{
            return runVT_UST;
        }
    }
    public static boolean runVT_UNEVOnce(){
        if(runVT_UNEV){
            runVT_UNEV=false;
            return true;
        }else{
            return runVT_UNEV;
        }
    }
    public static boolean runVT_UOPPOnce(){
        if(runVT_UOPP){
            runVT_UOPP=false;
            return true;
        }else{
            return runVT_UOPP;
        }
    }
    //Account Trigger Handler Control
    public static boolean runACC_USCTOnce(){
        if(runACC_USCT){
            runACC_USCT=false;
            return true;
        }else{
            return runACC_USCT;
        }
    }
    
    public static boolean runOTH_CCOPPOnce(){
        if(runOTH_CCOPP){
            runOTH_CCOPP=false;
            return true;
        }else{
            return runOTH_CCOPP;
        }
    }
    public static boolean runOTH_USRSOnce(){
        if(runOTH_USRS){
            runOTH_USRS=false;
            return true;
        }else{
            return runOTH_USRS;
        }
    }
    public static boolean runOTH_SRIOnce(){
        if(runOTH_SRI){
            runOTH_SRI=false;
            return true;
        }else{
            return runOTH_SRI;
        }
    }
    public static boolean runSSOAD_TriggerOnce(){
        if(runSSOAD_Trigger){
            runSSOAD_Trigger=false;
            return true;
        }else{
            return runSSOAD_Trigger;
        }
    } 
    public static boolean runOTH_SEAOnce(){
        if(runOTH_SEA){
            runOTH_SEA=false;
            return true;
        }else{
            return runOTH_SEA;
        }
    }  
    public static boolean runMSSSSOBOnce(){
        if(runMSSSSOB){
            runMSSSSOB=false;
            return true;
        }else{
            return runMSSSSOB;
        }
    }
    public static boolean runSSTH_UVCOnce(){
        if(runSSTH_UVC){
            runSSTH_UVC=false;
            return true;
        }else{
            return runSSTH_UVC;
        }
    }
    
    public static boolean runSSTH_UPONOnce(){
        if(runSSTH_UPON){
            runSSTH_UPON=false;
            return true;
        }else{
            return runSSTH_UPON;
        }
    }
     public static boolean runSSTH_TRLCROnce(){
        if(runSSTH_TRLCR ){
            runSSTH_TRLCR =false;
            return true;
        }else{
            return runSSTH_TRLCR ;
        }
    }
     public static boolean runSSTH_UVCTOnce(){
        if(runSSTH_UVCT){
            runSSTH_UVCT=false;
            return true;
        }else{
            return runSSTH_UVCT;
        }
    }
    public static boolean runSSTH_USVTOnce(){
        if(runSSTH_USVT){
            runSSTH_USVT=false;
            return true;
        }else{
            return runSSTH_USVT;
        }
    }  
    public static boolean runSSTH_UVRFOnce(){
        if(runSSTH_UVRF){
            runSSTH_UVRF=false;
            return true;
        }else{
            return runSSTH_UVRF;
        }
    }  
    public static boolean runSSTH_UOPLDOnce(){
        if(runSSTH_UOPLD){
            runSSTH_UOPLD=false;
            return true;
        }else{
            return runSSTH_UOPLD;
        }
    }
    public static boolean runSSTH_ULELDOnce(){
        if(runSSTH_ULELD){
            runSSTH_ULELD=false;
            return true;
        }else{
            return runSSTH_ULELD;
        }
    }
    //ServiceSheetTriggerHandler control
    public static boolean runSSTH_ULSSDOnce(){
        if(runSSTH_ULSSD){
            runSSTH_ULSSD=false;
            return true;
        }else{
            return runSSTH_ULSSD;
        }
    }
    
   
    
    
    public static boolean resetRun(){
        if(!run){
            run=true;
            return run;
        }else{            
            return run;
        }
    }
    
    public static boolean runOnce1(){
        if(run1){
            run1=false;
            return true;
        }else{
            return run1;
        }
    }
    
    public static boolean runServiceM8PostOnce(){
        if(runServiceM8PostOnce){
            runServiceM8PostOnce=false;
            return true;
        }else{
            return runServiceM8PostOnce;
        }
    }
}