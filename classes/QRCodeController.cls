public with sharing class QRCodeController {

    public PageReference Cancel() {
        return new pageReference('/'+POID);
    }

    
    public Boolean First { get; set; }
    public Boolean Second{ get; set; }
    Public id POID;
    Public List<POLIWrapper> POLILIST{get;set;}
    Public Map<String,POLIWrapper> POLILISTMap{get;set;}
    Public Map<Id,List<POLIWrapper>> POLIMapLIST{get;set;}
    Public List<POLIWrapper> POLIWrapperList{get;set;}
    Public String URLString;
    Public String POName{get;set;}
    Public QRCodeController(){
        First =true;
        Second=false;
        POID=ApexPages.currentPage().getparameters().get('id');
        POLILIST = new List<POLIWrapper>();
        POLIMapLIST = new Map<Id,List<POLIWrapper>>();
        System.debug('id=='+POID);
        POLIWrapperList = new List<POLIWrapper>(); 
        POLILISTMap = new Map<String,POLIWrapper>();
        For(PurchaseOrderLineItem__c POLINE :[Select id,Purchase_Order__c,Purchase_Order__r.name,Total_Received_Quantity__c,Name,Product__r.Name,Product__r.ProductCode,Product__r.Supplier_Product_Code__c,Product__r.Min_Stock__c,Product__r.Maximum_stock_level__c  from PurchaseOrderLineItem__c where Purchase_Order__c=:POID] ){
            POName=POLINE.Purchase_Order__r.Name;
            if(POLINE.Product__r.ProductCode!=null){
                
                //URLString ='https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl='+POLINE.Product__r.ProductCode;
                URLString ='https://quickchart.io/qr/?chs=250x250&cht=qr&text='+POLINE.Product__r.ProductCode;
                System.debug('URLString>>'+URLString);
            }
            else
                URLString='No Supplier Code';
            POLILIST.add(new POLIWrapper(URLString,POLINE.Product__r.Name,POLINE.Product__r.Supplier_Product_Code__c,POLINE.Product__r.ProductCode,POLINE.Product__r.Min_Stock__c,POLINE.Product__r.Maximum_stock_level__c,POLINE.Total_Received_Quantity__c,POLINE.Total_Received_Quantity__c,POLINE.id));
        }
    }
    Public Class POLIWrapper{
        Public String URL{get;set;}
        Public String PrdouctName{get;set;}
        Public String SupplierCode{get;set;}
        Public String ProductCode{get;set;}
        Public Decimal MinStock{get;set;}
        Public Decimal MaxStock{get;set;}
        Public Decimal RecivedQty{get;set;}
        Public Decimal LabelQty{get;set;}
        Public String POLIID{get;set;}
        
        
        
        
        Public POLIWrapper(String URL,String PrdouctName,String SupplierCode,String ProductCode,Decimal min,Decimal max,Decimal RecivedQty,Decimal LabelQty,String POLIID){
            this.URL=URL;
            this.PrdouctName=PrdouctName;
            this.SupplierCode=SupplierCode;
            this.ProductCode=ProductCode;
            this.MinStock=min;
            this.MaxStock=max;
            this.RecivedQty=RecivedQty;
            this.LabelQty=LabelQty;
            this.POLIID=POLIID;
            System.debug('URL'+URL);
        }
        
    }
    
    // Determines what kind of rendering to use for the page request
    public String renderingService { get; private set; }
    
    // Allow the page to set the PDF file name
    public String renderedFileName { 
        get; 
        set { renderedFileName = this.sanitizeFileName(value); }
    }
    // Rendered content MIME type, used to affect HTTP response
    public String renderedContentType {
        get {
            String renderedContentType = 'text/html'; // the default
            
            if( ! this.renderingAsHtml() ) {
                // Provides a MIME type for a PDF document 
                renderedContentType = 'application/pdf';
                
                // Add a file name for the PDF file
               
            }
            
            return renderedContentType;
        }
    }
    
    // Are we rendering to HTML or PDF?
    public Boolean renderingAsHtml() {
        return ( (renderingService == null) || 
                ( ! renderingService.startsWith('PDF')) );
    }
    
    // Action method to save (or "print") to PDF
    public PageReference saveToPdf() {
        List<PurchaseOrderLineItem__c> POLILists = new List<PurchaseOrderLineItem__c>();
        POLILISTMap = new Map<String,POLIWrapper>();
        for(POLIWrapper POLIW : POLILIST){
            for(Integer i=0; i<POLIW.LabelQty;i++){
            /* if(POLIMapLIST.containskey(POLIW.POLIID)){
             POLIMapLIST.get(POLIW.POLIID).add(new POLIWrapper(POLIW.URL,POLIW.PrdouctName,POLIW.SupplierCode,POLIW.ProductCode,POLIW.MinStock,POLIW.MaxStock,POLIW.RecivedQty,POLIW.LabelQty,POLIW.POLIID));
             }
             else{
             List<POLIWrapper> POWrapper = new List<POLIWrapper>();
             POWrapper.add(new POLIWrapper(POLIW.URL,POLIW.PrdouctName,POLIW.SupplierCode,POLIW.ProductCode,POLIW.MinStock,POLIW.MaxStock,POLIW.RecivedQty,POLIW.LabelQty,POLIW.POLIID));
             POLIMapLIST.put(POLIW.POLIID,POWrapper);
             }
                POLILISTMap.put(POLIW.POLIID+i,new POLIWrapper(POLIW.URL,POLIW.PrdouctName,POLIW.SupplierCode,POLIW.ProductCode,POLIW.MinStock,POLIW.MaxStock,POLIW.RecivedQty,POLIW.LabelQty,POLIW.POLIID));         
             */
              POLIWrapperList.add(new POLIWrapper(POLIW.URL,POLIW.PrdouctName,POLIW.SupplierCode,POLIW.ProductCode,POLIW.MinStock,POLIW.MaxStock,POLIW.RecivedQty,POLIW.LabelQty,POLIW.POLIID));            
            }}
        try{
            //update POLILists;
        }Catch(Exception e){
            
        }
        Second=true;
        first=false;
        renderingService = 'PDF';
        return null;
    }
    
    // Private helper -- basic, conservative santization
    private String sanitizeFileName(String unsafeName) {
        String allowedCharacters = '0-9a-zA-Z-_.';
        String sanitizedName = 
            unsafeName.replaceAll('[^' + allowedCharacters + ']', '');
        // You might also want to check filename length, 
        // that the filename ends in '.pdf', etc.
        return(sanitizedName);
    }
}