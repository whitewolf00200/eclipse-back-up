({
    myAction : function(component, event, helper) {
        document.getElementById('pdf_frame').height = window.innerHeight; 
        var recordId = component.get("v.recordId");
        
        
    },
    afterScriptsLoaded : function(component, event, helper) {
        document.getElementById('pdf_frame').height = window.innerHeight;      
    },
    redirectToRecord : function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId")
        });
        navEvt.fire();
    },
   downloadVFPageAsPDF: function(component, event, helper) {
    var vfPageName = component.get("v.vfPageName");

    var action = component.get("c.generatePDF");
    action.setParams({
      vfPageName: ServiceReport
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var attachmentId = response.getReturnValue();
        var fileURL = "/servlet/servlet.FileDownload?file=" + attachmentId;
        window.open(fileURL, "_blank");
      } else {
        console.error("Failed to generate PDF.");
      }
    });
    $A.enqueueAction(action);
  }
})