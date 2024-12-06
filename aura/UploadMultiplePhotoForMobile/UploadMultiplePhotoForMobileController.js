({
    handleFilesChange: function(component, event, helper) {
        var fileName = "No File Selected..";
        var fileCount=component.find("fileId").get("v.files").length;
        var files='';
        if (fileCount > 0) {
            for (var i = 0; i < fileCount; i++) 
            {
                fileName = component.find("fileId").get("v.files")[i]["name"];
                files=files+','+fileName;
            }
        }
        else
        {
            files=fileName;
        }
        component.set("v.fileName", files);
    },
    uploadFiles: function(component, event, helper) {
        if(component.find("fileId").get("v.files")==undefined)
        {
            helper.showMessage('Select files',false);
            return;
        }
        if (component.find("fileId").get("v.files").length > 0) {
            var s = component.get("v.FilesUploaded");
            var fileName = "";
            var fileType = "";
            var fileCount=component.find("fileId").get("v.files").length;
            if (fileCount > 0) {
                for (var i = 0; i < fileCount; i++) 
                {
                   helper.uploadHelper(component, event,component.find("fileId").get("v.files")[i]);
                }
            }
        } else {
            helper.showMessage("Please Select a Valid File",false);
        }
    }
});